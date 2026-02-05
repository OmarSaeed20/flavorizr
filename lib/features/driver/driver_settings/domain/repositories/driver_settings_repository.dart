import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_settings/data/parameters/update_driver_settings_parameters.dart';
import 'package:flavorizr/features/driver/driver_settings/domain/entities/driver_settings.dart';

/// Repository interface for driver settings operations.
abstract class DriverSettingsRepository {
  /// Gets driver settings.
  Future<ApiResult<DriverSettings>> getDriverSettings();

  /// Updates driver settings.
  Future<ApiResult<DriverSettings>> updateDriverSettings(
    UpdateDriverSettingsParameters params,
  );

  /// Toggles online status.
  Future<ApiResult<DriverSettings>> toggleOnlineStatus(bool isOnline);

  /// Toggles availability status.
  Future<ApiResult<DriverSettings>> toggleAvailabilityStatus(bool isAvailable);
}