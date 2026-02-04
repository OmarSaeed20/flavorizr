// lib/features/splash/domain/usecases/check_app_initialization_usecase.dart
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/splash/domain/repositories/splash_repository.dart';

/// Result of the app initialization check.
enum InitializationResult {
  /// User needs to complete onboarding.
  onboarding,

  /// User needs to login.
  login,

  /// User is authenticated and can proceed to home.
  home,
}

/// Use case for checking app initialization state.
///
/// Determines where to navigate after splash screen based on:
/// 1. Whether onboarding is completed
/// 2. Whether user is authenticated
class CheckAppInitializationUseCase {
  const CheckAppInitializationUseCase(this._repository);

  final SplashRepository _repository;

  /// Executes the use case.
  ///
  /// Returns [InitializationResult] indicating where to navigate.
  Future<ApiResult<InitializationResult>> call() async {
    // First, initialize the app
    final initResult = await _repository.initializeApp();
    if (initResult.isError) {
      return initResult.when(
        success: (_, __) => const ApiResult.success(InitializationResult.login),
        exception: ApiResult.exception,
      );
    }

    // Check if onboarding is completed
    final onboardingResult = await _repository.isOnboardingCompleted();
    final isOnboardingCompleted = onboardingResult.data ?? false;

    if (!isOnboardingCompleted) {
      return const ApiResult.success(InitializationResult.onboarding);
    }

    // Check if user is authenticated
    final authResult = await _repository.isAuthenticated();
    final isAuthenticated = authResult.data ?? false;

    if (isAuthenticated) {
      return const ApiResult.success(InitializationResult.home);
    }

    return const ApiResult.success(InitializationResult.login);
  }
}
