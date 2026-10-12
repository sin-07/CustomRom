# Safe Flashing & Recovery Guide: Nothing Phone (2a) Plus (`pacmanpro`)

> [!IMPORTANT]
> **Safety Notice:** Flashing custom ROM images carries risk of soft-bricking if performed improperly. Never execute automated flashing scripts blindly. Follow each step manually, verify partition slots, and ensure you have stock factory firmware ready for emergency recovery.

---

## 1. Understanding the Nothing Phone (2a) Plus Partition Scheme

The Nothing Phone (2a) Plus utilizes **Virtual A/B with Dynamic Partitions**:
- **Bootloader partitions (Physical):** `boot_a`/`boot_b`, `vendor_boot_a`/`vendor_boot_b`, `dtbo_a`/`dtbo_b`, `vbmeta_a`/`vbmeta_b`.
- **System partitions (Dynamic / Logical inside `super`):** `system`, `system_ext`, `product`, `vendor`, `odm`.
- To flash logical partitions, the device **must be booted into `fastbootd` mode** (userspace fastboot inside recovery), NOT standard bootloader fastboot.

---

## 2. Flashing the Custom ROM (Manual Step-by-Step)

### Step 1: Reboot Device into Bootloader
```bash
adb reboot bootloader
```

### Step 2: Disable AVB Verification (Optional for test builds)
```bash
fastboot flash --disable-verity --disable-verification vbmeta vbmeta.img
fastboot flash --disable-verity --disable-verification vbmeta_system vbmeta_system.img
fastboot flash --disable-verity --disable-verification vbmeta_vendor vbmeta_vendor.img
```

### Step 3: Flash Kernel and Boot Images
```bash
fastboot flash boot boot.img
fastboot flash vendor_boot vendor_boot.img
fastboot flash dtbo dtbo.img
```

### Step 4: Reboot into Userspace Fastboot (`fastbootd`)
```bash
fastboot reboot fastboot
```
*(The device will reboot and display the recovery fastbootd screen with "Fastbootd" header).*

### Step 5: Flash Dynamic Partitions in Fastbootd
```bash
fastboot flash system system.img
fastboot flash system_ext system_ext.img
fastboot flash product product.img
fastboot flash vendor vendor.img
fastboot flash odm odm.img
```

### Step 6: Factory Wipe & Boot
```bash
fastboot erase userdata
fastboot erase metadata
fastboot reboot
```

---

## 3. Recovery & Rollback Procedure (Unbricking)

If the device encounters a bootloop (hangs on Nothing logo or reboots to recovery):

### Rollback Option A: Slot Switching
If the previous working installation was on the opposite slot:
```bash
fastboot --set-active=other
fastboot reboot
```

### Rollback Option B: Restoring Stock Nothing OS Firmware
1. Download the full stock Nothing OS fastboot package for `PacmanPro` (Model `A142P`).
2. Boot into fastboot mode:
   ```bash
   fastboot reboot bootloader
   ```
3. Flash stock boot and vendor partitions:
   ```bash
   fastboot flash boot stock_boot.img
   fastboot flash vendor_boot stock_vendor_boot.img
   fastboot flash dtbo stock_dtbo.img
   fastboot flash vbmeta stock_vbmeta.img
   ```
4. Enter `fastbootd`:
   ```bash
   fastboot reboot fastboot
   ```
5. Restore stock logical partitions:
   ```bash
   fastboot flash super stock_super.img
   fastboot erase userdata
   fastboot reboot
   ```

### Emergency Unbrick (MediaTek BROM Mode / SP Flash Tool / Nothing Flash Tool)
If the device has a blank screen or will not enter bootloader:
1. Power off device completely.
2. Hold **Volume Up + Volume Down** simultaneously.
3. Plug in the USB Type-C cable to PC to trigger MediaTek BROM (COM port mode).
4. Use official authorized MediaTek download agent / Nothing Service Tool with the stock `scatter.xml` / `firmware-update` to flash preloader and partitions.
