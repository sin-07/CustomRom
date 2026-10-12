#
# Copyright (C) 2026 The Android Open Source Project
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/nothing/pacmanpro

# Overlay configuration
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# Boot control HAL & Virtual A/B
PRODUCT_PACKAGES += \
    android.hardware.boot-service.default \
    android.hardware.boot-service.default_recovery \
    update_engine \
    update_engine_sideload \
    update_verifier

# Init and Hardware scripts
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init/init.pacmanpro.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.pacmanpro.rc \
    $(LOCAL_PATH)/init/fstab.mt6886:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.mt6886 \
    $(LOCAL_PATH)/init/fstab.mt6886:$(TARGET_COPY_OUT_RAMDISK)/fstab.mt6886

# Audio HAL (AIDL)
PRODUCT_PACKAGES += \
    android.hardware.audio.service-aidl.example \
    android.hardware.bluetooth.audio-impl \
    audio.primary.mt6886

# Biometrics (Under-display optical fingerprint sensor)
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint-service.nothing \
    android.hardware.biometrics.fingerprint-service.example

# Lights / Nothing Glyph Interface Service
PRODUCT_PACKAGES += \
    android.hardware.lights-service.nothing_glyph \
    NothingGlyphService

# Display & Graphics
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.4-service \
    android.hardware.graphics.allocator-aidl-service \
    android.hardware.memtrack-service.example

# Power & Thermal AIDL
PRODUCT_PACKAGES += \
    android.hardware.power-service.example \
    android.hardware.thermal-service.example

# WiFi and Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    android.hardware.bluetooth-service.default

# Sensors AIDL
PRODUCT_PACKAGES += \
    android.hardware.sensors-service.multihal

# Fastbootd
PRODUCT_PACKAGES += \
    fastbootd

# Dalvik Heap Configuration for 8GB/12GB RAM Devices
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# Default System Properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=420 \
    ro.surface_flinger.has_wide_color_display=true \
    ro.surface_flinger.has_HDR_display=true \
    ro.surface_flinger.use_color_management=true \
    ro.surface_flinger.set_idle_timer_ms=1000 \
    ro.surface_flinger.set_touch_timer_ms=200 \
    ro.surface_flinger.default_refresh_rate=120 \
    ro.vendor.display.default_fps=120 \
    ro.vendor.display.dynamic_fps=true \
    ro.telephony.default_network=33,33 \
    ro.hardware.keystore=mobicore \
    ro.crypto.volume.filenames_mode=aes-256-cts \
    ro.crypto.metadata.enabled=true \
    persist.sys.theme=dark \
    persist.sys.glyph_enabled=1

# Include proprietary vendor packages
-include vendor/nothing/pacmanpro/pacmanpro-vendor.mk
