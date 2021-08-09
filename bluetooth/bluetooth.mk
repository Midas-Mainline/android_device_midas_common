
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    
    #frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml \

PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-service.btlinux \
    audio.bluetooth.default \
    
    #android.hardware.bluetooth.audio@2.0-impl \
    #android.hardware.bluetooth.a2dp@1.0-impl \
    #audio.a2dp.default \

DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/bluetooth/manifest.xml