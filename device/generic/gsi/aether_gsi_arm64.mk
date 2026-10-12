#
# Universal Android 17 Generic System Image (GSI) for Whole Devices
# Runs on ANY ARM64 Project Treble device (MediaTek, Qualcomm, Tensor, Exynos, Unisoc)
#

# Inherit from official AOSP GSI base
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_arm64.mk)

# Inherit universal custom ROM customizations, branding, animations, privacy & power
$(call inherit-product, custom/common.mk)

PRODUCT_NAME := aether_gsi_arm64
PRODUCT_DEVICE := generic_arm64
PRODUCT_BRAND := AetherOS
PRODUCT_MODEL := Universal GSI (Android 17)
PRODUCT_MANUFACTURER := OpenSource

# Treble Universal System Properties
PRODUCT_SYSTEM_PROPERTIES += \
    ro.apex.updatable=true \
    ro.system.build.version.release=17 \
    ro.treble.enabled=true \
    persist.sys.phh.mainkeys=0 \
    ro.adb.secure=0

# Include universal overlay for Treble hardware support
PRODUCT_PACKAGE_OVERLAYS += device/generic/gsi/overlay
