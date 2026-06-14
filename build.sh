#!/bin/bash
set -e

# --- Configuration & Defaults ---
DEVICE=${1:-"Xiaomi-13-Pro"}
TARGET_COMMIT=${2:-"bf0a7f319"}
KMI_VERSION=${3:-""}

echo "[+] Starting build process for $DEVICE"
echo "[+] Target commit: ${TARGET_COMMIT:-HEAD}"

# Setup workspace environment
WORKSPACE_DIR="$HOME/kernel_workspace"
mkdir -p "$WORKSPACE_DIR"
cd "$WORKSPACE_DIR"

# Set device-specific variables
if [ "$DEVICE" == "Xiaomi-14T-Pro" ]; then
    DEFAULT_MANIFEST="common-android14-6.1"
    SUSFS_BRANCH="gki-android14-6.1"
    SUSFS_PATCH="50_add_susfs_in_gki-android14-6.1.patch"
    GKI_VERSION="6.1"
else
    DEFAULT_MANIFEST="common-android13-5.15"
    SUSFS_BRANCH="gki-android13-5.15"
    SUSFS_PATCH="50_add_susfs_in_gki-android13-5.15.patch"
    GKI_VERSION="5.15"
fi

MANIFEST_BRANCH=${KMI_VERSION:-$DEFAULT_MANIFEST}
echo "[+] Manifest Branch: $MANIFEST_BRANCH"
echo "[+] GKI Version: $GKI_VERSION"

# --- 1. Clean Workspace ---
echo "[+] Cleaning previous build artifacts..."
rm -rf out/
rm -rf susfs4ksu/
rm -rf AnyKernel3/

# --- 2. Initialize and Sync Kernel Source ---
echo "[+] Initializing repo tool..."
export PATH="$HOME/bin:$PATH"
if [ ! -f "$HOME/bin/repo" ]; then
    mkdir -p "$HOME/bin"
    curl -L https://storage.googleapis.com/git-repo-downloads/repo > "$HOME/bin/repo"
    chmod a+x "$HOME/bin/repo"
fi

echo "[+] Syncing GKI Kernel source (this might take some time)..."
repo init -u https://android.googlesource.com/kernel/manifest -b "$MANIFEST_BRANCH" --depth=1
repo sync -c -j$(nproc) --no-clone-bundle --force-sync

# --- 3. Checkout Specific Commit ---
if [ -n "$TARGET_COMMIT" ]; then
    echo "[+] Transitioning to specific KMI commit: $TARGET_COMMIT"
    cd common
    
    # In 'repo' synced environments, the default remote for 'common' is 'aosp', not 'origin'
    REMOTE_NAME="aosp"
    if ! git remote get-url origin >/dev/null 2>&1; then
        if git remote get-url aosp >/dev/null 2>&1; then
            REMOTE_NAME="aosp"
        fi
    else
        REMOTE_NAME="origin"
    fi
    
    echo "[+] Using git remote: $REMOTE_NAME"
    
    # Fetch commit from remote
    git fetch $REMOTE_NAME --unshallow 2>/dev/null || git fetch $REMOTE_NAME --depth=1000 || true
    
    # Try fetching the exact commit if not available
    if ! git cat-file -e "$TARGET_COMMIT" 2>/dev/null; then
        git fetch https://android.googlesource.com/kernel/common "$TARGET_COMMIT" || true
    fi
    
    # Checkout the target commit
    git checkout "$TARGET_COMMIT"
    echo "[+] Checked out commit $(git rev-parse HEAD)"
    cd "$WORKSPACE_DIR"
fi

# --- 4. Apply SUSFS Patches ---
echo "[+] Cloning SUSFS..."
git clone https://gitlab.com/simonpunk/susfs4ksu.git -b "$SUSFS_BRANCH" susfs4ksu

cd common
echo "[+] Applying SUSFS patches to kernel source..."
git reset --hard HEAD
git clean -fdx

# Copy SUSFS files
cp -rv ../susfs4ksu/kernel_patches/fs/* fs/ || true
cp -rv ../susfs4ksu/kernel_patches/include/linux/* include/linux/ || true

# Apply main patch
patch -p1 < ../susfs4ksu/kernel_patches/"$SUSFS_PATCH" || true

# Manual fixes for fs/namespace.c (Hunk #1)
if ! grep -q 'CONFIG_KSU_SUSFS_SUS_MOUNT' fs/namespace.c; then
    sed -i 's/#include "pnode.h"/#ifdef CONFIG_KSU_SUSFS_SUS_MOUNT\n#include <linux\/susfs_def.h>\n#endif\n\n#include "pnode.h"/g' fs/namespace.c
    sed -i 's/#include "internal.h"/#include "internal.h"\n\n#ifdef CONFIG_KSU_SUSFS_SUS_MOUNT\nextern bool susfs_is_current_ksu_domain(void);\nextern struct static_key_true susfs_is_sdcard_android_data_not_decrypted;\n\n#define CL_COPY_MNT_NS BIT(25)\n#endif/g' fs/namespace.c
fi

# Manual fixes for fs/proc/task_mmu.c (Hunk #1)
if ! grep -q 'CONFIG_KSU_SUSFS_SUS_KSTAT' fs/proc/task_mmu.c; then
    sed -i 's/#include <asm\/elf.h>/#if defined(CONFIG_KSU_SUSFS_SUS_KSTAT) || defined(CONFIG_KSU_SUSFS_SUS_MAP) || defined(CONFIG_KSU_SUSFS_OPEN_REDIRECT)\n#include <linux\/susfs_def.h>\n#endif\n\n#include <asm\/elf.h>/g' fs/proc/task_mmu.c
fi

# --- 5. Apply Sukisu Ultra ---
echo "[+] Integrating Sukisu Ultra..."
curl -LSs "https://raw.githubusercontent.com/sukisu-ultra/sukisu-ultra/main/kernel/setup.sh" | bash -

# --- 6. Integrate KProfiles ---
echo "[+] Integrating KProfiles..."
git clone https://github.com/MoonShadowKeeper/Kprofiles-HyperOS.git drivers/misc/kprofiles
rm -rf drivers/misc/kprofiles/.git

if ! grep -q 'kprofiles' drivers/misc/Kconfig; then
    sed -i '/endmenu/i source "drivers/misc/kprofiles/Kconfig"' drivers/misc/Kconfig
fi

if ! grep -q 'kprofiles' drivers/misc/Makefile; then
    echo 'obj-$(CONFIG_KPROFILES) += kprofiles/' >> drivers/misc/Makefile
fi

# --- 7. Configure Network, Filesystems & GKI Features ---
echo "[+] Applying defconfig customizations..."
sed -i 's/check_defconfig//' build.config.gki || true
sed -i '/GKI_MODULES_LIST/d' build.config.gki.aarch64 || true
sed -i '/KMI_SYMBOL_LIST_STRICT_MODE/d' build.config.gki || true
sed -i '/TRIM_NONLISTED_KMI/d' build.config.gki || true
sed -i 's/-dirty//' scripts/setlocalversion || true

DEFCONFIG="arch/arm64/configs/gki_defconfig"
cat << 'EOF' >> "$DEFCONFIG"

# --- Network Features ---
CONFIG_TCP_CONG_BBR=y
CONFIG_DEFAULT_BBR=y
CONFIG_NET_SCH_FQ=y
CONFIG_WIREGUARD=y

# --- File System Features ---
CONFIG_TMPFS_XATTR=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_NTFS3_FS=y
CONFIG_NTFS3_FS_POSIX_ACL=y
CONFIG_EXFAT_FS=y
CONFIG_EXFAT_DEFAULT_IOCHARSET="utf8"

# --- Memory Management (MGLRU & DAMON) ---
CONFIG_LRU_GEN=y
CONFIG_LRU_GEN_ENABLED=y
CONFIG_LRU_GEN_STATS=y
CONFIG_DAMON=y
CONFIG_DAMON_VADDR=y
CONFIG_DAMON_PADDR=y
CONFIG_DAMON_RECLAIM=y

# --- Battery / Power Management ---
CONFIG_CPU_IDLE_GOV_TEO=y
CONFIG_ENERGY_MODEL=y
CONFIG_SCHED_MC=y

# --- KProfiles (Battery/Balanced/Performance switching) ---
CONFIG_KPROFILES=y

# --- KernelSU KPM ---
CONFIG_KPM=y
EOF

# --- 8. Build the Kernel ---
echo "[+] Compiling kernel..."
cd "$WORKSPACE_DIR"
SKIP_DEFCONFIG_CHECK=1 LTO=thin BUILD_CONFIG=common/build.config.gki.aarch64 build/build.sh

# --- 9. Packaging with AnyKernel3 ---
echo "[+] Packaging build using AnyKernel3..."
git clone https://github.com/MoonShadowKeeper/AnyKernel3.git -b master AnyKernel3
rm -rf AnyKernel3/.git

sed -i "s/kernel.string=.*/kernel.string=Custom GKI $GKI_VERSION (SukiSU-Ultra + SUSFS)/" AnyKernel3/anykernel.sh

mkdir -p AnyKernel3/ramdisk/overlay.d/init
cat << 'EOF' > AnyKernel3/ramdisk/overlay.d/init/kprofiles_fix.rc
on post-fs-data
    # Ждем появления sysfs kprofiles и отключаем авто-смену профилей по экрану
    wait /sys/module/kprofiles/parameters/auto_kp
    write /sys/module/kprofiles/parameters/auto_kp 0
EOF

KERNEL_IMAGE=$(find out -path "*/dist/Image" | head -n 1)
if [ -z "$KERNEL_IMAGE" ]; then
    echo "[-] ERROR: Kernel Image not found in out/!"
    exit 1
fi
echo "[+] Found kernel image at: $KERNEL_IMAGE"
cp "$KERNEL_IMAGE" AnyKernel3/

# Create a zip package
cd AnyKernel3
ZIP_NAME="AnyKernel3-${DEVICE}-GKI-${GKI_VERSION}.zip"
zip -r "../$ZIP_NAME" *
cd "$WORKSPACE_DIR"

echo "[+] SUCCESS! Created $ZIP_NAME in $WORKSPACE_DIR"
