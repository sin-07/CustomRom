#include "GlyphService.h"
#include <android-base/logging.h>
#include <android/binder_manager.h>
#include <android/binder_process.h>

using aidl::android::hardware::light::GlyphService;

int main() {
    ABinderProcess_setThreadPoolMaxThreadCount(0);

    std::shared_ptr<GlyphService> service = ndk::SharedRefBase::make<GlyphService>();
    const std::string instance = std::string(GlyphService::descriptor) + "/default";

    binder_status_t status = AServiceManager_addService(service->asBinder().get(), instance.c_str());
    CHECK_EQ(status, STATUS_OK) << "Failed to register Glyph Light AIDL service.";

    LOG(INFO) << "Nothing Glyph Light AIDL Service started successfully.";
    ABinderProcess_joinThreadPool();
    return EXIT_FAILURE; // Should not reach here
}
