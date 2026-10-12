# Bootloader Unlocking Guide for Nothing Phone (2a) Plus (`pacmanpro`)

> [!CAUTION]
> Unlocking the bootloader **erases all user data permanently**. Ensure you back up all critical photos, documents, and 2FA authentication tokens prior to starting.

---

## Prerequisites
- USB data cable (original Nothing Type-C cable recommended).
- Windows PC or Linux machine with `adb` and `fastboot` installed from the latest [Android SDK Platform-Tools](https://developer.android.com/tools/releases/platform-tools).
- Device charged to at least 60% battery capacity.

---

## Step-by-Step Procedure

### 1. Enable Developer Options
1. On your Nothing Phone (2a) Plus, open **Settings**.
2. Tap **About phone** > **Software info**.
3. Tap **Build number** repeatedly (7 times) until a popup states: *"You are now a developer!"*

### 2. Enable OEM Unlocking & USB Debugging
1. Go back to **Settings** > **System** > **Developer options**.
2. Toggle on **OEM unlocking** (enter your PIN / Pattern if prompted).
3. Toggle on **USB debugging**.

### 3. Connect to PC and Authorize ADB
1. Connect your device to your computer via USB.
2. In terminal or PowerShell, run:
   ```bash
   adb devices
   ```
3. A prompt will appear on your phone screen: *"Allow USB debugging?"* Check **Always allow from this computer** and tap **Allow**.

### 4. Reboot to Bootloader
1. Reboot the phone into bootloader mode:
   ```bash
   adb reboot bootloader
   ```
2. Verify the fastboot connection:
   ```bash
   fastboot devices
   ```
   *(If no serial number is listed, install the Google USB Driver or MediaTek USB VCOM driver).*

### 5. Execute Bootloader Unlock
1. Execute the unlock command:
   ```bash
   fastboot flashing unlock
   ```
2. The phone screen will present a warning screen with two options:
   - *DO NOT UNLOCK THE BOOTLOADER*
   - *UNLOCK THE BOOTLOADER*
3. Press the **Volume Down** button to highlight **UNLOCK THE BOOTLOADER**.
4. Press the **Power** button to confirm.

### 6. Initial Boot
1. The phone will perform a factory reset and reboot automatically into Nothing OS initial setup.
2. Bootloader is now **UNLOCKED**.
