#
# Universal Generic System Image (GSI) Lunch Targets for Whole Devices
# Supports any Project Treble compatible device across all manufacturers
#

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/aether_gsi_arm64.mk

COMMON_LUNCH_CHOICES := \
    aether_gsi_arm64-user \
    aether_gsi_arm64-userdebug \
    aether_gsi_arm64-eng
