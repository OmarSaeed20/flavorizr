import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_client.dart';
import 'package:flavorizr/core/network/base/datasource/base_data_source.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver_settings/data/endpoints/driver_settings_endpoints.dart';
import 'package:flavorizr/features/driver_settings/data/models/driver_settings_model.dart';
import 'package:flavorizr/features/driver_settings/data/parameters/update_driver_settings_parameters.dart';

/// Remote data source for driver settings operations.
///
/// Handles all HTTP requests related to driver settings.
/// Returns ApiResult with success or error data.
abstract class DriverSettingsRemoteDataSource {
  /// Gets driver settings.
  Future<ApiResult<DriverSettingsModel>> getDriverSettings();

  /// Updates driver settings.
  Future<ApiResult<DriverSettingsModel>> updateDriverSettings(
    UpdateDriverSettingsParameters parameters,
  );

  /// Toggles online status.
  Future<ApiResult<DriverSettingsModel>> toggleOnlineStatus(bool isOnline);

  /// Toggles availability status.
  Future<ApiResult<DriverSettingsModel>> toggleAvailabilityStatus(bool isAvailable);

  /// Gets driver notification preferences.
  Future<ApiResult<Map<String, dynamic>>> getNotificationPreferences();

  /// Updates driver notification preferences.
  Future<ApiResult<void>> updateNotificationPreferences(Map<String, dynamic> preferences);

  /// Gets driver privacy settings.
  Future<ApiResult<Map<String, dynamic>>> getPrivacySettings();

  /// Updates driver privacy settings.
  Future<ApiResult<void>> updatePrivacySettings(Map<String, dynamic> settings);

  /// Gets driver payment settings.
  Future<ApiResult<Map<String, dynamic>>> getPaymentSettings();

  /// Updates driver payment settings.
  Future<ApiResult<void>> updatePaymentSettings(Map<String, dynamic> settings);
}

/// Implementation of [DriverSettingsRemoteDataSource] using BaseRemoteDataSource.
class DriverSettingsRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements DriverSettingsRemoteDataSource {
  const DriverSettingsRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  @override
  Future<ApiResult<DriverSettingsModel>> getDriverSettings() async {
    return get<DriverSettingsModel>(
      path: DriverSettingsEndpoints.settings,
      decoder: (data) => DriverSettingsModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverSettingsModel>> updateDriverSettings(
    UpdateDriverSettingsParameters parameters,
  ) async {
    return put<DriverSettingsModel>(
      path: DriverSettingsEndpoints.updateSettings,
      data: parameters.toJson(),
      decoder: (data) => DriverSettingsModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverSettingsModel>> toggleOnlineStatus(bool isOnline) async {
    return post<DriverSettingsModel>(
      path: DriverSettingsEndpoints.toggleOnline,
      data: {'is_online': isOnline},
      decoder: (data) => DriverSettingsModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverSettingsModel>> toggleAvailabilityStatus(bool isAvailable) async {
    return post<DriverSettingsModel>(
      path: DriverSettingsEndpoints.toggleAvailability,
      data: {'is_available': isAvailable},
      decoder: (data) => DriverSettingsModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getNotificationPreferences() async {
    return get<Map<String, dynamic>>(
      path: DriverSettingsEndpoints.notificationPreferences,
      decoder: (data) => data as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResult<void>> updateNotificationPreferences(Map<String, dynamic> preferences) async {
    return put<void>(
      path: DriverSettingsEndpoints.updateNotificationPreferences,
      data: preferences,
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getPrivacySettings() async {
    return get<Map<String, dynamic>>(
      path: DriverSettingsEndpoints.privacySettings,
      decoder: (data) => data as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResult<void>> updatePrivacySettings(Map<String, dynamic> settings) async {
    return put<void>(path: DriverSettingsEndpoints.updatePrivacySettings, data: settings);
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getPaymentSettings() async {
    return get<Map<String, dynamic>>(
      path: DriverSettingsEndpoints.paymentSettings,
      decoder: (data) => data as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResult<void>> updatePaymentSettings(Map<String, dynamic> settings) async {
    return put<void>(path: DriverSettingsEndpoints.updatePaymentSettings, data: settings);
  }
}
