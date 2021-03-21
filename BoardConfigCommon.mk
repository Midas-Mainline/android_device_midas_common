#
# Copyright 2018 Joonas Kylmälä
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

TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon

TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a9

TARGET_BOARD_PLATFORM := exynos4
TARGET_BOOTLOADER_BOARD_NAME := smdk4x12

TARGET_NO_BOOTLOADER := true

BOARD_VENDOR := samsung

# Kernel
# To append the dtb to the zImage:
# - Use BOARD_DTB_IMAGE_NAME with the right dtb
# - Make sure that your kernel source doesn't have
#   any Android patches that would add the zImage-dtb
#   target.
# The vendor/lineage/build/tasks/kernel.mk file
# was modified to add support for that feature.
TARGET_KERNEL_SOURCE := kernel/replicant/linux
TARGET_KERNEL_CONFIG := replicant_defconfig
BOARD_KERNEL_IMAGE_NAME := zImage-dtb

BOARD_USES_FULL_RECOVERY_IMAGE := false
BOARD_USES_RECOVERY_AS_BOOT := false

TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USES_MKE2FS := true

# Disable VNDK at this point
BOARD_VNDK_VERSION := current
BOARD_GPU_DRIVERS := lima kmsro
USE_OPENGL_RENDERER := true
BOARD_USES_GRALLOC_HANDLE := true

# Wifi
WPA_SUPPLICANT_VERSION      := VER_0_8_X
BOARD_WLAN_DEVICE           := bcmdhd
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
#WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/bcmdhd/parameters/firmware_path"
#WIFI_DRIVER_FW_PATH_AP      := "/vendor/firmware/fw_bcmdhd_apsta.bin"
#WIFI_DRIVER_FW_PATH_STA     := "/vendor/firmware/fw_bcmdhd.bin"
WIFI_BUS := SDIO

TARGET_USES_64_BIT_BINDER := true

## audio
BOARD_USES_TINYHAL_AUDIO := true
TINYALSA_NO_ADD_NEW_CTRLS := true
TINYALSA_NO_CTL_GET_ID := true

USE_XML_AUDIO_POLICY_CONF := 1

DEVICE_MANIFEST_FILE := device/samsung/midas-common/manifest.xml
PRODUCT_ENFORCE_VINTF_MANIFEST_OVERRIDE := true

PRODUCT_FULL_TREBLE_OVERRIDE := true
BUILD_BROKEN_USES_BUILD_HOST_STATIC_LIBRARY := true
BOARD_VENDOR_SEPOLICY_DIRS += device/samsung/midas-common/sepolicy
