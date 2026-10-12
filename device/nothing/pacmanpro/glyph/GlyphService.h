#pragma once

#include <aidl/android/hardware/light/BnLights.h>
#include <aidl/android/hardware/light/HwLight.h>
#include <aidl/android/hardware/light/HwLightState.h>
#include <vector>
#include <string>

namespace aidl {
namespace android {
namespace hardware {
namespace light {

class GlyphService : public BnLights {
public:
    GlyphService();
    ::ndk::ScopedAStatus setLightState(int32_t id, const HwLightState& state) override;
    ::ndk::ScopedAStatus getLights(std::vector<HwLight>* lights) override;

private:
    void writeSysfs(const std::string& path, int value);
    std::vector<HwLight> mLights;
};

}  // namespace light
}  // namespace hardware
}  // namespace android
}  // namespace aidl
