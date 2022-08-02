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

# Device path
DEVICE_PATH := device/motorola/hanoip/rootdir

DEVICE_PACKAGE_OVERLAYS += \
    device/motorola/hanoip/overlay

# Device Specific Permissions
PRODUCT_COPY_FILES := \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml

# Kernel
PRODUCT_COPY_FILES += \
    device/motorola/hanoip/prebuilt/Image.gz:kernel

# Kernel Headers
PRODUCT_VENDOR_KERNEL_HEADERS := device/motorola/hanoip/prebuilt/kernel-headers

# Audio Configuration
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/vendor/etc/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml \
    $(DEVICE_PATH)/vendor/etc/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    $(DEVICE_PATH)/vendor/etc/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    $(DEVICE_PATH)/vendor/etc/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml

# Bluetooth
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/vendor/etc/sysconfig/component-overrides.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sysconfig/component-overrides.xml

# Device Init
PRODUCT_PACKAGES += \
    fstab.hanoip \
    vendor-fstab.hanoip \
    init.recovery.qcom.rc \
    init.class_main.sh \
    init.mmi.charge_only.rc \
    init.mmi.chipset.rc \
    init.mmi.overlay.rc \
    init.mmi.touch.sh \
    init.mmi.usb.sh \
    init.mmi.rc \
    init.oem.fingerprint2.sh \
    init.oem.hw.sh \
    init.qcom.ipastart.sh \
    init.qcom.rc \
    init.qti.kernel.rc \
    init.qti.kernel.sh \
    init.target.rc \
    vendor_modprobe.sh

# AB Partitions
AB_OTA_PARTITIONS += vendor_boot

# Telephony Packages (AOSP)
PRODUCT_PACKAGES += \
    InCallUI \
    Stk

PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREBUILT_DPI := xxhdpi xhdpi hdpi
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

PRODUCT_PROPERTY_OVERRIDES := \
    ro.sf.lcd_density=400

# Telephony: IMS framework
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/system/system_ext/etc/permissions/privapp-permissions-ims.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-ims.xml

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hidl.base@1.0.vendor

# Lights HAL
PRODUCT_PACKAGES += \
    android.hardware.lights-service.moto

# QMI
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/vendor/etc/data/dsi_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/data/dsi_config.xml \
    $(DEVICE_PATH)/vendor/etc/data/netmgr_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/data/netmgr_config.xml

# QSEECOM TZ Storage
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/vendor/etc/gpfspath_oem_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/gpfspath_oem_config.xml

# Sec Configuration
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/vendor/etc/sec_config:$(TARGET_COPY_OUT_VENDOR)/etc/sec_config

# Seccomp policy
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/vendor/etc/seccomp_policy/imsrtp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/imsrtp.policy

# Additional native libraries
# See https://source.android.com/devices/tech/config/namespaces_libraries
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/vendor/etc/public.libraries.txt:$(TARGET_COPY_OUT_VENDOR)/etc/public.libraries.txt

# Inherit from those products. Most specific first.
$(call inherit-product, device/motorola/sm6150-common/platform.mk)

# include board vendor blobs
$(call inherit-product-if-exists, vendor/motorola/hanoip/hanoip-vendor.mk)
