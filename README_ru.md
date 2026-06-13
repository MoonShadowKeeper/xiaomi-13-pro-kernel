[English](README.md) | [Русский](README_ru.md)

# Xiaomi 13 Pro (Nuwa) Custom GKI Kernel

Кастомное ядро Generic Kernel Image (GKI), собранное специально для Xiaomi 13 Pro (Nuwa). Проект ориентирован на интеграцию фреймворков для сокрытия root-прав и бэкпортирование современных сетевых функций и оптимизаций управления памятью, при этом сохраняя строгую совместимость с вендорскими модулями.

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

Явные исключения:
* No CPU overclocking
* No GPU overclocking
* No unsafe scheduler modifications
* No ABI/KMI breaking patches

## Installation

1. Загрузите ZIP-архив AnyKernel3 из артефактов GitHub Actions.
2. Загрузитесь в кастомное рекавери (TWRP, OrangeFox) или используйте приложение KernelSU/SukiSU.
3. Установите ZIP-архив AnyKernel3.
4. Перезагрузите устройство.

## Building

Это ядро собирается автоматически через GitHub Actions.

1. Перейдите на вкладку **Actions** в этом репозитории.
2. Выберите рабочий процесс **Build Custom GKI Kernel for Xiaomi 13 Pro**.
3. Нажмите **Run workflow**.
4. Скомпилированный ZIP-архив AnyKernel3 будет доступен как артефакт после завершения.

## Tested Configuration

* Xiaomi 13 Pro (Nuwa)
* Android 13
* Linux 5.15 GKI

## Disclaimer

Установка кастомного ядра несет в себе определенные риски. Автор репозитория не несет ответственности за "окирпичивание" устройств, потерю данных или аппаратные повреждения. Пожалуйста, убедитесь, что у вас есть бэкап стандартного `boot.img` перед прошивкой.

## Credits

* AOSP
* Google GKI
* SukiSU-Ultra
* SUSFS
* AnyKernel3
