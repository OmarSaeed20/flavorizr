// lib/features/company/company_auth/data/datasources/company_auth_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/config/app_config.dart';
import 'package:fast_golden_taxi/core/network/base/datasource/base_data_source.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/endpoints/company_auth_endpoints.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_forget_password_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_login_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_logout_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_register_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_reset_password_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_send_verification_code_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_verify_phone_parameters.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/api_auth_response.dart';

/// Company Authentication Remote Data Source
///
/// Handles all company authentication API calls.
/// Uses BaseRemoteDataSource mixin for consistent API call handling.
/// Based on API_DOCUMENTATION.md
class CompanyAuthRemoteDataSource with BaseRemoteDataSource {
  @override
  final Dio dio;

  @override
  String get baseUrl => AppConfig.instance.apiBaseUrl;

  CompanyAuthRemoteDataSource({required this.dio});

  /// Company login
  ///
  /// Authenticates company with phone and password.
  /// Returns AuthResult with tokens and user data.
  Future<ApiResult<ApiAuthResponse>> login(
    CompanyLoginParameters parameters,
  ) async {
    return safeApiCall(
      () => dio.post(
        CompanyAuthEndpoints.login,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      ),
      fromJson: (data) =>
          ApiAuthResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Company register
  ///
  /// Registers new company account.
  /// Returns AuthResult with tokens and user data.
  Future<ApiResult<ApiAuthResponse>> register(
    CompanyRegisterParameters parameters,
  ) async {
    return safeApiCall(
      () => dio.post(
        CompanyAuthEndpoints.register,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      ),
      fromJson: (data) =>
          ApiAuthResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Company logout
  ///
  /// Logs out company account and invalidates tokens.
  Future<ApiResult<void>> logout(CompanyLogoutParameters parameters) async {
    return safeApiCall(
      () => dio.post(
        CompanyAuthEndpoints.logout,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      ),
    );
  }

  /// Send verification code
  ///
  /// Sends verification code to company phone number.
  Future<ApiResult<void>> sendVerificationCode(
    CompanySendVerificationCodeParameters parameters,
  ) async {
    return safeApiCall(
      () => dio.post(
        CompanyAuthEndpoints.sendVerificationCode,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      ),
    );
  }

  /// Verify phone
  ///
  /// Verifies company phone number with confirmation code.
  Future<ApiResult<ApiAuthResponse>> verifyPhone(
    CompanyVerifyPhoneParameters parameters,
  ) async {
    return safeApiCall(
      () => dio.post(
        CompanyAuthEndpoints.verifyPhone,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      ),
      fromJson: (data) =>
          ApiAuthResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Forget password
  ///
  /// Initiates password reset for company account.
  Future<ApiResult<void>> forgetPassword(
    CompanyForgetPasswordParameters parameters,
  ) async {
    return safeApiCall(
      () => dio.post(
        CompanyAuthEndpoints.forgetPassword,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      ),
    );
  }

  /// Reset password
  ///
  /// Resets company password with verification code.
  Future<ApiResult<void>> resetPassword(
    CompanyResetPasswordParameters parameters,
  ) async {
    return safeApiCall(
      () => dio.post(
        CompanyAuthEndpoints.resetPassword,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      ),
    );
  }
}
