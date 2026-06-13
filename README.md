<div align="center">
  <h1>📱 Xiaomi 13 Pro (Nuwa) Custom Kernel</h1>
  <p><b>High-Performance GKI Kernel built with SukiSU-Ultra, SUSFS, and Advanced Networking</b></p>
  
  <img src="https://img.shields.io/github/actions/workflow/status/MoonShadowKeeper/xiaomi-13-pro-kernel/build-gki.yml?branch=master&style=for-the-badge&logo=github-actions" alt="Build Status">
  <img src="https://img.shields.io/badge/Kernel-5.15%20GKI-blue?style=for-the-badge&logo=linux" alt="Kernel Version">
  <img src="https://img.shields.io/badge/Device-Xiaomi%2013%20Pro-orange?style=for-the-badge" alt="Device">
</div>

---

## 🚀 Overview

This repository contains an automated GitHub Actions pipeline to compile a feature-rich, high-performance Generic Kernel Image (GKI) specifically tailored for the **Xiaomi 13 Pro (Nuwa)** on Android 13/14+ (Linux 5.15 branch).

This kernel aims to provide top-tier root hiding capabilities alongside network optimization patches inspired by Wild GKI.

## ✨ Features

### 🛡️ Root & Stealth (Security)
* **[SukiSU-Ultra](https://github.com/sukisu-ultra/sukisu-ultra):** Advanced KernelSU fork with deep integration for bypassing aggressive root detections.
* **SUSFS v2.1.0+ (Spoofing User Space File System):** Fully hides the root environment, modules, and mount spaces from banking apps and anti-cheat software.
* **Baseband Guard (BBG):** Enhanced kernel-level security parameter restricting unauthorized baseband access.

### 🌐 Advanced Networking (Wild GKI Port)
* **BBRv1 TCP Congestion Control:** Improves network throughput and reduces latency.
* **Wireguard:** Built-in VPN protocol support operating directly in kernel space for maximum speed.
* **IP Set & IPv6 NAT:** Advanced firewall manipulation and routing capabilities.
* **TTL / HL Target Support:** Packet manipulation to bypass tethering restrictions.

### 📁 File System Enhancements
* **TMPFS XATTR:** Extended attributes support for tmpfs (Crucial for Mountify).
* **TMPFS POSIX ACL:** Advanced Access Control List support.

## 🛠️ How to Build (Automated)

You do not need a powerful PC to build this kernel. It leverages GitHub Actions:

1. Go to the [Actions tab](../../actions) of this repository.
2. Select **Build Custom GKI Kernel for Xiaomi 13 Pro**.
3. Click **Run workflow**.
4. Wait approximately 45-60 minutes.
5. Once completed, download the `Image-Xiaomi-13-Pro-GKI-5.15` artifact from the run summary.

## 📦 Installation

*Note: Proceed with caution. Always back up your stock `boot.img` before flashing custom kernels.*

1. Extract the downloaded artifact to get the `Image` file.
2. Use tools like **AnyKernel3** to pack this `Image` into a flashable `.zip`.
3. Flash the `.zip` via TWRP, OrangeFox, or directly through the KernelSU / SukiSU app.
4. Alternatively, use tools like `magiskboot` to patch your stock `boot.img` with the new kernel `Image` and flash via fastboot:
   ```bash
   fastboot flash boot new-boot.img
   ```

## 📜 Credits & Acknowledgments
* **AOSP / Google** for the GKI base tree.
* **[SukiSU-Ultra Team](https://github.com/sukisu-ultra/sukisu-ultra)** for the incredible KSU fork.
* **SimonPunk** for SUSFS.
* **Wild GKI** for the networking features inspiration.

---
<div align="center">
  <i>Built with ❤️ by MoonShadowKeeper's automated CI</i>
</div>
