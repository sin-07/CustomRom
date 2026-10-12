#
# Copyright (C) 2026 The Android Open Source Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from generic telephony AOSP configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit device configurations
$(call inherit-product, device/nothing/pacmanpro/device.mk)

# Inherit custom ROM branding, UI styling, and optimizations
$(call inherit-product-if-exists, custom/custom.mk)

# Product specifications
PRODUCT_NAME := aosp_pacmanpro
PRODUCT_DEVICE := pacmanpro
PRODUCT_BRAND := Nothing
PRODUCT_MODEL := Nothing Phone (2a) Plus
PRODUCT_MANUFACTURER := Nothing

# Build fingerprint matching official firmware base
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=PacmanPro \
    TARGET_DEVICE=PacmanPro \
    TARGET_PRODUCT=PacmanPro

PRODUCT_GMS_CLIENTID_BASE := android-nothing
