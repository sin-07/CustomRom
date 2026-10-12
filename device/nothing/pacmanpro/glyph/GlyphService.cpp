#include "GlyphService.h"
#include <android-base/logging.h>
#include <fstream>

namespace aidl {
namespace android {
namespace hardware {
namespace light {

static const std::string GLYPH_FRAME_LED = "/sys/class/leds/aw210xx_led/frame_leds_br";
static const std::string GLYPH_ROUND_LED = "/sys/class/leds/aw210xx_led/round_leds_br";
static const std::string GLYPH_ALL_LED   = "/sys/class/leds/aw210xx_led/all_leds_effect";

GlyphService::GlyphService() {
    HwLight backlight = {.id = 0, .type = LightType::BACKLIGHT, .ordinal = 0};
    HwLight notifications = {.id = 1, .type = LightType::NOTIFICATIONS, .ordinal = 0};
    HwLight attention = {.id = 2, .type = LightType::ATTENTION, .ordinal = 0};

    mLights.push_back(backlight);
    mLights.push_back(notifications);
    mLights.push_back(attention);
}

void GlyphService::writeSysfs(const std::string& path, int value) {
    std::ofstream file(path);
    if (!file.is_open()) {
        LOG(WARNING) << "Failed to open sysfs node: " << path;
        return;
    }
    file << value;
}

::ndk::ScopedAStatus GlyphService::setLightState(int32_t id, const HwLightState& state) {
    // Extract brightness / color component
    int brightness = (state.color >> 24) & 0xFF;
    if (brightness == 0 && state.color != 0) {
        brightness = (state.color & 0xFF);
    }

    if (id == 1 || id == 2) {
        // Trigger Glyph LED notification zone
        writeSysfs(GLYPH_FRAME_LED, brightness);
        writeSysfs(GLYPH_ROUND_LED, brightness);
    }

    return ::ndk::ScopedAStatus::ok();
}

::ndk::ScopedAStatus GlyphService::getLights(std::vector<HwLight>* lights) {
    *lights = mLights;
    return ::ndk::ScopedAStatus::ok();
}

}  // namespace light
}  // namespace hardware
}  // namespace android
}  // namespace aidl
