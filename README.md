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
* **SUSFS v2.1.0+ (Spoofing User Space File System):** Полностью скрывает root-окружение, модули и точки монтирования от банковских приложений и античитов.

### 🧠 Управление памятью
* **MGLRU (Multi-Gen LRU):** Активировано по умолчанию (`CONFIG_LRU_GEN_ENABLED`). Новейший алгоритм от Google для Android 14+, бэкпортированный в 5.15. Масштабно улучшает многозадачность и снижает CPU overhead.
* **DAMON (Data Access MONitor):** Включены `DAMON_VADDR`, `DAMON_PADDR`, и `DAMON_RECLAIM` для умной фоновой регенерации и сжатия памяти без микрофризов.

### 🌐 Сеть (Минимализм и Скорость)
* **BBR & FQ (`CONFIG_TCP_CONG_BBR` + `CONFIG_NET_SCH_FQ`):** Комбинация контроля перегрузки BBR и планировщика пакетов FQ (Fair Queueing) для максимальной пропускной способности и минимального пинга.
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

*Внимание: Все действия вы выполняете на свой страх и риск. Всегда делайте бэкап стандартного `boot.img` перед прошивкой кастомных ядер.*

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
