# Custom ROM Troubleshooting & Compilation Error Solutions

---

## 1. Build Environment & Sync Issues

### Error: `Repo sync fails with error: RPC failed; curl 56 GnuTLS recv error`
* **Root Cause:** Large commit histories or slow network timeouts during git bundle fetch.
* **Solution:** Sync using shallow depth and single branch:
  ```bash
  repo init -u https://android.googlesource.com/platform/manifest -b android-latest-release --depth=1
  repo sync -c -j4 --no-clone-bundle --no-tags --force-sync
  ```

### Error: `ninja: build stopped: subcommand failed. Out of memory / Killed`
* **Root Cause:** Metalava or Clang compiler exhausted host RAM.
* **Solution:** Create an emergency 32 GB swapfile in Ubuntu:
  ```bash
  sudo fallocate -l 32G /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  ```
  Lower Ninja thread parallelism: `export NINJA_ARGS="-j4"` instead of `-j$(nproc)`.

---

## 2. Compilation & Makefile Issues

### Error: `FAILED: Dynamic partition size exceeded: nothing_dynamic_partitions`
* **Root Cause:** The combined size of `system.img`, `system_ext.img`, `product.img`, `vendor.img`, and `odm.img` exceeds the allocated dynamic partitions group limit defined in `BoardConfig.mk`.
* **Solution:**
  1. Inspect partition sizes in `BoardConfig.mk`:
     Ensure `BOARD_NOTHING_DYNAMIC_PARTITIONS_SIZE` is adjusted or enable EROFS lz4 compression:
     ```make
     BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := erofs
     BOARD_EROFS_COMPRESSOR := lz4
     ```
  2. Strip unneeded system packages from `device.mk`.

### Error: `error: undefined symbol: _ZN7android... (libshim / Linker Error)`
* **Root Cause:** MediaTek vendor blobs compiled against older Android C++ Bionic symbols missing in Android 17.
* **Solution:** Provide a vendor shim library (`libshim_mtk`) exporting the missing symbols and add to `device.mk`:
  ```make
  TARGET_LD_SHIM_LIBS += \
      /vendor/lib64/hw/audio.primary.mt6886.so|libshim_mtk.so
  ```

---

## 3. Runtime & Boot Issues

### Bootloop at Boot Animation (Android 17 SELinux Denials)
* **Symptom:** Device displays boot animation continuously (`logcat` reveals `avc: denied`).
* **Root Cause:** Strict SELinux policies in Android 17 blocking MediaTek hardware services or Glyph controllers.
* **Diagnosis:**
  ```bash
  adb logcat -d | grep -i "avc: denied"
  ```
* **Fix:** Convert denials into policy rules using `audit2allow`:
  ```bash
  adb logcat -d | audit2allow -p out/target/product/pacmanpro/root/sepolicy
  ```
  Add the generated rules into `device/nothing/pacmanpro/sepolicy/vendor/`.

### Camera / Audio / Fingerprint Sensor Inoperative
* **Symptom:** Camera app crashes or biometric fingerprint does not illuminate.
* **Root Cause:** Missing proprietary blobs in `vendor/nothing/pacmanpro/`.
* **Verification:** Check `proprietary-files.txt` and ensure all `.so` and `.bin` firmware files were copied from stock firmware dump.
