// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'dart:async';

import 'package:flavorizr/core/error/failures.dart';
import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flavorizr/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flavorizr/features/auth/domain/entities/auth_result.dart';
import 'package:flavorizr/features/auth/domain/entities/auth_tokens.dart';
import 'package:flavorizr/features/auth/domain/entities/user.dart';
import 'package:flavorizr/features/auth/domain/repositories/auth_repository.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';
import 'package:local_auth/local_auth.dart';

/// Callback type for Google Sign-In.
typedef GoogleSignInCallback = Future<String?> Function();

/// Callback type for Apple Sign-In.
typedef AppleSignInCallback = Future<({String idToken, String authorizationCode})?> Function();

/// Implementation of [AuthRepository].
///
/// Coordinates between remote and local data sources,
/// handles network connectivity, and manages auth state.
class AuthRepositoryImpl implements AuthRepository {
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
    final user = await _localDataSource.getUser();
    if (user != null) {
      _currentUser = user.toEntity();
      _authStateController.add(_currentUser);
    }
  }

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  Stream<AuthTokens> get tokenRefreshes => _tokenRefreshController.stream;

  // ==================== Authentication ====================

  @override
  AuthEither<AuthResult> signInWithEmail({required String email, required String password}) async {
    if (!await _networkInfo.isConnected) {
      return Result.failure(const NetworkFailure());
    }

    try {
      final result = await _remoteDataSource.signInWithEmail(email: email, password: password);

      await _saveAuthData(result.user, result.tokens);

      final authResult = AuthResult(user: result.user.toEntity(), tokens: result.tokens);

      return Result.success(authResult);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  @override
  AuthEither<AuthResult> signInWithGoogle() async {
    if (googleSignIn == null) {
      return Result.failure(const UnsupportedFailure(message: 'Google Sign-In is not configured'));
    }

    if (!await _networkInfo.isConnected) {
      return Result.failure(const NetworkFailure());
    }

    try {
      final idToken = await googleSignIn!();
      if (idToken == null) {
        return Result.failure(const CancelledFailure(message: 'Google sign-in was cancelled'));
      }

      final result = await _remoteDataSource.signInWithGoogle(idToken: idToken);

      await _saveAuthData(result.user, result.tokens);

      final authResult = AuthResult(user: result.user.toEntity(), tokens: result.tokens);

      return Result.success(authResult);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  @override
  AuthEither<AuthResult> signInWithApple() async {
    if (appleSignIn == null) {
      return Result.failure(const UnsupportedFailure(message: 'Apple Sign-In is not configured'));
    }

    if (!await _networkInfo.isConnected) {
      return Result.failure(const NetworkFailure());
    }

    try {
      final credentials = await appleSignIn!();
      if (credentials == null) {
        return Result.failure(const CancelledFailure(message: 'Apple sign-in was cancelled'));
      }

      final result = await _remoteDataSource.signInWithApple(
        idToken: credentials.idToken,
        authorizationCode: credentials.authorizationCode,
      );

      await _saveAuthData(result.user, result.tokens);

      final authResult = AuthResult(user: result.user.toEntity(), tokens: result.tokens);

      return Result.success(authResult);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  @override
  AuthEither<AuthResult> signInWithOtp({
    required String verificationId,
    required String otpCode,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Result.failure(const NetworkFailure());
    }

    try {
      final result = await _remoteDataSource.verifyOtp(
        verificationId: verificationId,
        otpCode: otpCode,
      );

      await _saveAuthData(result.user, result.tokens);

      final authResult = AuthResult(user: result.user.toEntity(), tokens: result.tokens);

      return Result.success(authResult);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  @override
  AuthEither<AuthResult> signInWithMagicLink({required String token}) async {
    if (!await _networkInfo.isConnected) {
      return Result.failure(const NetworkFailure());
    }

    try {
      final result = await _remoteDataSource.verifyMagicLink(token: token);

      await _saveAuthData(result.user, result.tokens);

      final authResult = AuthResult(user: result.user.toEntity(), tokens: result.tokens);

      return Result.success(authResult);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  // ==================== Registration ====================

  @override
  AuthEither<AuthResult> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Result.failure(const NetworkFailure());
    }

    try {
      final result = await _remoteDataSource.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );

      await _saveAuthData(result.user, result.tokens);

      final authResult = AuthResult(
        user: result.user.toEntity(),
        tokens: result.tokens,
        isNewUser: true,
      );

      return Result.success(authResult);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  // ==================== Password Recovery ====================

  @override
  AuthEither<void> sendPasswordResetEmail({required String email}) async {
    if (!await _networkInfo.isConnected) {
      return Result.failure(const NetworkFailure());
    }

    try {
      await _remoteDataSource.sendPasswordResetEmail(email: email);
      return Result.success(null);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  @override
  AuthEither<void> resetPassword({required String token, required String newPassword}) async {
    if (!await _networkInfo.isConnected) {
      return Result.failure(const NetworkFailure());
    }

    try {
      await _remoteDataSource.resetPassword(token: token, newPassword: newPassword);
      return Result.success(null);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  @override
  AuthEither<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Result.failure(const NetworkFailure());
    }

    try {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return Result.success(null);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  // ==================== OTP / Verification ====================

  @override
  AuthEither<String> sendOtp({required String phoneNumber}) async {
    if (!await _networkInfo.isConnected) {
      return Result.failure(const NetworkFailure());
    }

    try {
      final verificationId = await _remoteDataSource.sendOtp(phoneNumber: phoneNumber);
      return Result.success(verificationId);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  @override
  AuthEither<void> sendMagicLink({required String email}) async {
    if (!await _networkInfo.isConnected) {
      return Result.failure(const NetworkFailure());
    }

    try {
      await _remoteDataSource.sendMagicLink(email: email);
      return Result.success(null);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  @override
  AuthEither<void> resendEmailVerification() async {
    if (!await _networkInfo.isConnected) {
      return Result.failure(const NetworkFailure());
    }

    try {
      await _remoteDataSource.resendEmailVerification();
      return Result.success(null);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  @override
  AuthEither<void> verifyEmail({required String token}) async {
    if (!await _networkInfo.isConnected) {
      return Result.failure(const NetworkFailure());
    }

    try {
      await _remoteDataSource.verifyEmail(token: token);
      return Result.success(null);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  // ==================== Session Management ====================

  @override
  AuthEither<User?> getCurrentUser() async {
    // First check local cache
    if (_currentUser != null) {
      return (data: _currentUser, failure: null);
    }

    // Check local storage
    final cachedUser = await _localDataSource.getUser();
    if (cachedUser != null) {
      _currentUser = cachedUser.toEntity();
      return (data: _currentUser, failure: null);
    }

    // Try to fetch from remote if we have tokens
    final tokens = await _localDataSource.getTokens();
    if (tokens == null || tokens.isFullyExpired) {
      return (data: null, failure: null);
    }

    if (!await _networkInfo.isConnected) {
      return (data: null, failure: null);
    }

    try {
      final userModel = await _remoteDataSource.getCurrentUser();
      await _localDataSource.saveUser(userModel);
      _currentUser = userModel.toEntity();
      _authStateController.add(_currentUser);
      return (data: _currentUser, failure: null);
    } catch (e) {
      return (data: null, failure: null);
    }
  }

  @override
  AuthEither<AuthTokens> refreshTokens() async {
    final currentTokens = await _localDataSource.getTokens();
    if (currentTokens == null) {
      return Result.failure(const UnauthenticatedFailure(message: 'No tokens available'));
    }

    if (!await _networkInfo.isConnected) {
      return Result.failure(const NetworkFailure());
    }

    try {
      final newTokens = await _remoteDataSource.refreshTokens(
        refreshToken: currentTokens.refreshToken,
      );
      await _localDataSource.saveTokens(newTokens);
      _tokenRefreshController.add(newTokens);
      return Result.success(newTokens);
    } catch (e) {
      // If refresh fails, sign out the user
      await _clearAuthData();
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  @override
  AuthEither<void> signOut() async {
    try {
      final tokens = await _localDataSource.getTokens();
      if (tokens != null && await _networkInfo.isConnected) {
        await _remoteDataSource.signOut(refreshToken: tokens.refreshToken);
      }
    } catch (_) {
      // Ignore errors during sign out
    }

    await _clearAuthData();
    return Result.success(null);
  }

  @override
  AuthEither<void> signOutAllDevices() async {
    if (!await _networkInfo.isConnected) {
      return Result.failure(const NetworkFailure());
    }

    try {
      await _remoteDataSource.signOutAllDevices();
      await _clearAuthData();
      return Result.success(null);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
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
    return _localDataSource.hasBiometricCredentials();
  }

  @override
  AuthEither<void> enableBiometric() async {
    // Get current credentials from a recent login
    // This should be called after a successful email/password login
    final user = _currentUser;
    if (user == null) {
      return Result.failure(const UnauthenticatedFailure(message: 'Please sign in first'));
    }

    // Note: In a real implementation, you would get the email/password
    // from the login form before calling this method
    return Result.failure(
      const UnsupportedFailure(
        message: 'Call saveBiometricCredentials after login to enable biometrics',
      ),
    );
  }

  /// Saves credentials for biometric authentication.
  /// Call this after a successful email/password login.
  Future<void> saveBiometricCredentials({required String email, required String password}) async {
    await _localDataSource.saveBiometricCredentials(email: email, password: password);
  }

  @override
  AuthEither<void> disableBiometric() async {
    try {
      await _localDataSource.deleteBiometricCredentials();
      return Result.success(null);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  @override
  AuthEither<AuthResult> signInWithBiometric() async {
    // Check if biometric is available
    final isAvailable = await isBiometricAvailable();
    if (!isAvailable) {
      return Result.failure(
        const UnsupportedFailure(message: 'Biometric authentication is not available'),
      );
    }

    // Get saved credentials
    final credentials = await _localDataSource.getBiometricCredentials();
    if (credentials == null) {
      return Result.failure(
        const UnauthenticatedFailure(message: 'Biometric credentials not set up'),
      );
    }

    // Authenticate with biometrics
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Sign in with biometrics',
        options: const AuthenticationOptions(stickyAuth: true, biometricOnly: true),
      );

      if (!authenticated) {
        return Result.failure(const CancelledFailure(message: 'Biometric authentication failed'));
      }

      // Sign in with saved credentials
      return signInWithEmail(email: credentials.email, password: credentials.password);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  // ==================== Private Helpers ====================

  Future<void> _saveAuthData(dynamic userModel, AuthTokens tokens) async {
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

  Failure _mapExceptionToFailure(dynamic exception) {
    // Handle DioException
    if (exception.toString().contains('DioException')) {
      final message = exception.toString();
      if (message.contains('401')) {
        return const InvalidCredentialsFailure();
      }
      if (message.contains('409')) {
        return const ConflictFailure(message: 'Email already in use');
      }
      if (message.contains('404')) {
        return const NotFoundFailure();
      }
      if (message.contains('timeout')) {
        return const TimeoutFailure();
      }
      return ServerFailure(message: exception.toString());
    }

    return UnexpectedFailure(message: 'An unexpected error occurred', exception: exception);
  }

  /// Disposes the repository and closes streams.
  void dispose() {
    _authStateController.close();
    _tokenRefreshController.close();
  }
}
