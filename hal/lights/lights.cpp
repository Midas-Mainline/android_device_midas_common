/*
 * Copyright (C) 2019 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <array>

#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/ioctl.h>
#include <sys/types.h>

#include <aidl/android/hardware/light/BnLights.h>
#include <android-base/logging.h>
#include <android/binder_manager.h>
#include <android/binder_process.h>

using ::aidl::android::hardware::light::BnLights;
using ::aidl::android::hardware::light::HwLight;
using ::aidl::android::hardware::light::HwLightState;
using ::aidl::android::hardware::light::ILights;
using ::aidl::android::hardware::light::LightType;
using ::ndk::ScopedAStatus;
using ::ndk::SharedRefBase;

char const* const BACKLIGHT_FILE = "/sys/class/backlight/panel/brightness";

static int sys_write_int(int fd, int value) {
    char buffer[16];
    size_t bytes;
    ssize_t amount;

    bytes = snprintf(buffer, sizeof(buffer), "%d\n", value);
    if (bytes >= sizeof(buffer)) return -EINVAL;
    amount = write(fd, buffer, bytes);
    return amount == -1 ? -errno : 0;
}

class Lights : public BnLights {
  private:
    std::vector<HwLight> availableLights;

    void addLight(LightType const type, int const ordinal) {
        HwLight light{};
        light.id = availableLights.size();
        light.type = type;
        light.ordinal = ordinal;
        availableLights.emplace_back(light);
    }

    int rgbToBrightness(int color)
    {
	    color = color & 0x00ffffff;
	    return ((77*((color>>16)&0x00ff))
			    + (150*((color>>8)&0x00ff)) + (29*(color&0x00ff))) >> 8;
    }

    void writeLed(const char* path, int color) {
        int fd = open(path, O_WRONLY);
        if (fd < 0) {
            LOG(ERROR) << "COULD NOT OPEN LED_DEVICE " << path;
            return;
        }

        sys_write_int(fd, color);
        close(fd);
    }

  public:
    Lights() : BnLights() {
        addLight(LightType::BACKLIGHT, 0);
    }

    ScopedAStatus setLightState(int id, const HwLightState& state) override {
        if (!(0 <= id && id < availableLights.size())) {
            LOG(ERROR) << "Light id " << (int32_t)id << " does not exist.";
            return ScopedAStatus::fromExceptionCode(EX_UNSUPPORTED_OPERATION);
        }

        int const color = rgbToBrightness(state.color);
        HwLight const& light = availableLights[id];

        int ret = 0;

        switch (light.type) {
            case LightType::BACKLIGHT:
                writeLed(BACKLIGHT_FILE, color/255.f * 24);
                break;
        }

        if (ret == 0) {
            return ScopedAStatus::ok();
        } else {
            return ScopedAStatus::fromServiceSpecificError(ret);
        }
    }

    ScopedAStatus getLights(std::vector<HwLight>* lights) override {
        for (auto i = availableLights.begin(); i != availableLights.end(); i++) {
            lights->push_back(*i);
        }
        return ScopedAStatus::ok();
    }
};

int main() {
    ABinderProcess_setThreadPoolMaxThreadCount(0);

    std::shared_ptr<Lights> light = SharedRefBase::make<Lights>();

    const std::string instance = std::string() + ILights::descriptor + "/default";
    binder_status_t status = AServiceManager_addService(light->asBinder().get(), instance.c_str());

    if (status != STATUS_OK) {
        LOG(ERROR) << "Could not register" << instance;
        // should abort, but don't want crash loop for local testing
    }

    ABinderProcess_joinThreadPool();

    return 1;  // should not reach
}
