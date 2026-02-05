/// Defines all API endpoints for driver settings operations.
///
/// All endpoints are based on the FAST App API documentation.
/// Base URL: https://fasttaxi.questifysolutions.com/api/v1
abstract class DriverSettingsEndpoints {
  const DriverSettingsEndpoints._();

  /// Get driver settings.
  /// Endpoint: GET /driver/settings
  static const String getSettings = '/driver/settings';

  /// Update driver settings.
  /// Endpoint: POST /driver/settings/update
  static const String updateSettings = '/driver/settings/update';

  /// Update driver notification preferences.
  /// Endpoint: POST /driver/settings/notifications
  static const String updateNotifications = '/driver/settings/notifications';

  /// Update driver language preference.
  /// Endpoint: POST /driver/settings/language
  static const String updateLanguage = '/driver/settings/language';

  /// Update driver privacy settings.
  /// Endpoint: POST /driver/settings/privacy
  static const String updatePrivacy = '/driver/settings/privacy';

  /// Delete driver account.
  /// Endpoint: DELETE /driver/settings/account
  static const String deleteAccount = '/driver/settings/account';
}
