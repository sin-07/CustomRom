#!/bin/bash
#
# Copyright (C) 2026 The Android Open Source Project
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=pacmanpro
VENDOR=nothing
ANDROID_ROOT="$(pwd)/../../.."
VENDOR_DIR="${ANDROID_ROOT}/vendor/${VENDOR}/${DEVICE}"

mkdir -p "${VENDOR_DIR}"

cat << 'EOF' > "${VENDOR_DIR}/BoardConfigVendor.mk"
# Generated BoardConfigVendor.mk
EOF

cat << 'EOF' > "${VENDOR_DIR}/pacmanpro-vendor.mk"
# Generated pacmanpro-vendor.mk
LOCAL_STEM := $(shell pwd)

PRODUCT_COPY_FILES += \
    vendor/nothing/pacmanpro/proprietary/etc/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    vendor/nothing/pacmanpro/proprietary/etc/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    vendor/nothing/pacmanpro/proprietary/etc/thermal_throttling.conf:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_throttling.conf

EOF

echo "[*] Vendor makefiles successfully generated in ${VENDOR_DIR}"
