# Universal Custom ROM Integration Specification
# Inherited by ALL targets (Device-specific trees & Universal Treble GSIs)

# ROM Brand Identity
CUSTOM_ROM_NAME ?= AetherOS
CUSTOM_ROM_VERSION ?= 17.0-UNIVERSAL
CUSTOM_ROM_CODENAME ?= Cinnamon
CUSTOM_BUILD_DATE ?= $(shell date +%Y%m%d)

# Universal Build Properties
PRODUCT_SYSTEM_PROPERTIES += \
    ro.aether.name=$(CUSTOM_ROM_NAME) \
    ro.aether.version=$(CUSTOM_ROM_NAME)-$(CUSTOM_ROM_VERSION)-$(CUSTOM_BUILD_DATE) \
    ro.aether.display.version=$(CUSTOM_ROM_NAME) $(CUSTOM_ROM_VERSION) \
    ro.modversion=$(CUSTOM_ROM_NAME)-$(CUSTOM_ROM_VERSION) \
    ro.aether.build.type=$(TARGET_BUILD_VARIANT) \
    \
    # Modern UI & High-Performance Animation Engine
    persist.sys.animation.scale=0.85 \
    debug.sf.disable_backpressure=1 \
    debug.sf.enable_gl_backpressure=1 \
    debug.sf.early.app.duration=16600000 \
    debug.sf.early.sf.duration=16600000 \
    debug.hwui.render_thread_priority=1 \
    \
    # Enhanced Privacy Controls & Hardware Sensor Guards
    persist.privacy.camera_killswitch=1 \
    persist.privacy.mic_killswitch=1 \
    persist.privacy.clipboard_notify=1 \
    ro.crypto.allow_encrypt_override=false \
    \
    # Universal Battery Optimization & Deep Sleep (Doze)
    pm.sleep_mode=1 \
    ro.ril.disable.power.collapse=0 \
    ro.config.hw_power_saving=true \
    persist.sys.battery.charging_limit=80 \
    persist.sys.smart_doze=1 \
    \
    # Universal Display & Gesture Fluidity
    ro.surface_flinger.use_color_management=true \
    ro.surface_flinger.has_wide_color_display=true \
    ro.surface_flinger.set_idle_timer_ms=1000 \
    ro.surface_flinger.set_touch_timer_ms=200

# Universal Package Overlays
PRODUCT_PACKAGE_OVERLAYS += custom/overlays/branding

# Copy universal power and privacy configurations
PRODUCT_COPY_FILES += \
    custom/configs/powersave/power_optimization.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/power_optimization.xml \
    custom/configs/privacy/privacy_settings.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/privacy_settings.xml
