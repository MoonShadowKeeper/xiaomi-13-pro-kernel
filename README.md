<div align="center">
  <h1>🌙 MoonShadow Kernel</h1>
  <p><b>Custom GKI Kernel for Xiaomi 13 Pro & Xiaomi 14T Pro</b></p>
  <p><i>SukiSU-Ultra · SUSFS · ZRAM ZSTD · KProfiles-HyperOS · MGLRU</i></p>
  
  <img src="https://img.shields.io/github/actions/workflow/status/MoonShadowKeeper/xiaomi-13-pro-kernel/build-gki.yml?branch=master&style=for-the-badge&logo=github-actions&label=BUILD" alt="Build Status">
  <img src="https://img.shields.io/badge/GKI-5.15%20%7C%206.1-blue?style=for-the-badge&logo=linux" alt="Kernel Version">
  <img src="https://img.shields.io/badge/Devices-Xiaomi%2013%20Pro%20%7C%2014T%20Pro-orange?style=for-the-badge" alt="Devices">
  <img src="https://img.shields.io/badge/LTO-ThinLTO-green?style=for-the-badge" alt="LTO">
</div>

---

## 📋 Поддерживаемые устройства

| Устройство | Кодовое имя | SoC | Ядро | Android |
|-----------|-------------|-----|------|---------|
| **Xiaomi 13 Pro** | `nuwa` | Snapdragon 8 Gen 2 | GKI 5.15 (android13-5.15) | 13+ |
| **Xiaomi 14T Pro** | `rothko` | Dimensity 9300+ | GKI 6.1 (android14-6.1) | 14+ |

## 🚀 О проекте

Автоматизированная сборка чистого GKI-ядра через GitHub Actions. Никаких нестабильных хаков — только проверенные, upstream-совместимые фичи поверх эталонного ядра AOSP.

**Наши принципы:**
- **Строгое соответствие KMI/ABI:** Вендорские модули (Wi-Fi, камера, звук) работают без сбоев.
- **Никакого мусора:** Каждая опция тестируется и верифицируется в итоговом `.config`.
- **Фокус на HyperOS:** Ядро создано с учетом агрессивного таск-киллера и троттлинга прошивок Xiaomi.

---

## ✨ Ключевые особенности

### ⚡ Эксклюзивно для HyperOS
| Фича | Описание |
|------|----------|
| **KProfiles-HyperOS** | Собственный форк. Напрямую слушает системный PowerHAL (`sconfig`). Игнорирует команды троттлинга от `joyose` в режиме "Производительность" (идеально для игр). |
| **ZRAM ZSTD** | Ультра-сжатие оперативной памяти (вместо устаревшего LZ4). Позволяет HyperOS удерживать огромное количество тяжелых фоновых приложений без перезапуска. |

### 🛡️ Root & Скрытие
| Фича | Описание |
|------|----------|
| **SukiSU-Ultra** | Продвинутый форк KernelSU с улучшенной интеграцией для обхода проверок безопасности (SafetyNet / Play Integrity). |
| **SUSFS v2.1.0+** | Spoofing User Space File System. Изолирует root-окружение, делая его полностью невидимым для банковских приложений и игр. |

### 🧠 Планировщик & Батарея
| Фича | Описание |
|------|----------|
| **MGLRU & DAMON** | Умное освобождение редко используемых страниц памяти от Google (Multi-Gen LRU). |
| **TEO cpuidle** | Интеллектуальный выбор глубины сна процессора. Резко снижает ненужные пробуждения ядер. |
| **Energy Model & MC** | Energy Aware Scheduling знает энергоцену каждой частоты. Задачи пакуются плотнее, позволяя остальным ядрам уходить в глубокий `deep idle`. |

### 🌐 Сеть & Файловые системы
| Фича | Описание |
|------|----------|
| **BBR + FQ** | Передовой контроль перегрузки TCP. Уменьшает пинг и потерю пакетов на плохом мобильном интернете. |
| **WireGuard** | Нативная поддержка быстрого VPN-протокола на уровне ядра. |
| **NTFS3 & ExFAT** | Нативное чтение и запись флешек/внешних дисков без использования медленного FUSE. |

---

## 🛠️ Как собрать

1. Перейдите на вкладку **[Actions](../../actions)**.
2. Выберите **Build Custom GKI Kernel**.
3. Нажмите **Run workflow**.
4. Выберите ваше устройство (`Xiaomi-13-Pro` или `Xiaomi-14T-Pro`).
5. Оставьте остальные поля пустыми (будет использован свежий коммит исходников).
6. Дождитесь завершения сборки (~15–20 минут).
7. Скачайте ZIP-архив из раздела **Artifacts**.

---

## 📦 Установка

> [!CAUTION]
> **Обязательно сделайте бэкап** стоковых `boot.img` и `init_boot.img` перед прошивкой!
> Устройства на MediaTek (Xiaomi 14T Pro) особенно чувствительны к изменению образов ядра. Все действия выполняются на ваш страх и риск.

**Через ADB Sideload (TWRP/OrangeFox):**
```bash
adb sideload AnyKernel3-Xiaomi-13-Pro-GKI-5.15.zip
```

**Через интерфейс Recovery:**
1. Скопируйте скачанный ZIP на телефон.
2. Загрузитесь в TWRP или OrangeFox.
3. Нажмите **Install** → выберите ZIP → сделайте свайп для прошивки.
4. Перезагрузите устройство.

---

## 🔍 Верификация

Проверьте, что фичи успешно активировались:
```bash
# Версия ядра
adb shell uname -a

# Проверка активации алгоритма ZSTD для ZRAM
adb shell cat /sys/block/zram0/comp_algorithm

# Статус KProfiles (0=Disabled, 1=Battery, 2=Balanced, 3=Performance)
adb shell cat /sys/kernel/kprofiles/kp_mode
```

---

<div align="center">
  <i>MoonShadow Kernel — собрано с ❤️ by MoonShadowKeeper</i>
</div>
