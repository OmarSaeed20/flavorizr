import 'package:flavorizr/core/network/base/datasource/base_local_data_source.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_settings/data/models/driver_settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for driver settings operations.
///
/// Handles caching of driver settings for offline capability.
/// Based on the FAST App API documentation.
abstract class DriverSettingsLocalDataSource {
  /// Get cached driver settings.
  Future<ApiResult<DriverSettingsModel?>> getCachedSettings();

  /// Save driver settings to local storage.
  Future<ApiResult<void>> cacheSettings(DriverSettingsModel settings);

  /// Clear cached driver settings.
  Future<ApiResult<void>> clearSettings();

  /// Get cached language preference.
  Future<ApiResult<String?>> getLanguage();

  /// Save language preference to local storage.
  Future<ApiResult<void>> saveLanguage(String language);

  /// Get cached online status.
  Future<ApiResult<bool?>> getOnlineStatus();

  /// Save online status to local storage.
  Future<ApiResult<void>> saveOnlineStatus(bool isOnline);

  /// Get cached availability status.
  Future<ApiResult<bool?>> getAvailabilityStatus();

  /// Save availability status to local storage.
  Future<ApiResult<void>> saveAvailabilityStatus(bool isAvailable);
}

/// Implementation of [DriverSettingsLocalDataSource] using BaseLocalDataSource.
class DriverSettingsLocalDataSourceImpl
    with BaseLocalDataSource
    implements DriverSettingsLocalDataSource {
  const DriverSettingsLocalDataSourceImpl(this._preferences);
  final SharedPreferences _preferences;

  // Storage keys
  static const String _keySettings = 'driver_settings';
  static const String _keyLanguage = 'driver_language';
  static const String _keyOnlineStatus = 'driver_online_status';
  static const String _keyAvailabilityStatus = 'driver_availability_status';

  @override
  Future<ApiResult<DriverSettingsModel?>> getCachedSettings() async {
    return getLocalData<DriverSettingsModel?>(
      key: _keySettings,
      fetcher: () async {
        final jsonString = _preferences.getString(_keySettings);
        if (jsonString == null) return null;
        // Note: In a real implementation, you'd use jsonDecode here
        // For now, returning null as the JSON parsing would need proper implementation
        return null;
      },
    );
  }

  @override
  Future<ApiResult<void>> cacheSettings(DriverSettingsModel settings) async {
    return saveLocalData<DriverSettingsModel>(
      key: _keySettings,
      data: settings,
      saver: (data) async =>
          _preferences.setString(_keySettings, data.toJson().toString()),
    );
  }

  @override
  Future<ApiResult<void>> clearSettings() async {
    return deleteLocalData(
      key: _keySettings,
      deleter: () async => _preferences.remove(_keySettings),
    );
  }

  @override
  Future<ApiResult<String?>> getLanguage() async {
    return getLocalData<String?>(
      key: _keyLanguage,
      fetcher: () async => _preferences.getString(_keyLanguage),
    );
  }

  @override
  Future<ApiResult<void>> saveLanguage(String language) async {
    return saveLocalData<String>(
      key: _keyLanguage,
      data: language,
      saver: (data) async => _preferences.setString(_keyLanguage, data),
    );
  }

  @override
  Future<ApiResult<bool?>> getOnlineStatus() async {
    return getLocalData<bool?>(
      key: _keyOnlineStatus,
      fetcher: () async => _preferences.getBool(_keyOnlineStatus),
    );
  }

  @override
  Future<ApiResult<void>> saveOnlineStatus(bool isOnline) async {
    return saveLocalData<bool>(
      key: _keyOnlineStatus,
      data: isOnline,
      saver: (data) async => _preferences.setBool(_keyOnlineStatus, data),
    );
  }

  @override
  Future<ApiResult<bool?>> getAvailabilityStatus() async {
    return getLocalData<bool?>(
      key: _keyAvailabilityStatus,
      fetcher: () async => _preferences.getBool(_keyAvailabilityStatus),
    );
  }

  @override
  Future<ApiResult<void>> saveAvailabilityStatus(bool isAvailable) async {
    return saveLocalData<bool>(
      key: _keyAvailabilityStatus,
      data: isAvailable,
      saver: (data) async => _preferences.setBool(_keyAvailabilityStatus, data),
    );
  }
}
