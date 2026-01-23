// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_endpoints.dart';
import 'package:flavorizr/features/auth/data/models/user_model.dart';
import 'package:flavorizr/features/auth/domain/entities/auth_tokens.dart';

/// Remote data source for authentication operations.
///
/// Handles all HTTP requests related to authentication.
/// Throws exceptions on errors which are caught by the repository.
abstract class AuthRemoteDataSource {
  /// Signs in with email and password.
  Future<({UserModel user, AuthTokens tokens})> signInWithEmail({
    required String email,
    required String password,
  });

  /// Signs in with Google OAuth token.
  Future<({UserModel user, AuthTokens tokens})> signInWithGoogle({required String idToken});

  /// Signs in with Apple OAuth token.
  Future<({UserModel user, AuthTokens tokens})> signInWithApple({
    required String idToken,
    required String authorizationCode,
  });

  /// Verifies OTP and returns user/tokens.
  Future<({UserModel user, AuthTokens tokens})> verifyOtp({
    required String verificationId,
    required String otpCode,
  });

  /// Verifies magic link and returns user/tokens.
  Future<({UserModel user, AuthTokens tokens})> verifyMagicLink({required String token});

  /// Creates a new user account.
  Future<({UserModel user, AuthTokens tokens})> signUp({
    required String email,
    required String password,
    String? displayName,
  });

  /// Sends password reset email.
  Future<void> sendPasswordResetEmail({required String email});

  /// Resets password with token.
  Future<void> resetPassword({required String token, required String newPassword});

  /// Changes current user's password.
  Future<void> changePassword({required String currentPassword, required String newPassword});

  /// Gets current user profile.
  Future<UserModel> getCurrentUser();

  /// Refreshes access token.
  Future<AuthTokens> refreshTokens({required String refreshToken});

  /// Signs out (invalidates refresh token).
  Future<void> signOut({required String refreshToken});

  /// Signs out from all devices.
  Future<void> signOutAllDevices();

  /// Sends OTP to phone number.
  Future<String> sendOtp({required String phoneNumber});

  /// Sends magic link to email.
  Future<void> sendMagicLink({required String email});

  /// Resends email verification.
  Future<void> resendEmailVerification();

  /// Verifies email with token.
  Future<void> verifyEmail({required String token});
}

/// Implementation of [AuthRemoteDataSource] using Dio.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<({UserModel user, AuthTokens tokens})> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.signIn,
      data: {'email': email, 'password': password},
    );
    return _parseAuthResponse(response.data!);
  }

  @override
  Future<({UserModel user, AuthTokens tokens})> signInWithGoogle({required String idToken}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.googleSignIn,
      data: {'id_token': idToken},
    );
    return _parseAuthResponse(response.data!);
  }

  @override
  Future<({UserModel user, AuthTokens tokens})> signInWithApple({
    required String idToken,
    required String authorizationCode,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.appleSignIn,
      data: {'id_token': idToken, 'authorization_code': authorizationCode},
    );
    return _parseAuthResponse(response.data!);
  }

  @override
  Future<({UserModel user, AuthTokens tokens})> verifyOtp({
    required String verificationId,
    required String otpCode,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.verifyOtp,
      data: {'verification_id': verificationId, 'otp_code': otpCode},
    );
    return _parseAuthResponse(response.data!);
  }

  @override
  Future<({UserModel user, AuthTokens tokens})> verifyMagicLink({required String token}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.verifyMagicLink,
      data: {'token': token},
    );
    return _parseAuthResponse(response.data!);
  }

  @override
  Future<({UserModel user, AuthTokens tokens})> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.signUp,
      data: {
        'email': email,
        'password': password,
        if (displayName != null) 'display_name': displayName,
      },
    );
    return _parseAuthResponse(response.data!);
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _dio.post<void>(ApiEndpoints.forgotPassword, data: {'email': email});
  }

  @override
  Future<void> resetPassword({required String token, required String newPassword}) async {
    await _dio.post<void>(
      ApiEndpoints.resetPassword,
      data: {'token': token, 'new_password': newPassword},
    );
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _dio.post<void>(
      ApiEndpoints.changePassword,
      data: {'current_password': currentPassword, 'new_password': newPassword},
    );
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.me);
    final data = response.data!;
    return UserModel.fromJson(data['user'] as Map<String, dynamic>? ?? data);
  }

  @override
  Future<AuthTokens> refreshTokens({required String refreshToken}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.refreshToken,
      data: {'refresh_token': refreshToken},
    );
    return _parseTokens(response.data!);
  }

  @override
  Future<void> signOut({required String refreshToken}) async {
    await _dio.post<void>(ApiEndpoints.signOut, data: {'refresh_token': refreshToken});
  }

  @override
  Future<void> signOutAllDevices() async {
    await _dio.post<void>(ApiEndpoints.signOutAll);
  }

  @override
  Future<String> sendOtp({required String phoneNumber}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.sendOtp,
      data: {'phone_number': phoneNumber},
    );
    return response.data!['verification_id'] as String;
  }

  @override
  Future<void> sendMagicLink({required String email}) async {
    await _dio.post<void>(ApiEndpoints.sendMagicLink, data: {'email': email});
  }

  @override
  Future<void> resendEmailVerification() async {
    await _dio.post<void>(ApiEndpoints.resendVerification);
  }

  @override
  Future<void> verifyEmail({required String token}) async {
    await _dio.post<void>(ApiEndpoints.verifyEmail, data: {'token': token});
  }

  /// Parses auth response containing user and tokens.
  ({UserModel user, AuthTokens tokens}) _parseAuthResponse(Map<String, dynamic> data) {
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
    final tokens = _parseTokens(data);
    return (user: user, tokens: tokens);
  }

  /// Parses tokens from response.
  AuthTokens _parseTokens(Map<String, dynamic> data) {
    final expiresIn = data['expires_in'] as int? ?? 3600;
    final refreshExpiresIn = data['refresh_expires_in'] as int?;

    return AuthTokens(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
      accessTokenExpiresAt: DateTime.now().add(Duration(seconds: expiresIn)),
      refreshTokenExpiresAt: refreshExpiresIn != null
          ? DateTime.now().add(Duration(seconds: refreshExpiresIn))
          : null,
      tokenType: data['token_type'] as String? ?? 'Bearer',
    );
  }
}
