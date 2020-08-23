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
TARGET_SOC := exynos4x12

TARGET_NO_BOOTLOADER := true

BOARD_VENDOR := samsung

# OMX
#BOARD_USE_V4L2 := true

# Kernel
# To append the dtb to the zImage:
# - Use BOARD_DTB_IMAGE_NAME with the right dtb
# - Make sure that your kernel source doesn't have
#   any Android patches that would add the zImage-dtb
#   target.
# The vendor/replicant/build/tasks/kernel.mk file
# was modified to add support for that feature.
TARGET_KERNEL_SOURCE := kernel/replicant/linux
TARGET_KERNEL_CONFIG := replicant_defconfig
BOARD_KERNEL_IMAGE_NAME := zImage-dtb

TARGET_FS_CONFIG_GEN := device/samsung/midas-common/config.fs

BOARD_USES_FULL_RECOVERY_IMAGE := false
BOARD_USES_RECOVERY_AS_BOOT := false

TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USES_MKE2FS := true

BOARD_GPU_DRIVERS := lima kmsro swrast

# RIL
BOARD_MOBILEDATA_INTERFACE_NAME := "pdp0"
# RIL
BOARD_PROVIDES_LIBRIL := true
BOARD_MODEM_TYPE := xmm6262
TARGET_SPECIFIC_HEADER_PATH += device/samsung/midas-common/include

# Wifi
WPA_SUPPLICANT_VERSION      := VER_0_8_X
BOARD_WLAN_DEVICE           := bcmdhd
BOARD_WLAN_DEVICE_REV       := bcm4334
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
#WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/bcmdhd/parameters/firmware_path"
#WIFI_DRIVER_FW_PATH_AP      := "/vendor/firmware/fw_bcmdhd_apsta.bin"
#WIFI_DRIVER_FW_PATH_STA     := "/vendor/firmware/fw_bcmdhd.bin"
WIFI_BUS := SDIO

TARGET_USES_64_BIT_BINDER := true
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true

BOARD_USES_GENERIC_AUDIO := false
