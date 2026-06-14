<div align="center">
  <h1>🌙 MoonShadow Kernel</h1>
  <p><b>Custom GKI Kernel for Xiaomi 13 Pro & Xiaomi 14T Pro</b></p>
  <p><i>SukiSU-Ultra · SUSFS · MGLRU · DAMON · BBR · WireGuard</i></p>
  
  <img src="https://img.shields.io/github/actions/workflow/status/MoonShadowKeeper/xiaomi-13-pro-kernel/build-gki.yml?branch=master&style=for-the-badge&logo=github-actions&label=BUILD" alt="Build Status">
  <img src="https://img.shields.io/badge/GKI-5.15%20%7C%206.1-blue?style=for-the-badge&logo=linux" alt="Kernel Version">
  <img src="https://img.shields.io/badge/Devices-Xiaomi%2013%20Pro%20%7C%2014T%20Pro-orange?style=for-the-badge" alt="Devices">
  <img src="https://img.shields.io/badge/LTO-ThinLTO-green?style=for-the-badge" alt="LTO">
</div>

---

## 📋 Поддерживаемые устройства

| Устройство | Кодовое имя | SoC | Ядро | Android |
|-----------|-------------|-----|------|---------|
| Xiaomi 13 Pro | nuwa | Snapdragon 8 Gen 2 | GKI 5.15 (android13-5.15) | 13+ |
| Xiaomi 14T Pro | rothko | Dimensity 9300+ | GKI 6.1 (android14-6.1) | 14+ |

## 🚀 О проекте

Автоматизированная сборка чистого GKI-ядра через GitHub Actions на self-hosted runner. Никаких экспериментальных патчей, оверклоков и нестабильных хаков — только проверенные, upstream-совместимые фичи поверх эталонного ядра AOSP.

**Принципы:**
- Строгое соответствие KMI/ABI — вендорские модули (Wi-Fi, камера, аудио) работают без изменений
- Каждая опция проверяется в итоговом `.config` после сборки
- Отдельные ветки и конфиги для каждого устройства

## ✨ Ключевые особенности

### ⚡ HyperOS Optimization

| Компонент | Описание |
|-----------|----------|
| Kprofiles-HyperOS | Нативная интеграция с PowerHAL (sconfig) и блокировка системного троттлинга `joyose` в производительном режиме |
| ZRAM ZSTD | Сжатие ZRAM переведено на ZSTD + zsmalloc для максимального удержания фоновых приложений в HyperOS |


### 🛡️ Root & Скрытие

| Компонент | Описание |
|-----------|----------|
| [SukiSU-Ultra](https://github.com/sukisu-ultra/sukisu-ultra) | Продвинутый форк KernelSU с улучшенной интеграцией для обхода проверок на root |
| [SUSFS v2.1.0+](https://gitlab.com/simonpunk/susfs4ksu) | Spoofing User Space File System — усложняет обнаружение root-окружения приложениями |

### 🧠 Управление памятью

| Компонент | Kconfig | Описание |
|-----------|---------|----------|
| MGLRU | `CONFIG_LRU_GEN=y` | Multi-Gen LRU от Google. Улучшает многозадачность и снижает количество перезапусков приложений |
| DAMON | `CONFIG_DAMON=y` | Data Access MONitor с поддержкой `DAMON_RECLAIM` для эффективного освобождения редко используемых страниц |
| ZRAM | `CONFIG_ZRAM=y` | Сжатие оперативной памяти в RAM (zsmalloc) |

### 🌐 Сеть

| Компонент | Kconfig | Описание |
|-----------|---------|----------|
| BBR + FQ | `CONFIG_TCP_CONG_BBR=y` + `CONFIG_NET_SCH_FQ=y` | Контроль перегрузки TCP + планировщик Fair Queueing. Снижает задержку на нестабильных соединениях |
| WireGuard | `CONFIG_WIREGUARD=y` | Быстрый VPN-протокол на уровне ядра |

### 📁 Файловые системы

| Компонент | Kconfig | Описание |
|-----------|---------|----------|
| NTFS3 | `CONFIG_NTFS3_FS=y` | Нативное чтение/запись NTFS-дисков без FUSE |
| ExFAT | `CONFIG_EXFAT_FS=y` | Поддержка ExFAT для флешек и SD-карт |
| TMPFS ACL | `CONFIG_TMPFS_POSIX_ACL=y` | Нужно для корректной работы модулей KernelSU (Mountify и др.) |

### 🔋 Батарея и энергоэффективность

| Компонент | Kconfig | Описание |
|-----------|---------|----------|
| ZRAM ZSTD | `CONFIG_ZRAM_DEF_COMP_ZSTD=y` | Ультра-сжатие ZRAM для удержания огромного числа фоновых процессов без убивания их системой |
| TEO cpuidle | `CONFIG_CPU_IDLE_GOV_TEO=y` | Умный выбор глубины сна для ядер CPU. Меньше ненужных пробуждений |
| Energy Model | `CONFIG_ENERGY_MODEL=y` | EAS знает энергоцену каждой частоты |
| MC Scheduling | `CONFIG_SCHED_MC=y` | Задачи пакуются на меньше ядер → остальные уходят в deep idle |
| KProfiles-HyperOS | `CONFIG_KPROFILES=y` | Умное переключение режимов Battery/Balanced/Performance с интеграцией в шторку HyperOS и антитроттлингом |

### ⚙️ Сборка

| Параметр | Значение | Описание |
|----------|----------|----------|
| LTO | ThinLTO | Link-Time Optimization без нарушения GKI ABI |
| Defconfig | AOSP gki_defconfig + наши дополнения | Базовый конфиг Google + только проверенные опции |

## 🛠️ Как собрать

1. Перейдите на вкладку **[Actions](../../actions)**
2. Выберите **Build Custom GKI Kernel**
3. Нажмите **Run workflow**
4. Выберите устройство: `Xiaomi-13-Pro` или `Xiaomi-14T-Pro`
5. *(Опционально)* Укажите конкретную KMI-ветку (например `common-android13-5.15-2024-04`)
6. Дождитесь завершения (~15–20 минут)
7. Скачайте артефакт `AnyKernel3-<Device>-GKI-<version>` со страницы результатов

## 📦 Установка

> [!CAUTION]
> **Обязательно сделайте бэкап** стоковых `boot.img` и `init_boot.img` перед прошивкой!
> Устройства на MediaTek (Xiaomi 14T Pro) особенно чувствительны к изменению образов ядра.
> Несовпадение KMI может привести к ошибке монтирования `/data`.

**Все действия вы выполняете на свой страх и риск.**

### Через ADB Sideload (TWRP/OrangeFox):
```bash
adb sideload AnyKernel3-Xiaomi-13-Pro-GKI-5.15.zip
```

### Через Recovery:
1. Скопируйте ZIP на устройство
2. Загрузитесь в TWRP/OrangeFox
3. Install → выберите ZIP → прошейте
4. Перезагрузите устройство

## 🔍 Верификация после прошивки

Проверьте, что все фичи работают:
```bash
# Проверка версии ядра
adb shell uname -a

# Проверка MGLRU
adb shell cat /sys/kernel/mm/lru_gen/enabled

# Проверка BBR
adb shell sysctl net.ipv4.tcp_congestion_control

# Проверка ZRAM
adb shell cat /proc/swaps

# Проверка WireGuard
adb shell cat /sys/module/wireguard/version

# Проверка KProfiles
adb shell cat /sys/kernel/kprofiles/kp_mode

# Переключение KProfiles:
# 0=Disabled  1=Battery  2=Balanced  3=Performance
adb shell 'echo 1 > /sys/kernel/kprofiles/kp_mode'  # Battery mode
```

## 📜 Благодарности

- **AOSP / Google** — базовое дерево GKI
- **[SukiSU-Ultra](https://github.com/sukisu-ultra/sukisu-ultra)** — форк KernelSU
- **[SimonPunk](https://gitlab.com/simonpunk/susfs4ksu)** — SUSFS
- **[osm0sis](https://github.com/osm0sis/AnyKernel3)** — AnyKernel3

---

<div align="center">
  <i>MoonShadow Kernel — собрано с ❤️ by MoonShadowKeeper</i>
</div>
