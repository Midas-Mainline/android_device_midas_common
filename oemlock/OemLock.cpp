/*
 * Copyright (C) 2020 Joonas Kylmälä
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

#include "OemLock.h"

namespace android {
namespace hardware {
namespace oemlock {
namespace V1_0 {
namespace implementation {

using ::android::hardware::oemlock::V1_0::OemLockStatus;
using ::android::hardware::oemlock::V1_0::OemLockSecureStatus;

Return<void> OemLock::getName(getName_cb _hidl_cb) {
    _hidl_cb(OemLockStatus::OK, "default");
    return Void();
}

Return<OemLockSecureStatus> OemLock::setOemUnlockAllowedByCarrier(bool allowed, const hidl_vec<uint8_t>& signature) {
    (void)allowed;
    (void)signature;
    return OemLockSecureStatus::FAILED;
}

Return<void> OemLock::isOemUnlockAllowedByCarrier(isOemUnlockAllowedByCarrier_cb _hidl_cb) {
    _hidl_cb(OemLockStatus::OK, false);
    return Void();
}

Return<OemLockStatus> OemLock::setOemUnlockAllowedByDevice(bool allowed) {
    (void)allowed;
    return OemLockStatus::FAILED;
}

Return<void> OemLock::isOemUnlockAllowedByDevice(isOemUnlockAllowedByDevice_cb _hidl_cb) {
    _hidl_cb(OemLockStatus::OK, true);
    return Void();
}

}
}
}
}
}
