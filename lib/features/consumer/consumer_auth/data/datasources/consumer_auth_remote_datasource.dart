// lib/features/consumer/consumer_auth/data/datasources/consumer_auth_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/core/network/api_client.dart';
import 'package:fast_golden_taxi/core/network/base/datasource/base_data_source.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/endpoints/consumer_auth_endpoints.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_forget_password_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_login_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_logout_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_register_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_reset_password_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_send_verification_code_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_verify_phone_parameters.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_result.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_tokens.dart';

/// Remote data source for consumer authentication operations.
///
/// Handles all HTTP requests related to consumer authentication.
/// Consumers are regular users booking rides (company_type: "customer").
/// Returns ApiResult with success or error data.
/// Based on API_DOCUMENTATION.md
abstract class ConsumerAuthRemoteDataSource {
  /// Signs in consumer with phone and password.
  Future<ApiResult<AuthResult>> login(ConsumerLoginParameters parameters);

  /// Creates a new consumer account.
  Future<ApiResult<AuthResult>> register(ConsumerRegisterParameters parameters);

  /// Logs out the current consumer.
  Future<ApiResult<void>> logout(ConsumerLogoutParameters parameters);

  /// Sends verification code to consumer's phone.
  Future<ApiResult<void>> sendVerificationCode(
    ConsumerSendVerificationCodeParameters parameters,
  );

  /// Verifies consumer phone number with verification code.
  Future<ApiResult<AuthResult>> verifyPhone(
    ConsumerVerifyPhoneParameters parameters,
  );

  /// Resets password with token.
  Future<ApiResult<void>> resetPassword(
    ConsumerResetPasswordParameters parameters,
  );

  /// Requests password reset code.
  Future<ApiResult<void>> forgetPassword(
    ConsumerForgetPasswordParameters parameters,
  );

  /// Gets current consumer profile.
  Future<ApiResult<UserModel>> getCurrentUser();

  /// Signs out from all devices.
  Future<ApiResult<void>> signOutAllDevices();

  /// Refreshes authentication tokens.
  Future<ApiResult<AuthTokens>> refreshToken(String refreshToken);
}

/// Implementation of [ConsumerAuthRemoteDataSource] using BaseRemoteDataSource.
class ConsumerAuthRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements ConsumerAuthRemoteDataSource {
  const ConsumerAuthRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  @override
  Future<ApiResult<AuthResult>> login(
    ConsumerLoginParameters parameters,
  ) async {
    return post<AuthResult>(
      path: ConsumerAuthEndpoints.login,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
      decoder: (data) => _parseAuthResponse(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<AuthResult>> register(
    ConsumerRegisterParameters parameters,
  ) async {
    return post<AuthResult>(
      path: ConsumerAuthEndpoints.register,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
      decoder: (data) => _parseAuthResponse(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<void>> logout(ConsumerLogoutParameters parameters) async {
    return post<void>(
      path: ConsumerAuthEndpoints.logout,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
    );
  }

  @override
  Future<ApiResult<void>> sendVerificationCode(
    ConsumerSendVerificationCodeParameters parameters,
  ) async {
    return post<void>(
      path: ConsumerAuthEndpoints.sendVerificationCode,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
    );
  }

  @override
  Future<ApiResult<AuthResult>> verifyPhone(
    ConsumerVerifyPhoneParameters parameters,
  ) async {
    return post<AuthResult>(
      path: ConsumerAuthEndpoints.verifyPhone,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
      decoder: (data) => _parseAuthResponse(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<void>> resetPassword(
    ConsumerResetPasswordParameters parameters,
  ) async {
    return post<void>(
      path: ConsumerAuthEndpoints.resetPassword,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
    );
  }

  @override
  Future<ApiResult<void>> forgetPassword(
    ConsumerForgetPasswordParameters parameters,
  ) async {
    return post<void>(
      path: ConsumerAuthEndpoints.forgetPassword,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
    );
  }

  @override
  Future<ApiResult<UserModel>> getCurrentUser() async {
    return get<UserModel>(
      path: ConsumerAuthEndpoints.profile,
      decoder: (data) {
        final jsonData = data as Map<String, dynamic>;
        return UserModel.fromJson(
          jsonData['user'] as Map<String, dynamic>? ?? jsonData,
        );
      },
    );
  }

  @override
  Future<ApiResult<void>> signOutAllDevices() async {
    return post<void>(path: '/auth/sign-out-all');
  }

  @override
  Future<ApiResult<AuthTokens>> refreshToken(String refreshToken) async {
    return post<AuthTokens>(
      path: ConsumerAuthEndpoints.refreshToken,
      data: {'refresh_token': refreshToken},
      decoder: (data) =>
          AuthTokens.fromApiResponse(data as Map<String, dynamic>),
    );
  }

  /// Parses authentication response from API.
  ///
  /// Handles different response formats and extracts tokens and user data.
  AuthResult _parseAuthResponse(Map<String, dynamic> data) {
    final tokens = AuthTokens.fromApiResponse(data);
    final userJson = data['user'] as Map<String, dynamic>?;
    final userModel = userJson != null ? UserModel.fromJson(userJson) : null;
    final user = userModel?.toEntity();
    return AuthResult(tokens: tokens, user: user!);
  }
}
