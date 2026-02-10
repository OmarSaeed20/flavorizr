// lib/features/auth/presentation/providers/auth_providers.dart
import 'package:fast_golden_taxi/core/di/providers.dart';
import 'package:fast_golden_taxi/core/network/network_info.dart';
import 'package:fast_golden_taxi/features/user/auth/data/datasources/auth_local_datasource.dart';
import 'package:fast_golden_taxi/features/user/auth/data/datasources/auth_remote_datasource.dart';
import 'package:fast_golden_taxi/features/user/auth/data/repositories/auth_repository_impl.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/user.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/repositories/auth_repository.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/usecases/biometric_auth_usecase.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/usecases/login_usecase.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/usecases/logout_usecase.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/usecases/password_reset_usecase.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/usecases/register_usecase.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/usecases/social_auth_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// ==================== External Dependencies ====================

/// Provider for FlutterSecureStorage.
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
  );
});

/// Provider for LocalAuthentication.
final localAuthProvider = Provider<LocalAuthentication>((ref) {
  return LocalAuthentication();
});

/// Provider for GoogleSignIn.
final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(scopes: ['email', 'profile']);
});

// ==================== Data Sources ====================

/// Provider for AuthRemoteDataSource.
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSourceImpl(apiClient);
});

/// Provider for AuthLocalDataSource.
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final prefs = ref.watch(sharedPreferencesProvider).value;
  return AuthLocalDataSourceImpl(secureStorage: secureStorage, prefs: prefs!);
});

// ==================== Repository ====================

/// Provider for AuthRepository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  final localAuth = ref.watch(localAuthProvider);
  final googleSignIn = ref.watch(googleSignInProvider);

  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
    localAuth: localAuth,
    googleSignIn: () async {
      try {
        final account = await googleSignIn.signIn();
        if (account == null) return null;
        final auth = await account.authentication;
        return auth.idToken;
      } catch (_) {
        return null;
      }
    },
    appleSignIn: () async {
      try {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        );
        return (
          idToken: credential.identityToken ?? '',
          authorizationCode: credential.authorizationCode,
        );
      } catch (_) {
        return null;
      }
    },
  );
});

// ==================== Use Cases ====================

/// Provider for LoginUseCase.
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

/// Provider for RegisterUseCase.
final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});

/// Provider for LogoutUseCase.
final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

/// Provider for GoogleSignInUseCase.
final googleSignInUseCaseProvider = Provider<GoogleSignInUseCase>((ref) {
  return GoogleSignInUseCase(ref.watch(authRepositoryProvider));
});

/// Provider for AppleSignInUseCase.
final appleSignInUseCaseProvider = Provider<AppleSignInUseCase>((ref) {
  return AppleSignInUseCase(ref.watch(authRepositoryProvider));
});

/// Provider for ForgotPasswordUseCase.
final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  return ForgotPasswordUseCase(ref.watch(authRepositoryProvider));
});

/// Provider for ResetPasswordUseCase.
final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  return ResetPasswordUseCase(ref.watch(authRepositoryProvider));
});

/// Provider for ChangePasswordUseCase.
final changePasswordUseCaseProvider = Provider<ChangePasswordUseCase>((ref) {
  return ChangePasswordUseCase(ref.watch(authRepositoryProvider));
});

/// Provider for GetCurrentUserUseCase.
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
});

/// Provider for CheckBiometricAvailabilityUseCase.
final checkBiometricAvailabilityUseCaseProvider = Provider<CheckBiometricAvailabilityUseCase>((
  ref,
) {
  return CheckBiometricAvailabilityUseCase(ref.watch(authRepositoryProvider));
});

/// Provider for BiometricSignInUseCase.
final biometricSignInUseCaseProvider = Provider<BiometricSignInUseCase>((ref) {
  return BiometricSignInUseCase(ref.watch(authRepositoryProvider));
});

// ==================== Auth State ====================

/// Provider for the current authentication state.
///
/// Returns the current [User] if authenticated, null otherwise.
final authStateProvider = StreamProvider<User?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

/// Provider for checking if user is authenticated.
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.whenOrNull(data: (user) => user != null) ?? false;
});

/// Provider for the current user.
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.whenOrNull(data: (user) => user);
});

/// Provider for biometric availability.
final biometricAvailableProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  return repository.isBiometricAvailable();
});

/// Provider for biometric enabled status.
final biometricEnabledProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  return repository.isBiometricEnabled();
});

// ==================== Controllers ====================

// Note: Controller providers are defined in their respective controller files
// to keep the code organized. See:
// - login_controller.dart -> loginControllerProvider
// - register_controller.dart -> registerControllerProvider
// - forgot_password_controller.dart -> forgotPasswordControllerProvider
