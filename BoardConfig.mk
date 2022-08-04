# Copyright 2014 The Android Open Source Project
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

# Fixes
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# CPU ARCH
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic

# AB Partitions
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    product \
    system \
    vendor \
    vbmeta \
    vbmeta_system \
    vendor_boot
    
# Boot Header
BOARD_BOOT_HEADER_VERSION := 3
BOARD_INCLUDE_DTB_IN_BOOTIMG := true

# Kernel cmdline
BOARD_KERNEL_IMAGE_NAME := Image.gz
TARGET_KERNEL_SOURCE := kernel/motorola/hanoip
TARGET_KERNEL_CLANG_COMPILE := true
TARGET_KERNEL_CONFIG := hanoip_defconfig

BOARD_KERNEL_CMDLINE += androidboot.hab.csv=5
BOARD_KERNEL_CMDLINE += androidboot.hab.product=hanoip
BOARD_KERNEL_CMDLINE += androidboot.hab.cid=50
BOARD_KERNEL_CMDLINE += androidboot.console=ttyMSM0
BOARD_KERNEL_CMDLINE += androidboot.memcg=1
BOARD_KERNEL_CMDLINE += androidboot.hardware=qcom
BOARD_KERNEL_CMDLINE += loop.max_part=7
BOARD_KERNEL_CMDLINE += service_locator.enable=1
BOARD_KERNEL_CMDLINE += swiotlb=0
BOARD_KERNEL_CMDLINE += cgroup.memory=nokmem,nosocket
BOARD_KERNEL_CMDLINE += androidboot.usbcontroller=a600000.dwc3
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

BOARD_KERNEL_BASE        := 0x00000000
BOARD_KERNEL_PAGESIZE    := 4096
BOARD_RAMDISK_OFFSET     := 0x01000000
BOARD_DTB_OFFSET         := 0x01f00000

BOARD_MKBOOTIMG_ARGS := --ramdisk_offset $(BOARD_RAMDISK_OFFSET)  
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)

TARGET_BOOTLOADER_BOARD_NAME := hanoip

# Platform
PRODUCT_PLATFORM := sm6150

# Partition information
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_DTBOIMG_PARTITION_SIZE := 25165824 # (0x1800000)
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := $(BOARD_BOOTIMAGE_PARTITION_SIZE)

BOARD_SUPER_PARTITION_SIZE := 10804527104
BOARD_SUPER_PARTITION_GROUPS := mot_dynamic_partitions

# Set error limit to SUPER_PARTITION_SIZE - 500MiB
BOARD_SUPER_PARTITION_ERROR_LIMIT := 10300162048

# DYNAMIC_PARTITIONS_SIZE = (SUPER_PARTITION_SIZE / 2) - 4MB
BOARD_MOT_DYNAMIC_PARTITIONS_SIZE := 6169821184
BOARD_MOT_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system \
    system_ext \
    product \
    vendor

# Slightly overprovision dynamic partitions with 50MiB to
# allow on-device file editing
BOARD_SYSTEM_EXTIMAGE_PARTITION_RESERVED_SIZE := 52428800
BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE := 52428800
BOARD_VENDORIMAGE_PARTITION_RESERVED_SIZE := 52428800
BOARD_PRODUCTIMAGE_PARTITION_RESERVED_SIZE := 52428800

# Reserve space for data encryption (239541551104-16384)
BOARD_USERDATAIMAGE_PARTITION_SIZE := 14919106048

# Build system_ext image
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEM_EXTIMAGE_JOURNAL_SIZE := 0
BOARD_SYSTEM_EXTIMAGE_EXTFS_INODE_COUNT := 4096

# Use mke2fs to create ext4/f2fs images
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

BOARD_ROOT_EXTRA_SYMLINKS += /mnt/vendor/persist:/persist

# This target has no recovery partition
BOARD_USES_RECOVERY_AS_BOOT := true
TARGET_NO_RECOVERY := true

# Build a separate vendor.img
TARGET_COPY_OUT_VENDOR := vendor
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

# Build product image
TARGET_COPY_OUT_PRODUCT := product
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4

# This platform has a metadata partition: declare this
# to create a mount point for it
BOARD_USES_METADATA_PARTITION := true

# DTBO Recovery
BOARD_INCLUDE_RECOVERY_DTBO := true

TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/vendor/etc/fstab.qcom

# Device manifest: What HALs the device provides
DEVICE_MANIFEST_FILE += device/motorola/hanoip/vintf/manifest.xml
# Framework compatibility matrix: What the device(=vendor) expects of the framework(=system)
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += device/motorola/hanoip/vintf/framework_compatibility_matrix.xml
DEVICE_MATRIX_FILE += device/motorola/hanoip/vintf/compatibility_matrix.xml

# BT definitions for Qualcomm solution
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/motorola/hanoip/bluetooth

# Filesystem
TARGET_FS_CONFIG_GEN += device/motorola/hanoip/mot_aids.fs

# Media
TARGET_USES_ION := true

# Charger
BOARD_CHARGER_DISABLE_INIT_BLANK := true
BOARD_CHARGER_ENABLE_SUSPEND := true

# Wi-Fi Concurrent STA/AP
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true

# Enable dex-preoptimization to speed up first boot sequence
WITH_DEXPREOPT := true
WITH_DEXPREOPT_BOOT_IMG_AND_SYSTEM_SERVER_ONLY ?= false

# SELinux
include device/qcom/sepolicy_vndr/SEPolicy.mk
include device/sony/sepolicy/sepolicy.mk
BOARD_VENDOR_SEPOLICY_DIRS += device/motorola/hanoip/sepolicy/vendor

# New vendor security patch level: https://r.android.com/660840/
# Used by newer keymaster binaries
VENDOR_SECURITY_PATCH=$(PLATFORM_SECURITY_PATCH)

# Memory
MALLOC_SVELTE := true

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

# QCOM
BOARD_USES_QCOM_HARDWARE := true

# USB
SOONG_CONFIG_NAMESPACES += MOTO_COMMON_USB
SOONG_CONFIG_MOTO_COMMON_USB := USB_CONTROLLER_NAME
SOONG_CONFIG_MOTO_COMMON_USB_USB_CONTROLLER_NAME := 4e00000

# AVB
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_VBMETA_SYSTEM := system
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 1
