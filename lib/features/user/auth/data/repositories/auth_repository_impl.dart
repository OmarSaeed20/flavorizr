// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'dart:async';

import 'package:flavorizr/core/network/base/repo/base_repository.dart';
import 'package:flavorizr/core/network/exception/network_exceptions.dart';
import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/auth/data/datasources/auth_local_datasource.dart';
import 'package:flavorizr/features/user/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flavorizr/features/user/auth/data/models/user_model.dart';
import 'package:flavorizr/features/user/auth/data/parameters/change_password_parameters.dart';
import 'package:flavorizr/features/user/auth/data/parameters/forget_password_parameters.dart';
import 'package:flavorizr/features/user/auth/data/parameters/login_parameters.dart';
import 'package:flavorizr/features/user/auth/data/parameters/logout_parameters.dart';
import 'package:flavorizr/features/user/auth/data/parameters/refresh_token_parameters.dart';
import 'package:flavorizr/features/user/auth/data/parameters/register_parameters.dart';
import 'package:flavorizr/features/user/auth/data/parameters/reset_password_parameters.dart';
import 'package:flavorizr/features/user/auth/data/parameters/save_biometric_credentials_parameters.dart';
import 'package:flavorizr/features/user/auth/data/parameters/send_magic_link_parameters.dart';
import 'package:flavorizr/features/user/auth/data/parameters/send_otp_parameters.dart';
import 'package:flavorizr/features/user/auth/data/parameters/send_password_reset_email_parameters.dart';
import 'package:flavorizr/features/user/auth/data/parameters/send_verification_code_parameters.dart';
import 'package:flavorizr/features/user/auth/data/parameters/sign_in_with_email_parameters.dart';
import 'package:flavorizr/features/user/auth/data/parameters/sign_in_with_magic_link_parameters.dart';
import 'package:flavorizr/features/user/auth/data/parameters/sign_in_with_otp_parameters.dart';
import 'package:flavorizr/features/user/auth/data/parameters/verify_email_parameters.dart';
import 'package:flavorizr/features/user/auth/data/parameters/verify_phone_parameters.dart';
import 'package:flavorizr/features/user/auth/domain/entities/auth_result.dart';
import 'package:flavorizr/features/user/auth/domain/entities/auth_tokens.dart';
import 'package:flavorizr/features/user/auth/domain/entities/user.dart';
import 'package:flavorizr/features/user/auth/domain/repositories/auth_repository.dart';
import 'package:local_auth/local_auth.dart';

/// Callback type for Google Sign-In.
typedef GoogleSignInCallback = Future<String?> Function();

/// Callback type for Apple Sign-In.
typedef AppleSignInCallback = Future<({String idToken, String authorizationCode})?> Function();

/// Implementation of [AuthRepository].
///
/// Coordinates between remote and local data sources,
/// handles network connectivity, and manages auth state.
/// Extends BaseRepository.
class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
    LocalAuthentication? localAuth,
    this.googleSignIn,
    this.appleSignIn,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo,
       _localAuth = localAuth ?? LocalAuthentication() {
    _initializeAuthState();
  }

  final AuthRemoteDataSource _remoteDataSource;

  final AuthLocalDataSource _localDataSource;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  final NetworkInfo _networkInfo;
  final LocalAuthentication _localAuth;

  /// Callback for Google Sign-In.
  final GoogleSignInCallback? googleSignIn;

  /// Callback for Apple Sign-In.
  final AppleSignInCallback? appleSignIn;

  // Stream controllers for auth state
  final _authStateController = StreamController<User?>.broadcast();
  final _tokenRefreshController = StreamController<AuthTokens>.broadcast();

  User? _currentUser;

  /// Initializes auth state from local storage.
  Future<void> _initializeAuthState() async {
    final userResult = await _localDataSource.getUser();
    if (userResult.isValid) {
      _currentUser = userResult.data!.toEntity();
      _authStateController.add(_currentUser);
    }
  }

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  Stream<AuthTokens> get tokenRefreshes => _tokenRefreshController.stream;

  // ==================== Authentication ====================

  @override
  AuthEither<AuthResult> signInWithEmail(SignInWithEmailParameters parameters) async {
    // Note: This method is deprecated. Use login() with LoginParameters instead.
    // Kept for backward compatibility.
    final loginParams = LoginParameters(
      phone: parameters.email, // Using email as phone for now - adjust based on API requirements
      phoneIsoCode: 'EG', // Default ISO code - should be provided by parameters
      password: parameters.password,
      firebaseToken: '', // Firebase token should be provided
      deviceType: 'mobile',
      cancelToken: parameters.cancelToken,
    );

    final result = await executeRemoteRequest<AuthResult>(
      request: () => _remoteDataSource.login(loginParams),
    );

    if (result.isSuccess && result.data != null) {
      await _saveAuthData(result.data!.user.toModel(), result.data!.tokens);
    }

    return result;
  }

  /// Login with phone and password using parameter class.
  AuthEither<AuthResult> login(LoginParameters parameters) async {
    final result = await executeRemoteRequest<AuthResult>(
      request: () => _remoteDataSource.login(parameters),
    );

    if (result.isSuccess && result.data != null) {
      await _saveAuthData(result.data!.user.toModel(), result.data!.tokens);
    }

    return result;
  }

  @override
  AuthEither<AuthResult> signInWithGoogle() async {
    // Note: This method is not supported by the new API.
    return const ApiResult.exception(
      UnknownNetworkException(message: 'Google Sign-In is not supported by the current API.'),
    );
  }

  @override
  AuthEither<AuthResult> signInWithApple() async {
    // Note: This method is not supported by the new API.
    return const ApiResult.exception(
      UnknownNetworkException(message: 'Apple Sign-In is not supported by the current API.'),
    );
  }

  @override
  AuthEither<AuthResult> signInWithOtp(SignInWithOtpParameters parameters) async {
    // Note: This method is deprecated. Use verifyPhone() with VerifyPhoneParameters instead.
    final verifyParams = VerifyPhoneParameters(
      phone: parameters.verificationId, // Using verificationId as phone for compatibility
      verificationCode: parameters.otpCode,
      firebaseToken: '', // Firebase token should be provided
      cancelToken: parameters.cancelToken,
    );
    final result = await executeRemoteRequest<AuthResult>(
      request: () => _remoteDataSource.verifyPhone(verifyParams),
    );

    if (result.isSuccess && result.data != null) {
      await _saveAuthData(result.data!.user.toModel(), result.data!.tokens);
    }

    return result;
  }

  @override
  AuthEither<AuthResult> signInWithMagicLink(SignInWithMagicLinkParameters parameters) async {
    // Note: This method is not supported by the new API.
    return const ApiResult.exception(
      UnknownNetworkException(message: 'Magic link sign-in is not supported by the current API.'),
    );
  }

  // ==================== Registration ====================

  @override
  AuthEither<AuthResult> signUp(RegisterParameters parameters) async {
    // Note: This method is deprecated. Use register() with RegisterParameters instead.
    // Kept for backward compatibility.
    final result = await executeRemoteRequest<AuthResult>(
      request: () => _remoteDataSource.register(parameters),
    );

    if (result.isSuccess && result.data != null) {
      await _saveAuthData(
        result.data!.copyWith(isNewUser: true).user.toModel(),
        result.data!.tokens,
      );
    }

    return result;
  }

  /// Register new user with parameter class.
  AuthEither<AuthResult> register(RegisterParameters parameters) async {
    final result = await executeRemoteRequest<AuthResult>(
      request: () => _remoteDataSource.register(parameters),
    );

    if (result.isSuccess && result.data != null) {
      await _saveAuthData(
        result.data!.copyWith(isNewUser: true).user.toModel(),
        result.data!.tokens,
      );
    }

    return result;
  }

  // ==================== Password Recovery ====================

  @override
  AuthEither<void> sendPasswordResetEmail(SendPasswordResetEmailParameters parameters) async {
    // Note: This method is deprecated. Use forgetPassword() with ForgetPasswordParameters instead.
    final forgetParams = ForgetPasswordParameters(
      phone: parameters.email,
      cancelToken: parameters.cancelToken,
    );
    return executeRemoteRequest<void>(
      request: () => _remoteDataSource.forgetPassword(forgetParams),
    );
  }

  /// Request password reset code with parameter class.
  AuthEither<void> forgetPassword(ForgetPasswordParameters parameters) async {
    return executeRemoteRequest<void>(request: () => _remoteDataSource.forgetPassword(parameters));
  }

  @override
  AuthEither<void> resetPassword(ResetPasswordParameters parameters) async {
    return executeRemoteRequest<void>(request: () => _remoteDataSource.resetPassword(parameters));
  }

  @override
  AuthEither<void> changePassword(ChangePasswordParameters parameters) async {
    // Note: This method is not supported by the new API.
    // Use resetPasswordWithParams() instead.
    return const ApiResult.exception(
      UnknownNetworkException(
        message: 'changePassword is not supported. Use resetPasswordWithParams instead.',
      ),
    );
  }

  // ==================== OTP / Verification ====================

  @override
  AuthEither<String> sendOtp(SendOtpParameters parameters) async {
    // Note: This method is deprecated. Use sendVerificationCode() with SendVerificationCodeParameters instead.
    final verifyParams = SendVerificationCodeParameters(
      phone: parameters.phoneNumber,
      cancelToken: parameters.cancelToken,
    );
    final result = await executeRemoteRequest<void>(
      request: () => _remoteDataSource.sendVerificationCode(verifyParams),
    );

    // Return phone as verification ID for compatibility
    if (result.isSuccess) {
      return ApiResult.success(parameters.phoneNumber);
    } else {
      return ApiResult.exception(result.error ?? const UnknownNetworkException());
    }
  }

  /// Send verification code with parameter class.
  AuthEither<void> sendVerificationCode(SendVerificationCodeParameters parameters) async {
    return executeRemoteRequest<void>(
      request: () => _remoteDataSource.sendVerificationCode(parameters),
    );
  }

  @override
  AuthEither<void> sendMagicLink(SendMagicLinkParameters parameters) async {
    // Note: This method is not supported by the new API.
    return const ApiResult.exception(
      UnknownNetworkException(
        message: 'sendMagicLink is not supported. Use sendVerificationCode instead.',
      ),
    );
  }

  @override
  AuthEither<void> resendEmailVerification() async {
    // Note: This method is deprecated. Use sendVerificationCode() with SendVerificationCodeParameters instead.
    return const ApiResult.exception(
      UnknownNetworkException(
        message: 'resendEmailVerification is deprecated. Use sendVerificationCode instead.',
      ),
    );
  }

  @override
  AuthEither<void> verifyEmail(VerifyEmailParameters parameters) async {
    // Note: This method is deprecated. Use verifyPhone() with VerifyPhoneParameters instead.
    return const ApiResult.exception(
      UnknownNetworkException(message: 'verifyEmail is deprecated. Use verifyPhone instead.'),
    );
  }

  /// Verify user phone number with parameter class.
  AuthEither<AuthResult> verifyPhone(VerifyPhoneParameters parameters) async {
    final result = await executeRemoteRequest<AuthResult>(
      request: () => _remoteDataSource.verifyPhone(parameters),
    );

    if (result.isSuccess && result.data != null) {
      await _saveAuthData(result.data!.user.toModel(), result.data!.tokens);
    }

    return result;
  }

  // ==================== Session Management ====================

  @override
  AuthEither<User?> getCurrentUser() async {
    // First check local cache
    if (_currentUser != null) {
      return ApiResult.success(_currentUser);
    }

    // Check local storage
    final cachedUserResult = await _localDataSource.getUser();
    if (cachedUserResult.isSuccess && cachedUserResult.data != null) {
      _currentUser = cachedUserResult.data!.toEntity();
      return ApiResult.success(_currentUser);
    }

    // Try to fetch from remote if we have tokens
    final tokensResult = await _localDataSource.getTokens();
    if (tokensResult.isError || tokensResult.data == null || tokensResult.data!.isFullyExpired) {
      return const ApiResult.success(null);
    }

    final result = await executeRemoteRequest<UserModel>(request: _remoteDataSource.getCurrentUser);

    if (result.isSuccess && result.data != null) {
      await _localDataSource.saveUser(result.data!);
      _currentUser = result.data!.toEntity();
      _authStateController.add(_currentUser);
      return ApiResult.success(_currentUser);
    }

    return result.error != null
        ? ApiResult.exception(result.error!)
        : const ApiResult.success(null);
  }

  @override
  AuthEither<AuthTokens> refreshTokens() async {
    final currentTokensResult = await _localDataSource.getTokens();
    if (currentTokensResult.isError || currentTokensResult.data == null) {
      return const ApiResult.exception(UnauthorizedException(message: 'No tokens available'));
    }

    final currentTokens = currentTokensResult.data!;
    if (currentTokens.refreshToken.isEmpty) {
      return const ApiResult.exception(
        UnauthorizedException(message: 'No refresh token available'),
      );
    }

    final refreshParams = RefreshTokenParameters(refreshToken: currentTokens.refreshToken);

    final result = await executeRemoteRequest<AuthTokens>(
      request: () => _remoteDataSource.refreshToken(refreshParams),
    );

    if (result.isSuccess && result.data != null) {
      await _localDataSource.saveTokens(result.data!);
      _tokenRefreshController.add(result.data!);
    }

    return result;
  }

  @override
  AuthEither<void> signOut(LogoutParameters parameters) async {
    try {
      final tokensResult = await _localDataSource.getTokens();
      if (tokensResult.isSuccess && tokensResult.data != null && await isConnected) {
        await _remoteDataSource.logout(parameters);
      }
    } catch (_) {
      // Ignore errors during sign out
    }

    await _clearAuthData();
    return const ApiResult.success(null);
  }

  @override
  AuthEither<void> signOutAllDevices() async {
    final result = await executeRemoteRequest<void>(request: _remoteDataSource.signOutAllDevices);

    if (result.isSuccess) {
      await _clearAuthData();
    }

    return result;
  }

  // ==================== Biometric Authentication ====================

  @override
  Future<bool> isBiometricAvailable() async {
    try {
      final canAuthenticate = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return canAuthenticate && isDeviceSupported;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> isBiometricEnabled() async {
    final result = await _localDataSource.hasBiometricCredentials();
    return result.isSuccess && (result.data ?? false);
  }

  @override
  AuthEither<void> enableBiometric(SaveBiometricCredentialsParameters parameters) async {
    // Get current credentials from a recent login
    // This should be called after a successful email/password login
    final user = _currentUser;
    if (user == null) {
      return const ApiResult.exception(UnauthorizedException(message: 'Please sign in first'));
    }

    // Save credentials for biometric authentication
    await _localDataSource.saveBiometricCredentials(
      email: parameters.email,
      password: parameters.password,
    );
    return const ApiResult.success(null);
  }

  @override
  AuthEither<void> disableBiometric() async {
    final result = await _localDataSource.deleteBiometricCredentials();
    if (result.isError) {
      return ApiResult.exception(result.error!);
    }
    return result;
  }

  @override
  AuthEither<AuthResult> signInWithBiometric() async {
    // Check if biometric is available
    final isAvailable = await isBiometricAvailable();
    if (!isAvailable) {
      return const ApiResult.exception(
        UnknownNetworkException(message: 'Biometric authentication is not available'),
      );
    }

    // Get saved credentials
    final credentialsResult = await _localDataSource.getBiometricCredentials();
    if (credentialsResult.isError || credentialsResult.data == null) {
      return const ApiResult.exception(
        UnauthorizedException(message: 'Biometric credentials not set up'),
      );
    }

    final credentials = credentialsResult.data!;

    // Authenticate with biometrics
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Sign in with biometrics',
        options: const AuthenticationOptions(stickyAuth: true, biometricOnly: true),
      );

      if (!authenticated) {
        return const ApiResult.exception(RequestCancelledException());
      }

      // Sign in with saved credentials
      final params = SignInWithEmailParameters(
        email: credentials.email,
        password: credentials.password,
      );
      return signInWithEmail(params);
    } catch (e) {
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e));
    }
  }

  // ==================== Private Helpers ====================

  Future<void> _saveAuthData(UserModel userModel, AuthTokens tokens) async {
    await _localDataSource.saveTokens(tokens);
    await _localDataSource.saveUser(userModel);
    _currentUser = userModel.toEntity();
    _authStateController.add(_currentUser);
  }

  Future<void> _clearAuthData() async {
    await _localDataSource.clearAll();
    _currentUser = null;
    _authStateController.add(null);
  }

  /// Disposes the repository and closes streams.
  void dispose() {
    _authStateController.close();
    _tokenRefreshController.close();
  }
}
