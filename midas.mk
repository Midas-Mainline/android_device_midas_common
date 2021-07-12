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

###############
# ADB support #
###############
PRODUCT_PROPERTY_OVERRIDES += \
    persist.service.adb.enable=1 \
    persist.sys.usb.config=adb

#########
# Audio #
#########

PRODUCT_PACKAGES += \
    android.hardware.audio@6.0-impl \
    android.hardware.audio.service \
    android.hardware.audio.effect@6.0-impl \
    android.hardware.soundtrigger@2.2-impl \

# HAL for handling audio frames
PRODUCT_PACKAGES += \
    audio.primary.i9300

# We do need debug utilities on the target to enable users to be able to give
# certain information without needing to recompile an image. In addition it
# makes experimenting with audio easier.
PRODUCT_PACKAGES += \
    tinycap \
    tinymix \
    tinypcminfo \
    tinyalsa \
    tinyplay \

# A2DP
PRODUCT_PACKAGES += \
    audio.a2dp.default \
    audio.usb.default \
    audio.r_submix.default \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio.i9300.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio.i9300.xml \
    frameworks/av/media/libeffects/data/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_configuration_generic.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/primary_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/primary_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/surround_sound_configuration_5_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/surround_sound_configuration_5_0.xml

#########
# Debug #
#########

# Get root on the serial console for -eng builds
# This can help debugging early boot issues
ifeq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/console.rc:system/etc/init/console.rc
endif

########################################
# DRM (Digital Restriction Management) #
########################################

# TODO: check if this needs to be removed!
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service \

############
# Graphics #
############

PRODUCT_PACKAGES += \
    gralloc.gbm \
    hwcomposer.drm \
    hwcomposer.ranchu \
    libEGL_swiftshader \
    libGLES_mesa \
    libGLESv2_swiftshader \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.renderscript@1.0-impl \

PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xhdpi

PRODUCT_COPY_FILES += $(LOCAL_PATH)/allocator/android.hardware.graphics.allocator@2.0-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.graphics.allocator@2.0-override-service.rc

#########
# Hacks #
#########

# HACK: prevent the device to go in suspend because it's annoying during early
# development. Remove afterward as it consume way more energy this way.
PRODUCT_COPY_FILES += $(LOCAL_PATH)/prevent_suspend.sh:system/bin/prevent_suspend.sh
PRODUCT_COPY_FILES += $(LOCAL_PATH)/prevent_suspend.rc:system/etc/init/prevent_suspend.rc

##########
# Health #
##########

PRODUCT_PACKAGES += \
	android.hardware.health@2.1-service \
	android.hardware.health@2.1-impl-midas \
	android.hardware.health@2.1-impl-midas.recovery

####################
# Heimdall support #
####################

# Enable flashing through heimdall: On the Exynos devices supported by Replicant
# 6.0, heimdall is reliable enough to flash small files like boot.img or
# recovery.img but flashing bigger files like a system.img that is the size of
# the target partition would increase too much the probability of failure.
PRODUCT_COPY_FILES += $(LOCAL_PATH)/resize2fs_partitions.sh:system/bin/resize2fs_partitions.sh

##########
# Lights #
##########

PRODUCT_PACKAGES += lights-midas

##########
# Memory #
##########

# HAL packages
PRODUCT_PACKAGES += \
    android.hidl.memory@1.0-impl \
    android.hidl.memory@1.0-service

PRODUCT_TAGS += dalvik.gc.type-precise

###########
# Rootdir #
###########

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/init.smdk4x12.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.smdk4x12.rc  \
    $(LOCAL_PATH)/rootdir/init.smdk4x12.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.smdk4x12.usb.rc \

# Use GO
$(call inherit-product, $(LOCAL_PATH)/go_defaults_common.mk)

# Apply Dalvik config for 1G phone
$(call inherit-product, frameworks/native/build/phone-xhdpi-1024-dalvik-heap.mk)

#######
# OMX #
#######

PRODUCT_PROPERTY_OVERRIDES += \
    media.settings.xml=/system/etc/media_profiles.xml \
    debug.stagefright.ccodec=0

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/media_profiles.xml:system/etc/media_profiles.xml \
    $(LOCAL_PATH)/configs/media_codecs.xml:system/etc/media_codecs.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:system/etc/media_codecs_google_video_le.xml

#########
# Power #
#########

# HAL packages
PRODUCT_PACKAGES += \
    android.hardware.power-service.example \

############
# Security #
############
# Keymaster HAL packages
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service.software \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service \

###########
# Sensors #
###########

# HAL packages
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-impl \
    android.hardware.sensors@1.0-service

PRODUCT_PACKAGES += \
    sensors.iio \

##############
# USB Gadget #
##############

PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service-midas \
    android.hardware.usb.gadget@1.1-service-midas

###########################
# Unsupported HW features #
###########################

# Copy list of unsupported HW features
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/unsupported_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/unsupported_hardware.xml

#######
# USB #
#######

# HAL packages
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

# Enable Hardware compoments on the framework level
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml

########
# WIFI #
########

# HAL packages
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    libwpa_client \
    hostapd \
    wpa_supplicant \
    wpa_supplicant.conf \

# Wifi
PRODUCT_COPY_FILES += \
    device/samsung/midas-common/configs/wpa_supplicant_overlay.conf:system/vendor/etc/wifi/wpa_supplicant_overlay.conf \
    device/samsung/midas-common/configs/p2p_supplicant_overlay.conf:system/vendor/etc/wifi/p2p_supplicant_overlay.conf

PRODUCT_COPY_FILES += \
    device/samsung/midas-common/rootdir/firmware/brcmfmac4334-sdio.bin:$(TARGET_COPY_OUT_VENDOR)/lib/firmware/brcm/brcmfmac4334-sdio.bin \
    device/samsung/midas-common/rootdir/firmware/brcmfmac4334-sdio.txt:$(TARGET_COPY_OUT_VENDOR)/lib/firmware/brcm/brcmfmac4334-sdio.txt \
    device/samsung/midas-common/rootdir/firmware/brcmfmac4334-sdio.txt:$(TARGET_COPY_OUT_VENDOR)/lib/firmware/brcm/brcmfmac4334-sdio.samsung,i9300.txt \
    device/samsung/midas-common/rootdir/firmware/regulatory.db:$(TARGET_COPY_OUT_VENDOR)/lib/firmware/regulatory.db \
    device/samsung/midas-common/rootdir/firmware/regulatory.db.p7s:$(TARGET_COPY_OUT_VENDOR)/lib/firmware/regulatory.db.p7s \

############
# Vibrator #
############

# HAL packages
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-impl \

########
# VNDK #
########
PRODUCT_PACKAGES += \
    vndk_package

######
# VR #
######

# HAL packages
PRODUCT_PACKAGES += \
    android.hardware.vr@1.0-impl \

# Prebuilt APKs from F-Droid
-include vendor/f-droid/prebuilts.mk
