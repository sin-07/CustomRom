# AetherOS: Custom Android 17 (AOSP) ROM Platform
### Supporting Whole Devices (Universal Treble GSI) & Dedicated Nothing Phone (2a) Plus (`pacmanpro`)

---

## 1. Overview & Multi-Device Architecture

AetherOS is a custom Android 17 ROM engineered for:
1. **Whole Devices (Universal Platform):** A Treble-compliant **Generic System Image (GSI)** (`aether_gsi_arm64`) bootable on **any** ARM64 Android smartphone across all OEMs (Google, Nothing, Xiaomi, Samsung, OnePlus, Motorola, etc.).
2. **Dedicated Target:** Complete hardware device tree for the **Nothing Phone (2a) Plus** (`pacmanpro` / `A142P`), featuring custom AIDL Glyph Interface HAL, optical under-display biometric configurations, and Dimensity 7350 Pro (MT6886) platform tuning.

---

## 2. Hardware Specifications: Nothing Phone (2a) Plus

| Specification | Hardware Detail |
| :--- | :--- |
| **Device Name** | Nothing Phone (2a) Plus |
| **Codenames** | `PacmanPro` / `pacmanpro` (Model: `A142P`), sibling `pacman` |
| **System on Chip** | MediaTek Dimensity 7350 Pro 5G (MT6886, 4nm TSMC) |
| **CPU Architecture**| Octa-core ARMv9-A: 2x Cortex-A715 @ 3.0 GHz + 6x Cortex-A510 @ 2.0 GHz |
| **GPU** | ARM Mali-G610 MC4 |
| **Display** | 6.7" Flexible AMOLED, 1080 x 2412, 120Hz dynamic, HDR10+, 2160Hz PWM |
| **Biometrics** | Under-display optical fingerprint sensor (Goodix / Focaltech) |
| **Cameras** | Rear: 50 MP Main (Samsung GN9, OIS) + 50 MP Ultrawide (Samsung JN1) \| Front: 50 MP |
| **Glyph Interface** | 3 LED strips with 26 addressable zones |
| **Battery & Power** | 5000 mAh Li-Po, 50W wired fast charging |
| **Partition Scheme**| Virtual A/B (Dynamic Partitions in `super.img`: EROFS/F2FS) |
| **Kernel Type** | Linux Kernel 5.15 GKI (Generic Kernel Image) with MT6886 modules |
| **AVB Version** | Android Verified Boot 2.0 (`vbmeta`, `vbmeta_system`, `vbmeta_vendor`) |

---

## 3. Custom ROM Features & Innovations

- **Original Branding:** Clean AetherOS identity, custom versioning, and unified aesthetic.
- **Modern UI & Smooth Animations:** Render thread priority boost, 0.85x responsive animation scale, dynamic Monet color accents, and 120Hz high refresh rate default.
- **Granular Privacy Controls:** Hardware camera & microphone killswitch toggles, clipboard read notifications, and auto-revocation of background permissions.
- **Battery & Thermal Optimizations:** Aggressive deep-sleep Doze profile tuning, 80% charging preservation limiter, and power collapse states for Dimensity 7350 Pro clusters.
- **SELinux Enforcing:** Strict security policies and VINTF compatibility fragments.
- **Hardware Compatibility:** Dedicated Nothing Glyph AIDL HAL service (`android.hardware.lights-service.nothing_glyph`).

---

## 4. Repository Structure

```
CustomRom/
├── README.md                          # Master documentation & device matrix
├── custom/                            # Universal Custom ROM features (All devices & GSI)
│   ├── common.mk                      # Shared branding, animations, privacy, battery
│   ├── branding/                      # ROM version strings and visual identity
│   ├── configs/powersave/             # Aggressive Doze and power profiles
│   ├── configs/privacy/               # Privacy toggles and hardware sensor guards
│   └── overlays/                      # Visual RRO overlays and animation scales
├── device/
│   ├── generic/gsi/                   # Universal GSI target for Whole Devices
│   │   ├── AndroidProducts.mk         # lunch aether_gsi_arm64-userdebug
│   │   ├── aether_gsi_arm64.mk        # Treble GSI product makefile
│   │   └── BoardConfigGsi.mk          # Generic ARM64 board configuration
│   ├── nothing/pacmanpro/             # Dedicated Nothing Phone (2a) Plus tree
│   │   ├── AndroidProducts.mk         # lunch aosp_pacmanpro-userdebug
│   │   ├── aosp_pacmanpro.mk          # Device product definition
│   │   ├── BoardConfig.mk             # Partitions, AVB 2.0, MT6886 kernel flags
│   │   ├── device.mk                  # HAL packages, properties, audio, display
│   │   ├── init/                      # init.pacmanpro.rc & fstab.mt6886
│   │   ├── glyph/                     # Nothing Glyph LED AIDL HAL implementation
│   │   └── sepolicy/vendor/           # SELinux enforcing policies
│   └── templates/generic_device_port/ # Instant porting tool for any new device
│       └── port_device.sh
├── manifests/
│   └── pacmanpro_aosp17.xml           # Repo local manifest for toolchain & kernel
├── scripts/
│   ├── 01_setup_env.sh                # Ubuntu/WSL2 dependency setup
│   ├── 02_sync_source.sh              # Shallow AOSP repo synchronizer
│   ├── 03_extract_blobs.sh            # Proprietary blob extractor
│   ├── 04_build_rom.sh                # Dedicated device build script
│   ├── 05_preflight_check.sh          # Diagnostics & system audit
│   └── build_gsi.sh                   # Universal GSI build script for whole devices
└── docs/
    ├── UNIVERSAL_GSI_GUIDE.md         # Guide for running on any phone
    ├── BOOTLOADER_UNLOCKING.md        # Unlocking instructions
    ├── FLASHING_AND_RECOVERY.md       # Safe fastbootd manual flashing & rollback
    └── TROUBLESHOOTING.md             # Compilation and runtime fix guide
```

---

## 5. Quick Start Guide

### Step 1: Environment Setup (Ubuntu / WSL2)
```bash
bash scripts/01_setup_env.sh
```

### Step 2: Download AOSP Android 17 Source Code
```bash
bash scripts/02_sync_source.sh
```

### Step 3: Run Diagnostics
```bash
bash scripts/05_preflight_check.sh
```

### Step 4: Choose Build Target

#### Option A: Build for Whole Devices (Universal GSI)
Compiles a `system.img` compatible with **any** Treble-enabled phone:
```bash
bash scripts/build_gsi.sh
```

#### Option B: Build Dedicated ROM for Nothing Phone (2a) Plus
Extract vendor blobs and compile the complete full package:
```bash
bash scripts/03_extract_blobs.sh
bash scripts/04_build_rom.sh
```

### Step 5: Verify Functionality (Before and After Flashing)
Refer to [docs/TESTING_AND_VALIDATION.md](file:///c:/Users/anike/CODES/CustomRom/docs/TESTING_AND_VALIDATION.md) for full testing workflows:
```bash
# 1. Run static integrity audit (Windows or Linux):
py -3 scripts/verify_project_syntax.py   # Windows
python3 scripts/verify_project_syntax.py # Linux

# 2. Check live boot status on connected device:
adb shell getprop sys.boot_completed     # Returns '1' when successfully booted
```

### Step 6: Safe Flashing & Recovery
Refer to [docs/FLASHING_AND_RECOVERY.md](file:///c:/Users/anike/CODES/CustomRom/docs/FLASHING_AND_RECOVERY.md) and [docs/UNIVERSAL_GSI_GUIDE.md](file:///c:/Users/anike/CODES/CustomRom/docs/UNIVERSAL_GSI_GUIDE.md) for manual, non-destructive flashing procedures via `fastbootd`.

