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
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml

# Telephony Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml

# Common path
COMMON_PATH := device/motorola/common

# QCOM Platform selector
ifeq ($(KERNEL_VERSION), 5.4)
qcom_platform := sm8350
else ifeq ($(KERNEL_VERSION), 4.19)
qcom_platform := sm8250
else
qcom_platform := sm8150
endif

# Enable building packages from device namespaces.
# Might be temporary! See:
# https://android.googlesource.com/platform/build/soong/+/master/README.md#name-resolution
PRODUCT_SOONG_NAMESPACES += \
    device/motorola/hanoip \
    $(PLATFORM_COMMON_PATH) \
    vendor/qcom/opensource/audio/$(qcom_platform) \
    vendor/qcom/opensource/data-ipa-cfg-mgr \
    vendor/qcom/opensource/display/$(qcom_platform) \
    vendor/qcom/opensource/display-commonsys-intf

ifeq ($(PRODUCT_USES_PIXEL_POWER_HAL),true)
PRODUCT_SOONG_NAMESPACES += \
    hardware/google/pixel
endif

# Build scripts
MOTOROLA_CLEAR_VARS := device/motorola/hanoip/motorola_clear_vars.mk
MOTOROLA_BUILD_SYMLINKS := device/motorola/hanoip/motorola_build_symlinks.mk

PRODUCT_ENFORCE_RRO_TARGETS := *

PRODUCT_DEXPREOPT_SPEED_APPS += SystemUI

# Google GSI public keys for /avb
# Needed for official GSIs while maintaining AVB and vbmeta.
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)
ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
# Developer GSI images
# https://developer.android.com/topic/generic-system-image/releases
$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)
endif

# Force using the following regardless of shipping API level:
#   PRODUCT_TREBLE_LINKER_NAMESPACES
#   PRODUCT_SEPOLICY_SPLIT
#   PRODUCT_ENFORCE_VINTF_MANIFEST
#   PRODUCT_NOTICE_SPLIT
PRODUCT_FULL_TREBLE_OVERRIDE := true

# VNDK
# Force using VNDK regardless of shipping API level
PRODUCT_USE_VNDK_OVERRIDE := true
# Include vndk/vndk-sp/ll-ndk modules
PRODUCT_PACKAGES += \
    vndk_package

# Force building a recovery image: Needed for OTA packaging to work since Q
PRODUCT_BUILD_RECOVERY_IMAGE := true

# Kernel Path
KERNEL_PATH := kernel/motorola/msm-$(KERNEL_VERSION)

# Configure qti-headers auxiliary module via soong
SOONG_CONFIG_NAMESPACES += qti_kernel_headers
SOONG_CONFIG_qti_kernel_headers := version
SOONG_CONFIG_qti_kernel_headers_version := $(KERNEL_VERSION)

# Codecs Configuration
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
    frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_in_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml

# Depend on symlink creation in /vendor:
PRODUCT_PACKAGES += \
    tftp_symlinks

# Create firmware mount point folders in /vendor:
PRODUCT_PACKAGES += \
    firmware_folders

# Perf
TARGET_USES_INTERACTION_BOOST := true

include device/qcom/common/common.mk

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

# TEMPORARY: These libraries are deprecated, not referenced by any AOSP
# nor OSS HAL We don't add a dependency on the vndk variants as those
# end up in /system but require these in /vendor instead:
PRODUCT_PACKAGES += \
    libhwbinder.vendor \
    libhidltransport.vendor

# Audio
PRODUCT_PACKAGES += \
    audio.bluetooth.default \
    libtinyalsa \
    tinymix

# Audio deps
PRODUCT_PACKAGES += \
    libfmq

# The following modules are included in debuggable builds only.
PRODUCT_PACKAGES_DEBUG += \
    bootctl \
    update_engine_client

# IMS (OSS)
PRODUCT_PACKAGES += \
    telephony-ext \
    ims-ext-common \
    ims_ext_common.xml

# Media
PRODUCT_PACKAGES += \
    libavservices_minijail.vendor

# OSS Time service
PRODUCT_PACKAGES += \
    timekeep \
    TimeKeep \

# QCOM Data
PRODUCT_PACKAGES += \
    librmnetctl

# RIL
PRODUCT_PACKAGES += \
    ims-moto-libs \
    libandroid_net \
    libjson \
    libprotobuf-cpp-full \
    libsensorndkbridge \
    moto-ims-ext \
    moto-telephony \
    qcrilhook \
    qti-telephony-hidl-wrapper \
    qti-telephony-hidl-wrapper-prd \
    qti_telephony_hidl_wrapper.xml \
    qti_telephony_hidl_wrapper_prd.xml \
    qti-telephony-utils \
    qti_telephony_utils.xml

# MotoActions
PRODUCT_PACKAGES += \
    MotoActions

# FIXME: master: compat for libprotobuf
# See https://android-review.googlesource.com/c/platform/prebuilts/vndk/v28/+/1109518
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full-vendorcompat

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

# AOSP Packages
PRODUCT_PACKAGES += \
    libion \
    libxml2 \

# For config.fs
PRODUCT_PACKAGES += \
    fs_config_files \
    fs_config_dirs

# FM
PRODUCT_PACKAGES += \
    FM2 \
    libfm-hci \
    libqcomfm_jni \
    fm_helium \
    qcom.fmradio

# Power
ifeq ($(BOARD_USES_PIXEL_POWER_HAL),true)
PRODUCT_PACKAGES += \
    libperfmgr.vendor
endif

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

# Unlock dex2oat threads
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dex2oat-threads=8 \
    dalvik.vm.image-dex2oat-threads=8

# Platform specific default properties
PRODUCT_PROPERTY_OVERRIDES += \
    persist.data.qmi.adb_logmask=0

# System props for the data modules
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.use_data_netmgrd=true \
    persist.vendor.data.mode=concurrent \
    persist.data.netmgrd.qos.enable=true \
    ro.data.large_tcp_window_size=true

# Enable Power save functionality for modem
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.radio.add_power_save=1 \
    persist.vendor.radio.apm_sim_not_pwdn=1

# Enable advanced power saving for data connectivity
# DPM: Data Port Mapper, with TCM (TCP Connection Manager)
# CnE: Connectivity Engine
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.dpm.feature=1 \
    persist.vendor.dpm.tcm=1 \
    persist.vendor.cne.feature=1

# IMS
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.radio.vdp_on_ims_cap=1 \
    persist.vendor.radio.report_codec=1

# VoLTE / VT / WFC
# These properties will force availability of the VoLTE,
# VideoTelephony and Wi-Fi Call, without needing carrier
# services provisioning sites hooked up: simplifies it.
PRODUCT_PROPERTY_OVERRIDES += \
    persist.dbg.volte_avail_ovr=1 \
    persist.dbg.vt_avail_ovr=1  \
    persist.dbg.wfc_avail_ovr=1

# Modem properties
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.radio.wait_for_pbm=1 \
    persist.vendor.radio.mt_sms_ack=19 \
    persist.vendor.radio.enableadvancedscan=true \
    persist.vendor.radio.unicode_op_names=true \
    persist.vendor.radio.sib16_support=1 \
    persist.vendor.radio.oem_socket=true \
    persist.vendor.radio.msgtunnel.start=true

# RemoteFS Storage
# This property is needed for rmt_storage to look for fsg
# in /vendor
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.build.vendorprefix=/vendor

# Ringer
PRODUCT_PROPERTY_OVERRIDES += \
    ro.telephony.call_ring.multiple=false

# System props for telephony System prop to turn on CdmaLTEPhone always
PRODUCT_PROPERTY_OVERRIDES += \
    telephony.lteOnCdmaDevice=0

# debug.sf.latch_unsignaled
# - This causes SurfaceFlinger to latch
#   buffers even if their fences haven't signaled
PRODUCT_PROPERTY_OVERRIDES += \
    debug.sf.latch_unsignaled=1

# SurfaceFlinger
# Keep uppercase makevars like TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS
# in sync, use hardware/interfaces/configstore/1.1/default/surfaceflinger.mk
# as a reference
# ConfigStore is being deprecated and sf is moving to props, see
# frameworks/native/services/surfaceflinger/sysprop/SurfaceFlingerProperties.sysprop
PRODUCT_PROPERTY_OVERRIDES += \
    ro.surface_flinger.force_hwc_copy_for_virtual_displays=true

# Disable buffer age (b/74534157)
PRODUCT_PROPERTY_OVERRIDES += \
    debug.hwui.use_buffer_age=false

# Stagefright
PRODUCT_PROPERTY_OVERRIDES += \
    media.stagefright.thumbnail.prefer_hw_codecs=true

# DRM service
PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=true

# VIDC: debug_levels 1:ERROR 2:HIGH 4:LOW 0:NOLOGS 7:AllLOGS
PRODUCT_PROPERTY_OVERRIDES += \
    vidc.debug.level=1

# Audio
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.media_vol_steps=25 \
    ro.config.vc_call_vol_steps=7

# Audio (newer CAF HALs)
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.audio.fluence.speaker=false \
    persist.vendor.audio.fluence.voicecall=true \
    persist.vendor.audio.fluence.voicecomm=true \
    persist.vendor.audio.fluence.voicerec=false \
    ro.vendor.audio.sdk.fluencetype=fluence

# Enable stats logging in LMKD
TARGET_LMKD_STATS_LOG := true
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lmk.log_stats=true

# Set lmkd options
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lmk.thrashing_limit=60 \
    ro.lmk.swap_free_low_percentage=10 \
    ro.lmk.psi_partial_stall_ms=50 \
    ro.lmk.swap_util_max=90 \
    ro.lmk.pgscan_limit=2000 \
    ro.lmk.file_low_percentage=20 \
    ro.lmk.threshold_decay=40

# Property to enable user to access Google WFD settings.
PRODUCT_PROPERTY_OVERRIDES += \
    persist.debug.wfd.enable=0

# Property to choose between virtual/external wfd display
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.wfd.virtual=0

# Linked by Adreno/EGL blobs for fallback if 3.0 doesn't exist
PRODUCT_PACKAGES += \
    vendor.qti.hardware.display.allocator@3.0.vendor \
    vendor.qti.hardware.display.mapper@2.0.vendor

# Configstore
PRODUCT_PACKAGES += \
    disable_configstore

# RIL
# Interface library needed by vendor blobs:
PRODUCT_PACKAGES += \
    android.hardware.radio@1.2.vendor \
    android.hardware.radio@1.3.vendor \
    android.hardware.radio@1.4.vendor \
    android.hardware.radio@1.5.vendor \
    android.hardware.radio.config@1.0.vendor \
    android.hardware.radio.config@1.1.vendor \
    android.hardware.radio.config@1.2.vendor \
    android.hardware.radio.deprecated@1.0.vendor \
    android.hardware.secure_element@1.2.vendor

# netmgrd
PRODUCT_PACKAGES += \
    android.system.net.netd@1.1.vendor

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio@6.0-impl:32 \
    android.hardware.audio.service \
    android.hardware.audio.effect@6.0-impl:32 \
    android.hardware.bluetooth@1.0.vendor \
    android.hardware.bluetooth.audio@2.0-impl \
    android.hardware.soundtrigger@2.1.vendor \
    android.hardware.soundtrigger@2.2.vendor \
    android.hardware.soundtrigger@2.3.vendor \
    android.hardware.soundtrigger@2.3-impl

# Camera
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.5 \
    android.frameworks.displayservice@1.0.vendor \
    android.frameworks.sensorservice@1.0.vendor \
    vendor.qti.hardware.camera.postproc@1.0.vendor
ifeq ($(TARGET_USES_64BIT_CAMERA),true)
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-impl:64 \
    android.hardware.camera.provider@2.4-service_64
else
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-impl:32 \
    android.hardware.camera.provider@2.4-service
endif

# GNSS
PRODUCT_PACKAGES += \
    android.hardware.gnss.measurement_corrections@1.0.vendor \
    android.hardware.gnss.measurement_corrections@1.1.vendor \
    android.hardware.gnss.visibility_control@1.0.vendor \
    android.hardware.gnss@1.0.vendor \
    android.hardware.gnss@1.1.vendor \
    android.hardware.gnss@2.0.vendor \
    android.hardware.gnss@2.1.vendor

# QTI Haptics Vibrator
PRODUCT_PACKAGES += \
    vendor.qti.hardware.vibrator.service

# Fingerprint
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint@2.1.vendor

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service-lazy \
    android.hardware.drm@1.4-service-lazy.clearkey

# Thermal HAL
PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0-service.qti

# FM
PRODUCT_PACKAGES += \
    vendor.qti.hardware.fm@1.0 \
    vendor.qti.hardware.fm@1.0.vendor

# Power HAL
ifeq ($(PRODUCT_USES_PIXEL_POWER_HAL),true)
PRODUCT_PACKAGES += \
    android.hardware.power-service.moto-common-libperfmgr
else
$(call inherit-product, vendor/qcom/opensource/power/power-vendor-product.mk)
endif

# Only define bootctrl HAL availability on AB platforms:
ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_PACKAGES += \
    android.hardware.boot@1.1-impl-qti \
    android.hardware.boot@1.1-impl-qti.recovery \
    android.hardware.boot@1.1-service \
    bootctrl.sm6150 \
    bootctrl.sm6150.recovery
endif


# Proprietary Blobs
QCOM_COMMON_PATH := device/qcom/common
# System
include $(QCOM_COMMON_PATH)/system/audio/qti-audio.mk
include $(QCOM_COMMON_PATH)/system/av/qti-av.mk
include $(QCOM_COMMON_PATH)/system/display/qti-display.mk
include $(QCOM_COMMON_PATH)/system/gps/qti-gps.mk
include $(QCOM_COMMON_PATH)/system/overlay/qti-overlay.mk
ifneq ($(PRODUCT_USES_PIXEL_POWER_HAL),true)
include $(QCOM_COMMON_PATH)/system/perf/qti-perf.mk
endif
# Vendor
include $(QCOM_COMMON_PATH)/vendor/adreno/qti-adreno.mk
include $(QCOM_COMMON_PATH)/vendor/charging/qti-charging.mk
include $(QCOM_COMMON_PATH)/vendor/drm/qti-drm.mk
include $(QCOM_COMMON_PATH)/vendor/dsprpcd/qti-dsprpcd.mk
include $(QCOM_COMMON_PATH)/vendor/keymaster/qti-keymaster.mk
ifeq ($(KERNEL_VERSION),5.4)
include $(QCOM_COMMON_PATH)/vendor/media/qti-media.mk
else
include $(QCOM_COMMON_PATH)/vendor/media-legacy/qti-media-legacy.mk
endif
ifneq ($(PRODUCT_USES_PIXEL_POWER_HAL),true)
include $(QCOM_COMMON_PATH)/vendor/perf/qti-perf.mk
endif
ifneq ($(KERNEL_VERSION),5.4)
include $(QCOM_COMMON_PATH)/vendor/qseecomd-legacy/qti-qseecomd-legacy.mk
else
include $(QCOM_COMMON_PATH)/vendor/qseecomd/qti-qseecomd.mk
endif
include $(QCOM_COMMON_PATH)/vendor/usb/qti-usb.mk
include $(QCOM_COMMON_PATH)/vendor/wlan/qti-wlan.mk

PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/common/vendor/dsprpcd \
    vendor/qcom/common/vendor/perf

# Inherit from those products. Most specific first.
$(call inherit-product, device/motorola/sm6150-common/platform.mk)

# include board vendor blobs
$(call inherit-product-if-exists, vendor/motorola/hanoip/hanoip-vendor.mk)
