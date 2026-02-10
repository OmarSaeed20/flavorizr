import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/data/parameters/update_driver_settings_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/data/parameters/update_language_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/data/parameters/update_notification_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/data/parameters/update_privacy_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/domain/entities/driver_settings.dart';

/// Repository interface for driver settings operations.
///
/// Based on the FAST App API documentation.
abstract class DriverSettingsRepository {
  /// Get driver settings.
  /// Endpoint: GET /driver/settings
  Future<ApiResult<DriverSettings>> getSettings();

  /// Update driver settings.
  /// Endpoint: POST /driver/settings/update
  Future<ApiResult<DriverSettings>> updateSettings(
    UpdateDriverSettingsParameters parameters,
  );

  /// Update driver notification preferences.
  /// Endpoint: POST /driver/settings/notifications
  Future<ApiResult<DriverSettings>> updateNotifications(
    UpdateNotificationParameters parameters,
  );

  /// Update driver language preference.
  /// Endpoint: POST /driver/settings/language
  Future<ApiResult<DriverSettings>> updateLanguage(
    UpdateLanguageParameters parameters,
  );

  /// Update driver privacy settings.
  /// Endpoint: POST /driver/settings/privacy
  Future<ApiResult<DriverSettings>> updatePrivacy(
    UpdatePrivacyParameters parameters,
  );

  /// Delete driver account.
  /// Endpoint: DELETE /driver/settings/account
  Future<ApiResult<void>> deleteAccount();
}
