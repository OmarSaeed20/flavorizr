// lib/features/company/company_auth/presentation/providers/company_auth_providers.dart
import 'package:fast_golden_taxi/core/di/providers.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/datasources/company_auth_local_datasource.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/datasources/company_auth_remote_datasource.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/repositories/company_auth_repository_impl.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/repositories/company_auth_repository.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/usecases/company_forget_password_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/usecases/company_login_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/usecases/company_logout_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/usecases/company_register_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/usecases/company_reset_password_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/usecases/company_send_verification_code_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/usecases/company_verify_phone_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_auth/presentation/controllers/company_auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ==================== Data Layer Providers ====================

/// Company Auth Remote Data Source Provider
final companyAuthRemoteDataSourceProvider = Provider<CompanyAuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CompanyAuthRemoteDataSource(dio: apiClient.dio);
});

/// Company Auth Local Data Source Provider
final companyAuthLocalDataSourceProvider = Provider<CompanyAuthLocalDataSource>((ref) {
  const secureStorage = FlutterSecureStorage();
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return CompanyAuthLocalDataSource(
    secureStorage: secureStorage,
    sharedPreferences: sharedPreferences,
  );
});

/// Company Auth Repository Provider
final companyAuthRepositoryProvider = Provider<CompanyAuthRepository>((ref) {
  final remoteDataSource = ref.watch(companyAuthRemoteDataSourceProvider);
  final localDataSource = ref.watch(companyAuthLocalDataSourceProvider);
  return CompanyAuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

// ==================== Domain Layer Providers ====================

/// Company Login Use Case Provider
final companyLoginUseCaseProvider = Provider<CompanyLoginUseCase>((ref) {
  final repository = ref.watch(companyAuthRepositoryProvider);
  return CompanyLoginUseCase(repository);
});

/// Company Register Use Case Provider
final companyRegisterUseCaseProvider = Provider<CompanyRegisterUseCase>((ref) {
  final repository = ref.watch(companyAuthRepositoryProvider);
  return CompanyRegisterUseCase(repository);
});

/// Company Logout Use Case Provider
final companyLogoutUseCaseProvider = Provider<CompanyLogoutUseCase>((ref) {
  final repository = ref.watch(companyAuthRepositoryProvider);
  return CompanyLogoutUseCase(repository);
});

/// Company Send Verification Code Use Case Provider
final companySendVerificationCodeUseCaseProvider = Provider<CompanySendVerificationCodeUseCase>((
  ref,
) {
  final repository = ref.watch(companyAuthRepositoryProvider);
  return CompanySendVerificationCodeUseCase(repository);
});

/// Company Verify Phone Use Case Provider
final companyVerifyPhoneUseCaseProvider = Provider<CompanyVerifyPhoneUseCase>((ref) {
  final repository = ref.watch(companyAuthRepositoryProvider);
  return CompanyVerifyPhoneUseCase(repository);
});

/// Company Forget Password Use Case Provider
final companyForgetPasswordUseCaseProvider = Provider<CompanyForgetPasswordUseCase>((ref) {
  final repository = ref.watch(companyAuthRepositoryProvider);
  return CompanyForgetPasswordUseCase(repository);
});

/// Company Reset Password Use Case Provider
final companyResetPasswordUseCaseProvider = Provider<CompanyResetPasswordUseCase>((ref) {
  final repository = ref.watch(companyAuthRepositoryProvider);
  return CompanyResetPasswordUseCase(repository);
});

// ==================== Presentation Layer Providers ====================

/// Company Auth Controller Provider
final companyAuthControllerProvider =
    StateNotifierProvider<CompanyAuthController, CompanyAuthState>((ref) {
      return CompanyAuthController(
        loginUseCase: ref.watch(companyLoginUseCaseProvider),
        registerUseCase: ref.watch(companyRegisterUseCaseProvider),
        logoutUseCase: ref.watch(companyLogoutUseCaseProvider),
        sendVerificationCodeUseCase: ref.watch(companySendVerificationCodeUseCaseProvider),
        verifyPhoneUseCase: ref.watch(companyVerifyPhoneUseCaseProvider),
        forgetPasswordUseCase: ref.watch(companyForgetPasswordUseCaseProvider),
        resetPasswordUseCase: ref.watch(companyResetPasswordUseCaseProvider),
      );
    });

/// Company Auth State Provider (convenience)
final companyAuthStateProvider = companyAuthControllerProvider;

/// Company Is Logged In Provider
final companyIsLoggedInProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(companyAuthRepositoryProvider);
  return repository.isLoggedIn();
});

/// Company User Provider
final companyUserProvider = FutureProvider((ref) async {
  final repository = ref.watch(companyAuthRepositoryProvider);
  return repository.getUser();
});

/// Company Tokens Provider
final companyTokensProvider = FutureProvider((ref) async {
  final repository = ref.watch(companyAuthRepositoryProvider);
  return repository.getTokens();
});
