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
abstract class DriverAuthRemoteDataSource {
  /// Logs in a driver with phone and password.
  Future<ApiResult<DriverCredentialsModel>> login(DriverLoginParameters parameters);

  /// Logs out the current driver.
  Future<ApiResult<void>> logout();

  /// Registers a new driver.
  Future<ApiResult<DriverCredentialsModel>> register(DriverRegisterParameters parameters);

  /// Verifies driver phone number with OTP.
  Future<ApiResult<DriverCredentialsModel>> verifyPhone(VerifyDriverPhoneParameters parameters);

  /// Resets driver password.
  Future<ApiResult<void>> resetPassword(ResetDriverPasswordParameters parameters);

  /// Refreshes the access token.
  Future<ApiResult<DriverCredentialsModel>> refreshToken({required String refreshToken});

  /// Sends OTP to driver's phone.
  Future<ApiResult<void>> sendOtp({required String phone});

  /// Verifies OTP code.
  Future<ApiResult<DriverCredentialsModel>> verifyOtp({required String phone, required String otp});

  /// Requests password reset.
  Future<ApiResult<void>> forgotPassword({required String phone});

  /// Changes password (authenticated).
  Future<ApiResult<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Signs out from all devices.
  Future<ApiResult<void>> signOutAll();
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
  Future<ApiResult<void>> logout() async {
    return post<void>(path: DriverAuthEndpoints.logout);
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
  Future<ApiResult<void>> resetPassword(ResetDriverPasswordParameters parameters) async {
    return post<void>(path: DriverAuthEndpoints.resetPassword, data: parameters.toJson());
  }

  @override
  Future<ApiResult<DriverCredentialsModel>> refreshToken({required String refreshToken}) async {
    return post<DriverCredentialsModel>(
      path: DriverAuthEndpoints.refreshToken,
      data: {'refresh_token': refreshToken},
      decoder: (data) => DriverCredentialsModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<void>> sendOtp({required String phone}) async {
    return post<void>(path: DriverAuthEndpoints.sendOtp, data: {'phone': phone});
  }

  @override
  Future<ApiResult<DriverCredentialsModel>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    return post<DriverCredentialsModel>(
      path: DriverAuthEndpoints.verifyOtp,
      data: {'phone': phone, 'otp': otp},
      decoder: (data) => DriverCredentialsModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<void>> forgotPassword({required String phone}) async {
    return post<void>(path: DriverAuthEndpoints.forgotPassword, data: {'phone': phone});
  }

  @override
  Future<ApiResult<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return post<void>(
      path: DriverAuthEndpoints.changePassword,
      data: {'current_password': currentPassword, 'new_password': newPassword},
    );
  }

  @override
  Future<ApiResult<void>> signOutAll() async {
    return post<void>(path: DriverAuthEndpoints.signOutAll);
  }
}
