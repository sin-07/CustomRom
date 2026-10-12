# Changelog

All notable changes to the AetherOS custom ROM project are documented in this file.

## [17.0-ALPHA] - 2026-10-13

### Added
- **Core Architecture:**
  - Initial AOSP Android 17 (branch `android-latest-release`) integration.
  - Universal Treble Generic System Image (GSI) target (`aether_gsi_arm64`) for Whole Devices.
- **Nothing Phone (2a) Plus (`pacmanpro`):**
  - Full device tree targeting MediaTek Dimensity 7350 Pro (MT6886).
  - Virtual A/B with dynamic partitions (`super.img`) and EROFS compression.
  - Hardware Glyph Interface AIDL HAL service (`android.hardware.lights-service.nothing_glyph`).
  - Goodix optical under-display fingerprint sensor mappings and SELinux policies.
  - 120Hz dynamic refresh rate display overlay configurations.
- **AetherOS Customizations:**
  - Responsive window animation scaling (0.85x curve).
  - Hardware camera & microphone killswitch privacy controls.
  - Aggressive Doze battery optimization profile.
  - 80% charging preservation battery threshold limiter.
  - Smooth scrolling physics and HWUI render thread priority elevation.
- **Tooling & Automation:**
  - Automated Ubuntu/WSL2 environment installer (`scripts/01_setup_env.sh`).
  - Shallow repo synchronizer (`scripts/02_sync_source.sh`).
  - Firmware payload blob extractor (`scripts/03_extract_blobs.sh`).
  - Universal GSI build pipeline (`scripts/build_gsi.sh`).
  - Multi-device porting generator (`device/templates/generic_device_port/port_device.sh`).
  - Project static integrity and syntax validator (`scripts/verify_project_syntax.py`).
