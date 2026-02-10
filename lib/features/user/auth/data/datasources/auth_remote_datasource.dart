// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/core/network/api_client.dart';
import 'package:fast_golden_taxi/core/network/base/datasource/base_data_source.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/auth/data/endpoints/auth_endpoints.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/forget_password_parameters.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/login_parameters.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/logout_parameters.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/refresh_token_parameters.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/register_parameters.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/reset_password_parameters.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/send_verification_code_parameters.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/verify_phone_parameters.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_result.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_tokens.dart';

/// Remote data source for authentication operations.
///
/// Handles all HTTP requests related to authentication.
/// Returns ApiResult with success or error data.
/// Based on API_DOCUMENTATION.md
abstract class AuthRemoteDataSource {
  /// Signs in with phone and password.
  Future<ApiResult<AuthResult>> login(LoginParameters parameters);

  /// Creates a new user account.
  Future<ApiResult<AuthResult>> register(RegisterParameters parameters);

  /// Logs out the current user.
  Future<ApiResult<void>> logout(LogoutParameters parameters);

  /// Sends verification code to user's phone.
  Future<ApiResult<void>> sendVerificationCode(
    SendVerificationCodeParameters parameters,
  );

  /// Verifies user phone number with verification code.
  Future<ApiResult<AuthResult>> verifyPhone(VerifyPhoneParameters parameters);

  /// Resets password with token.
  Future<ApiResult<void>> resetPassword(ResetPasswordParameters parameters);

  /// Requests password reset code.
  Future<ApiResult<void>> forgetPassword(ForgetPasswordParameters parameters);

  /// Gets current user profile.
  Future<ApiResult<UserModel>> getCurrentUser();

  /// Signs out from all devices.
  Future<ApiResult<void>> signOutAllDevices();

  /// Refreshes authentication tokens.
  Future<ApiResult<AuthTokens>> refreshToken(RefreshTokenParameters parameters);
}

/// Implementation of [AuthRemoteDataSource] using BaseRemoteDataSource.
class AuthRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  @override
  Future<ApiResult<AuthResult>> login(LoginParameters parameters) async {
    return post<AuthResult>(
      path: AuthEndpoints.login,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
      decoder: (data) => _parseAuthResponse(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<AuthResult>> register(RegisterParameters parameters) async {
    return post<AuthResult>(
      path: AuthEndpoints.register,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
      decoder: (data) => _parseAuthResponse(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<void>> logout(LogoutParameters parameters) async {
    return post<void>(
      path: AuthEndpoints.logout,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
    );
  }

  @override
  Future<ApiResult<void>> sendVerificationCode(
    SendVerificationCodeParameters parameters,
  ) async {
    return post<void>(
      path: AuthEndpoints.sendVerificationCode,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
    );
  }

  @override
  Future<ApiResult<AuthResult>> verifyPhone(
    VerifyPhoneParameters parameters,
  ) async {
    return post<AuthResult>(
      path: AuthEndpoints.verifyPhone,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
      decoder: (data) => _parseAuthResponse(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<void>> resetPassword(
    ResetPasswordParameters parameters,
  ) async {
    return post<void>(
      path: AuthEndpoints.resetPassword,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
    );
  }

  @override
  Future<ApiResult<void>> forgetPassword(
    ForgetPasswordParameters parameters,
  ) async {
    return post<void>(
      path: AuthEndpoints.forgetPassword,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
    );
  }

  @override
  Future<ApiResult<UserModel>> getCurrentUser() async {
    return get<UserModel>(
      path: AuthEndpoints.profile,
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

  /// Refresh authentication tokens
  @override
  Future<ApiResult<AuthTokens>> refreshToken(
    RefreshTokenParameters parameters,
  ) async {
    return post<AuthTokens>(
      path: AuthEndpoints.refreshToken,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
      decoder: (data) => _parseTokens(data as Map<String, dynamic>),
    );
  }

  /// Parses auth response containing user and tokens.
  AuthResult _parseAuthResponse(Map<String, dynamic> data) {
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
    final tokens = _parseTokens(data);
    return AuthResult(user: user.toEntity(), tokens: tokens);
  }

  /// Parses tokens from response.
  /// Based on API_DOCUMENTATION.md
  AuthTokens _parseTokens(Map<String, dynamic> data) {
    final expiresIn = data['expires_in'] as int? ?? 3600;
    final refreshExpiresIn = data['refresh_expires_in'] as int?;

    // Handle both 'token' and 'access_token' field names
    final accessToken =
        (data['access_token'] as String?) ?? (data['token'] as String?);
    // Handle both 'refreshToken' and 'refresh_token' field names
    final refreshToken =
        (data['refresh_token'] as String?) ?? (data['refreshToken'] as String?);

    return AuthTokens(
      accessToken: accessToken ?? '',
      refreshToken: refreshToken ?? '',
      accessTokenExpiresAt: DateTime.now().add(Duration(seconds: expiresIn)),
      refreshTokenExpiresAt: refreshExpiresIn != null
          ? DateTime.now().add(Duration(seconds: refreshExpiresIn))
          : null,
      tokenType: data['token_type'] as String? ?? 'Bearer',
    );
  }
}
