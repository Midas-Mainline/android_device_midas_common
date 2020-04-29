#
# Copyright 2018, 2020 Joonas Kylmälä
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

COMMON_PATH := device/samsung/midas-common

DEVICE_PACKAGE_OVERLAYS := $(COMMON_PATH)/overlay

# Audio
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/audio_effects.conf:system/etc/audio_effects.conf \
    $(COMMON_PATH)/audio/silence.wav:system/etc/sound/silence.wav \
    $(COMMON_PATH)/configs/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(COMMON_PATH)/configs/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    $(COMMON_PATH)/configs/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml

PRODUCT_PACKAGES += \
    android.hardware.memtrack@1.0-impl.i9305 \
    android.hardware.memtrack@1.0-service.i9305

# Graphics
PRODUCT_PACKAGES += \
    gralloc.gbm \
    hwcomposer.drm \
    libGLES_mesa \
    hwcomposer.ranchu \
    libEGL_swiftshader \
    libGLESv2_swiftshader \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-service.samsung \

PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xhdpi

# OEM Lock HAL
PRODUCT_PACKAGES += \
    android.hardware.oemlock@1.0-service

# USB HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

# VNDK
PRODUCT_PACKAGES += \
    vndk_package

# Graphics
PRODUCT_PACKAGES += \
    gralloc.gbm \
    hwcomposer.ranchu \
    libEGL_swiftshader \
    libGLESv2_swiftshader \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-impl \
    android.hardware.audio.effect@2.0-impl \
    audio.a2dp.default \
    audio.primary.smdk4x12 \
    audio.r_submix.default \
    audio.usb.default \
    tinymix

PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/media_profiles.xml:system/etc/media_profiles.xml \
    $(COMMON_PATH)/configs/media_codecs.xml:system/etc/media_codecs.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:system/etc/media_codecs_google_video_le.xml

# A2DP
PRODUCT_PACKAGES += \
  android.hardware.bluetooth.a2dp@1.0-impl

PRODUCT_COPY_FILES += \
    frameworks/av/media/libeffects/data/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_configuration_stub.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/stub_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/stub_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/surround_sound_configuration_5_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/surround_sound_configuration_5_0.xml

# Copy list of unsupported HW features
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/unsupported_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/unsupported_hardware.xml

# DRM HAL packages
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-service \
    android.hardware.drm@1.0-impl \

# Keymaster HAL packages
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service \

# Graphics HAL packages
PRODUCT_PACKAGES += \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.renderscript@1.0-impl \

# Vibrator HAL packages
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-impl \

# Power HAL packages
PRODUCT_PACKAGES += \
    android.hardware.power@1.0-impl \
    android.hardware.power@1.0-service \

# Memory HAL packages
PRODUCT_PACKAGES += \
    android.hidl.memory@1.0-impl \
    android.hidl.memory@1.0-service \

# Sensors HAL packages
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-impl \

# VR HAL packages
PRODUCT_PACKAGES += \
    android.hardware.vr@1.0-impl \

# Gatekeeper
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service \

# DRM – check if this needs to be removed!
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service \

# Wifi
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    libwpa_client \
    hostapd \
    wpa_supplicant \
    wpa_supplicant.conf \

PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/root/firmware/brcmfmac4334-sdio.bin:$(TARGET_COPY_OUT_VENDOR)/lib/firmware/brcm/brcmfmac4334-sdio.bin \
    $(COMMON_PATH)/root/firmware/brcmfmac4334-sdio.txt:$(TARGET_COPY_OUT_VENDOR)/lib/firmware/brcm/brcmfmac4334-sdio.txt \
    $(COMMON_PATH)/root/firmware/regulatory.db:$(TARGET_COPY_OUT_VENDOR)/lib/firmware/regulatory.db \
    $(COMMON_PATH)/root/firmware/regulatory.db.p7s:$(TARGET_COPY_OUT_VENDOR)/lib/firmware/regulatory.db.p7s \

# Get root on the serial console for -eng builds
# This can help debugging early boot issues
ifeq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_COPY_FILES += device/samsung/midas-common/console.rc:system/etc/init/console.rc
endif

# ADB support
PRODUCT_PROPERTY_OVERRIDES += \
    persist.service.adb.enable=1 \
    persist.sys.usb.config=adb

# Hack to get a working GateKeeper
PRODUCT_PACKAGES += gatekeeper.default

# Enable flashing through heimdall
PRODUCT_COPY_FILES += device/samsung/midas-common/resize2fs_partitions.sh:system/bin/resize2fs_partitions.sh

# HACK: prevent the device to go in suspend because it's annoying during early
# development. Remove afterward as it consume way more energy this way.
PRODUCT_COPY_FILES += device/samsung/midas-common/prevent_suspend.sh:system/bin/prevent_suspend.sh
PRODUCT_COPY_FILES += device/samsung/midas-common/prevent_suspend.rc:system/etc/init/prevent_suspend.rc

PRODUCT_COPY_FILES += device/samsung/midas-common/allocator/android.hardware.graphics.allocator@2.0-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.graphics.allocator@2.0-override-service.rc

# Enable Hardware compoments on the framework level
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml
