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

##########
# Lights #
##########
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-service.samsung \

#######
# USB #
#######

# HAL packages
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

# Enable Hardware compoments on the framework level
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml

##########
# Health #
##########
PRODUCT_PACKAGES += \
	android.hardware.health@2.1-service \
	android.hardware.health@2.1-impl \

#########
# Power #
#########

# HAL packages
PRODUCT_PACKAGES += \
	android.hardware.power-service.example \

########
# VNDK #
########
PRODUCT_PACKAGES += \
    vndk_package

#########
# Audio #
#########
PRODUCT_PACKAGES += \
    android.hardware.audio.effect@6.0-impl \
    android.hardware.audio@6.0-impl \
    android.hardware.audio@2.0-service \
    audio.r_submix.default \
    audio.primary.default \

# Use dummy sound trigger
PRODUCT_PACKAGES += \
    android.hardware.soundtrigger@2.2-impl \

# A2DP
PRODUCT_PACKAGES += \
  audio.a2dp.default \

PRODUCT_COPY_FILES += \
    frameworks/av/media/libeffects/data/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_configuration_generic.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/primary_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/primary_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/surround_sound_configuration_5_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/surround_sound_configuration_5_0.xml

##########
# Kernel #
##########
PRODUCT_COPY_FILES += \
	kernel/replicant/linux/zImage-dtb:kernel \

###########################
# unsupported HW features #
###########################

# Copy list of unsupported HW features
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/unsupported_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/unsupported_hardware.xml

########################################
# DRM (Digital Restriction Management) #
########################################

# TODO: check if this needs to be removed!
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service \

############
# Security #
############
# Keymaster HAL packages
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service.software \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service \

############
# Vibrator #
############

# HAL packages
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-impl \

##########
# Memory #
##########

# HAL packages
PRODUCT_PACKAGES += \
    android.hidl.memory@1.0-impl \
    android.hidl.memory@1.0-service \

###########
# Sensors #
###########

# HAL packages
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-impl \

######
# VR #
######

# HAL packages
PRODUCT_PACKAGES += \
    android.hardware.vr@1.0-impl \
#########
# Debug #
#########

# Get root on the serial console for -eng builds
# This can help debugging early boot issues
ifeq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/console.rc:system/etc/init/console.rc
endif

###############
# ADB support #
###############
PRODUCT_PROPERTY_OVERRIDES += \
    persist.service.adb.enable=1 \
    persist.sys.usb.config=adb

####################
# Heimdall support #
####################

# Enable flashing through heimdall
PRODUCT_COPY_FILES += $(LOCAL_PATH)/resize2fs_partitions.sh:system/bin/resize2fs_partitions.sh

#########
# Hacks #
#########

# HACK: prevent the device to go in suspend because it's annoying during early
# development. Remove afterward as it consume way more energy this way.
PRODUCT_COPY_FILES += $(LOCAL_PATH)/prevent_suspend.sh:system/bin/prevent_suspend.sh
PRODUCT_COPY_FILES += $(LOCAL_PATH)/prevent_suspend.rc:system/etc/init/prevent_suspend.rc
