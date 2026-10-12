#!/bin/bash
# ==============================================================================
# Universal Device Tree Generator for Any Android Phone
# ==============================================================================
set -e

OEM="$1"
CODENAME="$2"
PLATFORM="$3" # e.g. "qcom", "mtk", "tensor", "exynos"

if [ -z "$OEM" ] || [ -z "$CODENAME" ] || [ -z "$PLATFORM" ]; then
    echo "Usage: $0 <oem> <codename> <platform>"
    echo "Examples:"
    echo "  $0 nothing pacmanpro mtk      (Nothing Phone 2a Plus)"
    echo "  $0 google shiba tensor         (Google Pixel 8)"
    echo "  $0 xiaomi marble qcom          (POCO F5)"
    echo "  $0 oneplus salami qcom         (OnePlus 11)"
    exit 1
fi

TARGET_DIR="device/${OEM}/${CODENAME}"
mkdir -p "${TARGET_DIR}/init" "${TARGET_DIR}/overlay" "${TARGET_DIR}/sepolicy/vendor"

echo "[*] Generating device tree in ${TARGET_DIR}..."

# 1. AndroidProducts.mk
cat << EOF > "${TARGET_DIR}/AndroidProducts.mk"
PRODUCT_MAKEFILES := \$(LOCAL_DIR)/aether_${CODENAME}.mk

COMMON_LUNCH_CHOICES := \
    aether_${CODENAME}-user \
    aether_${CODENAME}-userdebug \
    aether_${CODENAME}-eng
EOF

# 2. aether_<codename>.mk
cat << EOF > "${TARGET_DIR}/aether_${CODENAME}.mk"
\$(call inherit-product, \$(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
\$(call inherit-product, \$(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit device configurations
\$(call inherit-product, device/${OEM}/${CODENAME}/device.mk)

# Inherit Universal Custom ROM base (branding, privacy, battery, modern UI)
\$(call inherit-product, custom/common.mk)

PRODUCT_NAME := aether_${CODENAME}
PRODUCT_DEVICE := ${CODENAME}
PRODUCT_BRAND := ${OEM}
PRODUCT_MODEL := ${CODENAME}
PRODUCT_MANUFACTURER := ${OEM}
EOF

# 3. BoardConfig.mk
cat << EOF > "${TARGET_DIR}/BoardConfig.mk"
DEVICE_PATH := device/${OEM}/${CODENAME}

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := generic
TARGET_SUPPORTS_64_BIT_APPS := true

TARGET_BOOTLOADER_BOARD_NAME := ${CODENAME}
TARGET_NO_BOOTLOADER := true

# Partitions & Virtual A/B
AB_OTA_UPDATER := true
BOARD_USES_VIRTUAL_AB := true
BOARD_USES_VIRTUAL_AB_COMPRESSION := true

BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_EROFS_COMPRESSOR := lz4

# SELinux
BOARD_VENDOR_SEPOLICY_DIRS += \$(DEVICE_PATH)/sepolicy/vendor

-include vendor/${OEM}/${CODENAME}/BoardConfigVendor.mk
EOF

# 4. device.mk
cat << EOF > "${TARGET_DIR}/device.mk"
LOCAL_PATH := device/${OEM}/${CODENAME}

DEVICE_PACKAGE_OVERLAYS += \$(LOCAL_PATH)/overlay

PRODUCT_PACKAGES += \
    android.hardware.boot-service.default \
    fastbootd

-include vendor/${OEM}/${CODENAME}/${CODENAME}-vendor.mk
EOF

echo "[+] Successfully generated device tree for ${OEM} ${CODENAME} (${PLATFORM})!"
echo "    Location: ${TARGET_DIR}"
