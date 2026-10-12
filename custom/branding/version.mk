# Custom ROM Branding & Versioning Specification
CUSTOM_ROM_NAME := AetherOS
CUSTOM_ROM_VERSION := 17.0-ALPHA
CUSTOM_ROM_EDITION := Community-Official
CUSTOM_BUILD_DATE := $(shell date +%Y%m%d)

PRODUCT_SYSTEM_PROPERTIES += \
    ro.aether.version=$(CUSTOM_ROM_NAME)-$(CUSTOM_ROM_VERSION)-$(CUSTOM_BUILD_DATE)-$(PRODUCT_DEVICE) \
    ro.aether.build.variant=$(TARGET_BUILD_VARIANT) \
    ro.aether.display.version=$(CUSTOM_ROM_NAME) $(CUSTOM_ROM_VERSION) \
    ro.modversion=$(CUSTOM_ROM_NAME)-$(CUSTOM_ROM_VERSION)
