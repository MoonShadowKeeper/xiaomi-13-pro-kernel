[English](README.md) | [Русский](README_ru.md)

# Xiaomi 13 Pro (Nuwa) Custom GKI Kernel

A custom Generic Kernel Image (GKI) built specifically for the Xiaomi 13 Pro (Nuwa). The project focuses on integrating root concealment frameworks and backporting modern memory and networking features while maintaining strict compatibility with vendor modules.

## Features

### Root & Concealment
* SukiSU-Ultra
* SUSFS

### Memory Management
* MGLRU
* DAMON Reclaim
```kconfig
CONFIG_LRU_GEN=y
CONFIG_LRU_GEN_ENABLED=y

CONFIG_DAMON=y
CONFIG_DAMON_VADDR=y
CONFIG_DAMON_PADDR=y
CONFIG_DAMON_RECLAIM=y
```

### Networking
* BBR
* FQ
* WireGuard
```kconfig
CONFIG_TCP_CONG_BBR=y
CONFIG_DEFAULT_BBR=y

CONFIG_NET_SCH_FQ=y

CONFIG_WIREGUARD=y
```

### Filesystem Support
* NTFS3
* ExFAT
```kconfig
CONFIG_NTFS3_FS=y
CONFIG_NTFS3_FS_POSIX_ACL=y

CONFIG_EXFAT_FS=y
```

### TMPFS Enhancements
```kconfig
CONFIG_TMPFS_XATTR=y
CONFIG_TMPFS_POSIX_ACL=y
```

### Build Optimizations
* ThinLTO

## Design Goals

* Stability first
* Daily-driver reliability
* Vendor module compatibility
* Improved multitasking
* Modern networking
* Clean GKI integration
* Root concealment support

Explicitly excluded:
* No CPU overclocking
* No GPU overclocking
* No unsafe scheduler modifications
* No ABI/KMI breaking patches

## Installation

1. Download the AnyKernel3 ZIP from the GitHub Actions artifacts.
2. Boot into a custom recovery (TWRP, OrangeFox) or use the KernelSU/SukiSU application.
3. Flash the AnyKernel3 ZIP file.
4. Reboot the device.

## Building

This kernel is built automatically via a GitHub Actions workflow.

1. Navigate to the **Actions** tab in this repository.
2. Select the **Build Custom GKI Kernel for Xiaomi 13 Pro** workflow.
3. Click **Run workflow**.
4. The compiled AnyKernel3 ZIP will be available as an artifact upon completion.

## Tested Configuration

* Xiaomi 13 Pro (Nuwa)
* Android 13
* Linux 5.15 GKI

## Disclaimer

Flashing a custom kernel carries inherent risks. The maintainer is not responsible for any bricked devices, data loss, or hardware damage. Please ensure you have a backup of your stock `boot.img` before proceeding.

## Credits

* AOSP
* Google GKI
* SukiSU-Ultra
* SUSFS
* AnyKernel3
