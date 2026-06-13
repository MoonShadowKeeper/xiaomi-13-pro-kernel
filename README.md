<div align="center">
  <h1>📱 Кастомное ядро для Xiaomi 13 Pro (Nuwa)</h1>
  <p><b>Строгое, чистое и высокопроизводительное GKI-ядро (SukiSU-Ultra + SUSFS + MGLRU + DAMON)</b></p>
  
  <img src="https://img.shields.io/github/actions/workflow/status/MoonShadowKeeper/xiaomi-13-pro-kernel/build-gki.yml?branch=master&style=for-the-badge&logo=github-actions" alt="Build Status">
  <img src="https://img.shields.io/badge/Kernel-5.15%20GKI-blue?style=for-the-badge&logo=linux" alt="Kernel Version">
  <img src="https://img.shields.io/badge/Device-Xiaomi%2013%20Pro-orange?style=for-the-badge" alt="Device">
</div>

---

## 🚀 О проекте

В этом репозитории настроен автоматический пайплайн (GitHub Actions) для компиляции кристально чистого и высокопроизводительного ядра Generic Kernel Image (GKI) для **Xiaomi 13 Pro (Nuwa)** на базе Android 13 (ветка Linux 5.15).

Конфигурация ядра приведена к строгим стандартам KMI/ABI, без мусорных и экспериментальных опций. Здесь собрано только то, что реально ускоряет устройство и скрывает root, не нарушая стабильность работы стоковой прошивки MIUI/HyperOS.

## ✨ Ключевые особенности

### 🛡️ Безопасность и Root
* **[SukiSU-Ultra](https://github.com/sukisu-ultra/sukisu-ultra):** Продвинутый форк KernelSU с глубокой интеграцией для обхода агрессивных проверок на root.
* **SUSFS v2.1.0+ (Spoofing User Space File System):** Значительно усложняет обнаружение root-окружения приложениями и сервисами.

### 🧠 Управление памятью
* **MGLRU (Multi-Gen LRU):** Современный алгоритм управления памятью от Google, доступный в Android GKI 5.15 и более новых версиях Android. Улучшает многозадачность и снижает количество перезапусков приложений.
* **DAMON (Data Access MONitor):** Подсистема мониторинга памяти с поддержкой DAMON_RECLAIM для более эффективного освобождения редко используемых страниц памяти.

### 🌐 Сеть (Минимализм и Скорость)
* **BBR & FQ (`CONFIG_TCP_CONG_BBR` + `CONFIG_NET_SCH_FQ`):** Комбинация контроля перегрузки BBR и планировщика пакетов FQ (Fair Queueing) для улучшенной работы сети при нестабильных соединениях и сниженной задержки в ряде сценариев.
* **WireGuard:** Встроенная поддержка быстрого VPN-протокола напрямую на уровне ядра.

### 📁 Файловые системы
* **NTFS3 & ExFAT:** Нативная поддержка современных файловых систем. Флешки и внешние диски читаются и пишутся на максимальной скорости без костылей.
* **TMPFS:** Добавлена поддержка XATTR и POSIX_ACL для корректной работы сложных модулей в KernelSU (таких как Mountify).

### ⚙️ Сборка
* **ThinLTO (`LTO=thin`):** Оптимизация на этапе связывания (Link-Time Optimization) сохраняет высокую производительность при вменяемом времени компиляции, не ломая GKI ABI.

## 🛠️ Как собирать (Автоматически)

Вся работа выполняется через GitHub Actions на self-hosted раннере:

1. Перейдите на вкладку [Actions](../../actions) в этом репозитории.
2. Выберите **Build Custom GKI Kernel for Xiaomi 13 Pro**.
3. Нажмите **Run workflow**.
4. Дождитесь завершения (~15-20 минут).
5. После завершения скачайте артефакт `AnyKernel3-Xiaomi-13-Pro-GKI-5.15` со страницы результатов.

## 📦 Установка

> ⚠️ **КРИТИЧЕСКИ ВАЖНО (Особенно для Xiaomi 14T Pro / MediaTek):**
> Устройства на MediaTek очень чувствительны к изменению образов ядра. Несовпадение версии KMI или потеря ключей AVB при перепаковке может привести к ошибке **"Couldn't initialize user 0"** (отвал монтирования зашифрованного раздела `/data`).
> **ОБЯЗАТЕЛЬНО СДЕЛАЙТЕ БЭКАП** ваших стоковых `boot.img` и `init_boot.img` (если есть) перед любыми манипуляциями, чтобы можно было загрузиться обратно через fastboot!

*Внимание: Все действия вы выполняете на свой страх и риск.*

1. Распакуйте скачанный артефакт, чтобы получить готовый `.zip` архив AnyKernel3.
2. Прошейте этот `.zip` архив через **TWRP**, **OrangeFox** или напрямую через приложение **KernelSU / SukiSU** (кнопка Flash ZIP).
3. Перезагрузите устройство.

## 📜 Благодарности
* **AOSP / Google** за базовое дерево GKI.
* **[Команде SukiSU-Ultra](https://github.com/sukisu-ultra/sukisu-ultra)** за потрясающий форк KSU.
* **SimonPunk** за разработку SUSFS.

---
<div align="center">
  <i>Создано с ❤️ автоматическим помощником MoonShadowKeeper</i>
</div>
