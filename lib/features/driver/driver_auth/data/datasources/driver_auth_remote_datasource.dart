import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_client.dart';
import 'package:flavorizr/core/network/base/datasource/base_data_source.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_auth/data/endpoints/driver_auth_endpoints.dart';
import 'package:flavorizr/features/driver/driver_auth/data/models/driver_credentials_model.dart';
import 'package:flavorizr/features/driver/driver_auth/data/parameters/driver_login_parameters.dart';
import 'package:flavorizr/features/driver/driver_auth/data/parameters/driver_register_parameters.dart';
import 'package:flavorizr/features/driver/driver_auth/data/parameters/reset_driver_password_parameters.dart';
import 'package:flavorizr/features/driver/driver_auth/data/parameters/verify_driver_phone_parameters.dart';

/// Remote data source for driver authentication operations.
///
/// Handles all HTTP requests related to driver authentication.
/// Returns ApiResult with success or error data.
/// Based on the FAST App API documentation.
abstract class DriverAuthRemoteDataSource {
  /// Logs in a driver with phone and password.
  /// Endpoint: POST /driver/auth/login
  Future<ApiResult<DriverCredentialsModel>> login(DriverLoginParameters parameters);

  /// Registers a new driver.
  /// Endpoint: POST /driver/auth/register
  Future<ApiResult<DriverCredentialsModel>> register(DriverRegisterParameters parameters);

  /// Verifies driver phone number with verification code.
  /// Endpoint: POST /driver/auth/user-verify
  Future<ApiResult<DriverCredentialsModel>> verifyPhone(VerifyDriverPhoneParameters parameters);

  /// Requests password reset for driver.
  /// Endpoint: POST /driver/auth/forget-password
  Future<ApiResult<void>> forgetPassword({required String phone});

  /// Resets driver password using verification code.
  /// Endpoint: POST /driver/auth/reset-password
  Future<ApiResult<void>> resetPassword(ResetDriverPasswordParameters parameters);

  /// Logs out the current driver.
  /// Endpoint: POST /driver/auth/logout
  Future<ApiResult<void>> logout();

  /// Refreshes the driver authentication token.
  /// Endpoint: POST /driver/auth/refresh
  Future<ApiResult<DriverCredentialsModel>> refreshToken();
}

/// Implementation of [DriverAuthRemoteDataSource] using BaseRemoteDataSource.
class DriverAuthRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements DriverAuthRemoteDataSource {
  const DriverAuthRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  @override
  Future<ApiResult<DriverCredentialsModel>> login(DriverLoginParameters parameters) async {
    return post<DriverCredentialsModel>(
      path: DriverAuthEndpoints.login,
      data: parameters.toJson(),
      decoder: (data) => DriverCredentialsModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverCredentialsModel>> register(DriverRegisterParameters parameters) async {
    return post<DriverCredentialsModel>(
      path: DriverAuthEndpoints.register,
      data: parameters.toJson(),
      decoder: (data) => DriverCredentialsModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverCredentialsModel>> verifyPhone(
    VerifyDriverPhoneParameters parameters,
  ) async {
    return post<DriverCredentialsModel>(
      path: DriverAuthEndpoints.verifyPhone,
      data: parameters.toJson(),
      decoder: (data) => DriverCredentialsModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<void>> forgetPassword({required String phone}) async {
    return post<void>(path: DriverAuthEndpoints.forgetPassword, data: {'phone': phone});
  }

  @override
  Future<ApiResult<void>> resetPassword(ResetDriverPasswordParameters parameters) async {
    return post<void>(path: DriverAuthEndpoints.resetPassword, data: parameters.toJson());
  }

  @override
  Future<ApiResult<void>> logout() async {
    return post<void>(path: DriverAuthEndpoints.logout);
  }

  @override
  Future<ApiResult<DriverCredentialsModel>> refreshToken() async {
    return post<DriverCredentialsModel>(
      path: DriverAuthEndpoints.refreshToken,
      decoder: (data) => DriverCredentialsModel.fromJson(data as Map<String, dynamic>),
    );
  }
}
