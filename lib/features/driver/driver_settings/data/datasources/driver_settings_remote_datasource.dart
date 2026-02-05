import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_client.dart';
import 'package:flavorizr/core/network/base/datasource/base_data_source.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_settings/data/endpoints/driver_settings_endpoints.dart';
import 'package:flavorizr/features/driver/driver_settings/data/models/driver_settings_model.dart';
import 'package:flavorizr/features/driver/driver_settings/data/parameters/update_driver_settings_parameters.dart';
import 'package:flavorizr/features/driver/driver_settings/data/parameters/update_language_parameters.dart';
import 'package:flavorizr/features/driver/driver_settings/data/parameters/update_notification_parameters.dart';
import 'package:flavorizr/features/driver/driver_settings/data/parameters/update_privacy_parameters.dart';

/// Remote data source for driver settings operations.
///
/// Handles all HTTP requests related to driver settings.
/// Returns ApiResult with success or error data.
/// Based on the FAST App API documentation.
abstract class DriverSettingsRemoteDataSource {
  /// Get driver settings.
  /// Endpoint: GET /driver/settings
  Future<ApiResult<DriverSettingsModel>> getSettings();

  /// Update driver settings.
  /// Endpoint: POST /driver/settings/update
  Future<ApiResult<DriverSettingsModel>> updateSettings(
    UpdateDriverSettingsParameters parameters,
  );

  /// Update driver notification preferences.
  /// Endpoint: POST /driver/settings/notifications
  Future<ApiResult<DriverSettingsModel>> updateNotifications(
    UpdateNotificationParameters parameters,
  );

  /// Update driver language preference.
  /// Endpoint: POST /driver/settings/language
  Future<ApiResult<DriverSettingsModel>> updateLanguage(
    UpdateLanguageParameters parameters,
  );

  /// Update driver privacy settings.
  /// Endpoint: POST /driver/settings/privacy
  Future<ApiResult<DriverSettingsModel>> updatePrivacy(
    UpdatePrivacyParameters parameters,
  );

  /// Delete driver account.
  /// Endpoint: DELETE /driver/settings/account
  Future<ApiResult<void>> deleteAccount();
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
  Future<ApiResult<DriverSettingsModel>> getSettings() async {
    return get<DriverSettingsModel>(
      path: DriverSettingsEndpoints.getSettings,
      decoder: (data) =>
          DriverSettingsModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverSettingsModel>> updateSettings(
    UpdateDriverSettingsParameters parameters,
  ) async {
    return post<DriverSettingsModel>(
      path: DriverSettingsEndpoints.updateSettings,
      data: parameters.toJson(),
      decoder: (data) =>
          DriverSettingsModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverSettingsModel>> updateNotifications(
    UpdateNotificationParameters parameters,
  ) async {
    return post<DriverSettingsModel>(
      path: DriverSettingsEndpoints.updateNotifications,
      data: parameters.toJson(),
      decoder: (data) =>
          DriverSettingsModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverSettingsModel>> updateLanguage(
    UpdateLanguageParameters parameters,
  ) async {
    return post<DriverSettingsModel>(
      path: DriverSettingsEndpoints.updateLanguage,
      data: parameters.toJson(),
      decoder: (data) =>
          DriverSettingsModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverSettingsModel>> updatePrivacy(
    UpdatePrivacyParameters parameters,
  ) async {
    return post<DriverSettingsModel>(
      path: DriverSettingsEndpoints.updatePrivacy,
      data: parameters.toJson(),
      decoder: (data) =>
          DriverSettingsModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<void>> deleteAccount() async {
    return delete<void>(path: DriverSettingsEndpoints.deleteAccount);
  }
}
