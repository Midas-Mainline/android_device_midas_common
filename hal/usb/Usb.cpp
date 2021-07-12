/*
 * Copyright (C) 2017-2018 The LineageOS Project
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
#include <assert.h>
#include <dirent.h>
#include <iostream>
#include <fstream>
#include <pthread.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

#include <cutils/uevent.h>
#include <sys/epoll.h>
#include <android-base/logging.h>
#include <utils/Errors.h>
#include <utils/StrongPointer.h>

#include "Usb.h"

namespace android {
namespace hardware {
namespace usb {
namespace V1_0 {
namespace implementation {

const std::string LINE_DELIM = "\n";
const std::string VARIABLE_DELIM = "=";

// Set by the signal handler to destroy the thread
volatile bool destroyThread;

static std::mutex gSuspendMutex;
static sp<IWakeLock> gSuspendBlocker = nullptr;

Return<void> Usb::switchRole(const hidl_string &portName __unused,
                             const PortRole &newRole __unused) {
    ALOGE("%s: Not supported", __func__);
    return Void();
}

static const sp<ISystemSuspend>& getSystemSuspendServiceOnce() {
    static sp<ISystemSuspend> suspendService = ISystemSuspend::getService();
    return suspendService;
}

static int acquire_wake_lock() {
    const auto& suspendService = getSystemSuspendServiceOnce();
    if (!suspendService) {
        ALOGE("ISystemSuspend::getService() failed.");
        return -1;
    }

    std::lock_guard<std::mutex> l{gSuspendMutex};
    if (!gSuspendBlocker) {
        gSuspendBlocker = suspendService->acquireWakeLock(WakeLockType::PARTIAL, "UsbGadget.WakeLock");
    }
    return 0;
}

static int release_wake_lock() {
    std::lock_guard<std::mutex> l{gSuspendMutex};
    if (gSuspendBlocker) {
        auto ret = gSuspendBlocker->release();
        if (!ret.isOk()) {
            ALOGE("IWakeLock::release() call failed: %s", ret.description().c_str());
        }
        gSuspendBlocker.clear();
        return 0;
    }
    return -1;
}

static int32_t readFile(std::string filename, std::string& contents) {
    std::ifstream file(filename);
    if (file.is_open()) {
        std::stringstream buffer;
        buffer << file.rdbuf();
        contents = buffer.str();
        file.close();
        return 0;
    }
    return -1;
}

static int32_t retrieveExtconState(std::vector<std::string> *extconModeList) {

        std::string filename = "/sys/class/extcon/extcon0/state";
        std::string extconModeContent;

        if (readFile(filename, extconModeContent)) {
                ALOGE("could not read extcon file");
                return -1;
        }

        auto start = 0U;
        auto end = extconModeContent.find(LINE_DELIM);

        while (end != std::string::npos)
        {
                std::string currentLine = extconModeContent.substr(start, end - start);

                std::size_t variableEnd = currentLine.find(VARIABLE_DELIM);
                std::string key = currentLine.substr(0, variableEnd);
                std::string value = currentLine.substr(variableEnd + 1, currentLine.length());
                
                if (std::stoi(value, nullptr, 10)) {
                        extconModeList->emplace_back(key);
                }

                start = end + LINE_DELIM.length();
                end = extconModeContent.find(LINE_DELIM, start);
        }

        return 0;
}

static PortDataRole determineDataRole(std::vector<std::string> *extconModeList) {
    if (std::find(extconModeList->begin(), extconModeList->end(), "USB") != extconModeList->end()) {
        return PortDataRole::DEVICE;
    } else if (std::find(extconModeList->begin(), extconModeList->end(), "USB-HOST") != extconModeList->end()) {
        return PortDataRole::HOST;
    } else {
        return PortDataRole::NONE;
    }
}

static PortPowerRole determinePowerRole(std::vector<std::string> *extconModeList) {
    if (std::find(extconModeList->begin(), extconModeList->end(), "USB") != extconModeList->end()) {
        return PortPowerRole::SINK;
    } else if (std::find(extconModeList->begin(), extconModeList->end(), "USB-HOST") != extconModeList->end()) {
        return PortPowerRole::SOURCE;
    } else {
        return PortPowerRole::NONE;
    }
}

static PortMode determineMode(std::vector<std::string> *extconModeList) {
    if (std::find(extconModeList->begin(), extconModeList->end(), "USB") != extconModeList->end()) {
        return PortMode::UFP;
    } else if (std::find(extconModeList->begin(), extconModeList->end(), "USB-HOST") != extconModeList->end()) {
        return PortMode::DFP;
    } else {
        return PortMode::NONE;
    }
}

Return<void> Usb::queryPortStatus() {
    hidl_vec<PortStatus> currentPortStatus;
    std::vector<std::string> extconModeList;

    if (mCallback == NULL) {
        release_wake_lock();
        return Void();
    }

    pthread_mutex_lock(&mLock);
    if (!retrieveExtconState(&extconModeList)) {
        
        currentPortStatus.resize(1);

        currentPortStatus[0].portName = "otg_default";
        currentPortStatus[0].currentDataRole = determineDataRole(&extconModeList);
        currentPortStatus[0].currentPowerRole = determinePowerRole(&extconModeList);
        currentPortStatus[0].currentMode = determineMode(&extconModeList);
        currentPortStatus[0].canChangeMode = false;
        currentPortStatus[0].canChangeDataRole = false;
        currentPortStatus[0].canChangePowerRole = false;
        currentPortStatus[0].supportedModes = currentPortStatus[0].currentMode;

        Return<void> ret =
                mCallback->notifyPortStatusChange(currentPortStatus, Status::SUCCESS);
        if (!ret.isOk()) {
            ALOGE("queryPortStatus error %s", ret.description().c_str());
            release_wake_lock();
        } else if (currentPortStatus[0].currentMode == PortMode::NONE) {
            ALOGD("queryPortStatus succesful, current mode is: none, releasing wake lock");
            release_wake_lock();
        } else {
            ALOGD("queryPortStatus succesful, current mode is: %d, acquiring wake lock", currentPortStatus[0].currentMode);
            acquire_wake_lock();
        }
    } else {
        ALOGE("queryPortStatus failed, could not retrieve extcon state from sysfs");
            Return<void> ret =
                mCallback->notifyPortStatusChange(currentPortStatus, Status::ERROR);
        release_wake_lock();
    }
    pthread_mutex_unlock(&mLock);
    return Void();
}

struct data {
    int uevent_fd;
    android::hardware::usb::V1_0::implementation::Usb *usb;
};

static void uevent_event(uint32_t /*epevents*/, struct data *payload) {
    char msg[UEVENT_MSG_LEN + 2];
    char *cp;
    int n;

    n = uevent_kernel_multicast_recv(payload->uevent_fd, msg, UEVENT_MSG_LEN);
    if (n <= 0)
        return;
    if (n >= UEVENT_MSG_LEN)   /* overflow -- discard */
        return;

    msg[n] = '\0';
    msg[n + 1] = '\0';
    cp = msg;

    while (*cp) {
        if (!strcmp(cp, "SUBSYSTEM=extcon")) {
            if (payload->usb->mCallback != NULL) {
                payload->usb->queryPortStatus();
            }
            break;
        }
        /* advance to after the next \0 */
        while (*cp++);
    }
}

void* work(void* param) {
    int epoll_fd, uevent_fd;
    struct epoll_event ev;
    int nevents = 0;
    struct data payload;

    uevent_fd = uevent_open_socket(64*1024, true);

    if (uevent_fd < 0) {
        ALOGE("uevent_init: uevent_open_socket failed\n");
        return NULL;
    }

    payload.uevent_fd = uevent_fd;
    payload.usb = (android::hardware::usb::V1_0::implementation::Usb *)param;

    fcntl(uevent_fd, F_SETFL, O_NONBLOCK);

    ev.events = EPOLLIN;
    ev.data.ptr = (void *)uevent_event;

    epoll_fd = epoll_create(64);
    if (epoll_fd == -1) {
        ALOGE("epoll_create failed; errno=%d", errno);
        goto error;
    }

    if (epoll_ctl(epoll_fd, EPOLL_CTL_ADD, uevent_fd, &ev) == -1) {
        ALOGE("epoll_ctl failed; errno=%d", errno);
        goto error;
    }

    while (!destroyThread) {
        struct epoll_event events[64];

        nevents = epoll_wait(epoll_fd, events, 64, -1);
        if (nevents == -1) {
            if (errno == EINTR)
                continue;
            ALOGE("usb epoll_wait failed; errno=%d", errno);
            break;
        }

        for (int n = 0; n < nevents; ++n) {
            if (events[n].data.ptr)
                (*(void (*)(int, struct data *payload))events[n].data.ptr)
                    (events[n].events, &payload);
        }
    }

    ALOGI("exiting worker thread");
error:
    close(uevent_fd);

    if (epoll_fd >= 0)
        close(epoll_fd);

    return NULL;
}

void sighandler(int sig)
{
    if (sig == SIGUSR1) {
        destroyThread = true;
        ALOGI("destroy set");
        return;
    }
    signal(SIGUSR1, sighandler);
}

Return<void> Usb::setCallback(const sp<IUsbCallback> &callback) {
        
    pthread_mutex_lock(&mLock);
    if ((mCallback == NULL && callback == NULL) ||
            (mCallback != NULL && callback != NULL)) {
        mCallback = callback;
        pthread_mutex_unlock(&mLock);
        return Void();
    }

    mCallback = callback;
    ALOGI("registering callback");

    if (mCallback == NULL) {
        if  (!pthread_kill(mPoll, SIGUSR1)) {
            pthread_join(mPoll, NULL);
            ALOGI("pthread destroyed");
        }
        pthread_mutex_unlock(&mLock);
        return Void();
    }

    destroyThread = false;
    signal(SIGUSR1, sighandler);

    if (pthread_create(&mPoll, NULL, work, this)) {
        ALOGE("pthread creation failed %d", errno);
        mCallback = NULL;
    }
    pthread_mutex_unlock(&mLock);
    return Void();
}

}  // namespace implementation
}  // namespace V1_0
}  // namespace usb
}  // namespace hardware
}  // namespace android
