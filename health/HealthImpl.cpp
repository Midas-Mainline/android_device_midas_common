#define LOG_TAG "health-p4note"

#include <memory>
#include <string_view>

#include <health/utils.h>
#include <health2impl/Health.h>
#include <hidl/Status.h>

#include <android/hardware/health/2.1/types.h>
#include <cutils/klog.h>

using ::android::sp;
using ::android::hardware::Return;
using ::android::hardware::Void;
using ::android::hardware::health::InitHealthdConfig;
using ::android::hardware::health::V1_0::BatteryStatus;
using ::android::hardware::health::V2_0::Result;
using ::android::hardware::health::V2_1::IHealth;
using ::android::hidl::base::V1_0::IBase;

using namespace std::literals;

namespace android {
namespace hardware {
namespace health {
namespace V2_1 {
namespace implementation {

#define CHARGER_SYSFS_PATH "/sys/class/power_supply/smb347-usb/"
#define CHARGER_STATUS_SYSFS_PATH CHARGER_SYSFS_PATH "status"

#define BATTERY_SYSFS_PATH "/sys/class/power_supply/max170xx_battery/"
#define BATTERY_CHARGE_COUNTER CHARGER_SYSFS_PATH "charge_counter"
#define BATTERY_CURRENT_NOW CHARGER_SYSFS_PATH "current_now"
#define BATTERY_CURRENT_AVG CHARGER_SYSFS_PATH "current_avg"
#define BATTERY_CAPACITY CHARGER_SYSFS_PATH "capacity"

// android::hardware::health::V2_1::implementation::Health implements most
// defaults. Uncomment functions that you need to override.
class HealthImpl : public Health {
  public:
    HealthImpl(std::unique_ptr<healthd_config>&& config)
        : Health(std::move(config)) {}

    // A subclass can override this if these information should be retrieved
    // differently.
    Return<void> getChargeCounter(getChargeCounter_cb _hidl_cb) override;
    Return<void> getCurrentNow(getCurrentNow_cb _hidl_cb) override;
    Return<void> getCurrentAverage(getCurrentAverage_cb _hidl_cb) override;
    Return<void> getCapacity(getCapacity_cb _hidl_cb) override;
    // Return<void> getEnergyCounter(getEnergyCounter_cb _hidl_cb) override;
    Return<void> getChargeStatus(getChargeStatus_cb _hidl_cb) override;
    // Return<void> getStorageInfo(getStorageInfo_cb _hidl_cb) override;
    // Return<void> getDiskStats(getDiskStats_cb _hidl_cb) override;
    // Return<void> getHealthInfo(getHealthInfo_cb _hidl_cb) override;

    // Functions introduced in Health HAL 2.1.
    // Return<void> getHealthConfig(getHealthConfig_cb _hidl_cb) override;
    // Return<void> getHealthInfo_2_1(getHealthInfo_2_1_cb _hidl_cb) override;
   
  Return<void> shouldKeepScreenOn(shouldKeepScreenOn_cb _hidl_cb) override;

  protected:
    // A subclass can override this to modify any health info object before
    // returning to clients. This is similar to healthd_board_battery_update().
    // By default, it does nothing.
    // void UpdateHealthInfo(HealthInfo* health_info) override;
};

static int read_sysfs(const char *path, char *buf, size_t size) {
    char *cp = NULL;
    int fd = open(path, O_RDONLY);
    if (fd == -1) {
        KLOG_ERROR(LOG_TAG, "Could not open '%s'\n", path);
        return -1;
    }
    ssize_t count = TEMP_FAILURE_RETRY(read(fd, buf, size));
    if (count > 0)
        cp = (char *)memrchr(buf, '\n', count);
    if (cp)
        *cp = '\0';
    else
        buf[0] = '\0';
    close(fd);
    return count;
}

static int read_sysfs_int32_t(const char *path, int32_t *result) {
  const int SIZE = 16;
  char buf[SIZE];
  int ret = read_sysfs(path, buf, SIZE);
  if (ret <= 0) {
    return ret;
  }
  *result = atol(buf);
  return 0;
}

Return<void> HealthImpl::getChargeCounter(getChargeCounter_cb _hidl_cb)
{
  int32_t result = 0;
  int read = read_sysfs_int32_t(BATTERY_CHARGE_COUNTER, &result);
  if (read > 0) {
    KLOG_ERROR(LOG_TAG, "getChargeCounter: '%d'\n", result);
    _hidl_cb(Result::SUCCESS, result);
  } else {
    _hidl_cb(Result::UNKNOWN, 0);
  }
  return Void();
}

Return<void> HealthImpl::getCurrentNow(getCurrentNow_cb _hidl_cb) {
  int32_t result = 0;
  int read = read_sysfs_int32_t(BATTERY_CURRENT_NOW, &result);
  if (read > 0) {
    KLOG_ERROR(LOG_TAG, "getCurrentNow: '%d'\n", result);
    _hidl_cb(Result::SUCCESS, result);
  } else {
    _hidl_cb(Result::UNKNOWN, 0);
  }
  return Void();
}

Return<void> HealthImpl::getCurrentAverage(getCurrentAverage_cb _hidl_cb) {
  int32_t result = 0;
  int read = read_sysfs_int32_t(BATTERY_CURRENT_AVG, &result);
  if (read > 0) {
    KLOG_ERROR(LOG_TAG, "getCurrentAverage: '%d'\n", result);
    _hidl_cb(Result::SUCCESS, result);
  } else {
    _hidl_cb(Result::UNKNOWN, 0);
  }
  return Void();
}

Return<void> HealthImpl::getCapacity(getCapacity_cb _hidl_cb) {
  int32_t result = 0;
  int read = read_sysfs_int32_t(BATTERY_CAPACITY, &result);
  if (read > 0) {
    KLOG_ERROR(LOG_TAG, "getCapacity: '%d'\n", result);
    _hidl_cb(Result::SUCCESS, result);
  } else {
    _hidl_cb(Result::UNKNOWN, 0);
  }
  return Void();
}

Return<void> HealthImpl::shouldKeepScreenOn(shouldKeepScreenOn_cb _hidl_cb)
{
  _hidl_cb(Result::SUCCESS, false);
  return Void();
}

Return<void> HealthImpl::getChargeStatus(getChargeStatus_cb _hidl_cb)
{
  // FIXME: https://source.android.com/devices/tech/health/implementation-2-1#battery-req
  const int SIZE = 16;
  char buf[SIZE];
  int read = read_sysfs(CHARGER_STATUS_SYSFS_PATH, buf, SIZE);
  KLOG_ERROR(LOG_TAG, "Current device state: '%s'\n", buf);
  if (read > 0) {
    if(std::strncmp("Charging", buf, read) == 0) {
      KLOG_ERROR(LOG_TAG, "Device is charging");
      _hidl_cb(Result::SUCCESS, BatteryStatus::CHARGING);
    } else if (std::strncmp("Not Charging", buf, read) == 0) {
      KLOG_ERROR(LOG_TAG, "Device is not chargin\n");
      _hidl_cb(Result::SUCCESS, BatteryStatus::DISCHARGING);
    } else {
      KLOG_ERROR(LOG_TAG, "Unknown charger state");
      _hidl_cb(Result::UNKNOWN, BatteryStatus::UNKNOWN);
    }
  } else {
    KLOG_ERROR(LOG_TAG, "Could not read charger file at '%s'\n", CHARGER_STATUS_SYSFS_PATH);
    _hidl_cb(Result::UNKNOWN, BatteryStatus::UNKNOWN);
  }

  return Void();
}

}  // namespace implementation
}  // namespace V2_1
}  // namespace health
}  // namespace hardware
}  // namespace android

extern "C" IHealth* HIDL_FETCH_IHealth(const char* instance) {
    using ::android::hardware::health::V2_1::implementation::HealthImpl;
    if (instance != "default"sv) {
        return nullptr;
    }
    auto config = std::make_unique<healthd_config>();
    InitHealthdConfig(config.get());

    // healthd_board_init(config.get());

    return new HealthImpl(std::move(config));
}