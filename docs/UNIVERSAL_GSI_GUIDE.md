# Universal GSI Guide: Running Custom ROM on Whole Devices (Any Android Phone)

---

## 1. How Universal GSI Works
With **Project Treble**, Android divides the operating system into two distinct layers:
1. **System Layer (`system.img`):** The pure Android framework, AOSP system services, custom UI, privacy controls, battery optimizations, and apps.
2. **Vendor Layer (`vendor.img`, `boot.img`):** Hardware Abstraction Layers (HALs), proprietary OEM drivers, and device-specific kernel.

By building **AetherOS Universal GSI (Generic System Image)**, you produce a single `system.img` that can boot on **any** Treble-compliant ARM64 Android device regardless of manufacturer (Google, Samsung, Xiaomi, POCO, OnePlus, Nothing, Motorola, Realme, Transsion, etc.) or chipset (Snapdragon, MediaTek, Exynos, Tensor, Unisoc).

---

## 2. Universal Device Compatibility Matrix

| Category | Requirement | Compatible Devices |
| :--- | :--- | :--- |
| **Architecture** | ARM64 (arm64-v8a / arm64-v9a) | Almost all modern Android smartphones |
| **Treble Support** | Treble-compliant | Any device launched with Android 9 or newer |
| **Partition Scheme** | Seamless Virtual A/B or Dynamic Partitions | All modern Android devices (2020+) |
| **Supported OEMs** | Nothing, Google, Xiaomi, OnePlus, Samsung, Moto, etc. | Universal |

---

## 3. How to Flash Universal GSI on Any Device

### Prerequisites:
- Bootloader unlocked on target device (see [docs/BOOTLOADER_UNLOCKING.md](file:///c:/Users/anike/CODES/CustomRom/docs/BOOTLOADER_UNLOCKING.md)).
- Target device must have stock firmware running normally.

### Step-by-Step Commands:
1. Reboot into bootloader:
   ```bash
   adb reboot bootloader
   ```
2. Disable Android Verified Boot (AVB) verification using empty or disabled vbmeta:
   ```bash
   fastboot flash --disable-verity --disable-verification vbmeta vbmeta.img
   ```
3. Reboot to userspace fastboot (`fastbootd`):
   ```bash
   fastboot reboot fastboot
   ```
4. Erase old system partition:
   ```bash
   fastboot erase system
   ```
5. Flash the universal custom ROM GSI:
   ```bash
   fastboot flash system system.img
   ```
6. Format user data (Required on first install to clear OEM-encrypted data):
   ```bash
   fastboot erase userdata
   ```
7. Reboot device:
   ```bash
   fastboot reboot
   ```

---

## 4. Porting Specific Devices
For devices that need specific custom hardware support (e.g. Glyph LED interfaces, custom alert sliders, motorized cameras), use the automated device tree generator:
```bash
bash device/templates/generic_device_port/port_device.sh <oem> <codename> <platform>
```
Example:
```bash
bash device/templates/generic_device_port/port_device.sh nothing pacmanpro mtk
```
