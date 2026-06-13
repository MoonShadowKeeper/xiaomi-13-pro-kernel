<div align="center">
  <h1>📱 Кастомное ядро для Xiaomi 13 Pro (Nuwa)</h1>
  <p><b>Высокопроизводительное GKI-ядро с SukiSU-Ultra, SUSFS и продвинутыми сетевыми функциями</b></p>
  
  <img src="https://img.shields.io/github/actions/workflow/status/MoonShadowKeeper/xiaomi-13-pro-kernel/build-gki.yml?branch=master&style=for-the-badge&logo=github-actions" alt="Build Status">
  <img src="https://img.shields.io/badge/Kernel-5.15%20GKI-blue?style=for-the-badge&logo=linux" alt="Kernel Version">
  <img src="https://img.shields.io/badge/Device-Xiaomi%2013%20Pro-orange?style=for-the-badge" alt="Device">
</div>

---

## 🚀 О проекте

В этом репозитории настроен автоматический пайплайн (GitHub Actions) для компиляции функционального и высокопроизводительного ядра Generic Kernel Image (GKI) специально для **Xiaomi 13 Pro (Nuwa)** на базе Android 13/14+ (ветка Linux 5.15).

Это ядро создано для обеспечения максимальной скрытности root-прав, а также содержит патчи сетевой оптимизации, вдохновленные проектом Wild GKI.

## ✨ Основные фичи

### 🛡️ Root и скрытность (Безопасность)
* **[SukiSU-Ultra](https://github.com/sukisu-ultra/sukisu-ultra):** Продвинутый форк KernelSU с глубокой интеграцией для обхода агрессивных проверок на root.
* **SUSFS v2.1.0+ (Spoofing User Space File System):** Полностью скрывает root-окружение, модули и точки монтирования от банковских приложений и античитов.
* **Baseband Guard (BBG):** Улучшенный параметр безопасности на уровне ядра, ограничивающий несанкционированный доступ к модему.

### 🌐 Продвинутая сеть (Порт из Wild GKI)
* **Контроль перегрузки BBRv1 TCP:** Увеличивает пропускную способность сети и снижает пинг.
* **Wireguard:** Встроенная поддержка VPN-протокола, работающая напрямую на уровне ядра для максимальной скорости.
* **IP Set & IPv6 NAT:** Продвинутые возможности маршрутизации и манипуляции фаерволом.
* **Поддержка TTL / HL:** Манипуляция пакетами для обхода ограничений операторов на раздачу интернета (Tethering).

### 📁 Улучшения файловой системы
* **TMPFS XATTR:** Поддержка расширенных атрибутов для tmpfs (Критически важно для работы модуля Mountify).
* **TMPFS POSIX ACL:** Продвинутая поддержка списков контроля доступа (ACL).

## 🛠️ Как собирать (Автоматически)

Вам не нужен мощный ПК для компиляции этого ядра. Вся работа выполняется через GitHub Actions (или на подключенном сервере):

1. Перейдите на вкладку [Actions](../../actions) в этом репозитории.
2. Выберите **Build Custom GKI Kernel for Xiaomi 13 Pro**.
3. Нажмите **Run workflow**.
4. Дождитесь завершения (около 15-20 минут на мощном сервере).
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
* **Wild GKI** за вдохновение сетевыми фишками.

---
<div align="center">
  <i>Создано с ❤️ автоматическим помощником MoonShadowKeeper</i>
</div>
