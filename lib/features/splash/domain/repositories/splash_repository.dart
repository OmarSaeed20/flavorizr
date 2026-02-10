// lib/features/splash/domain/repositories/splash_repository.dart
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';

/// Repository interface for splash screen operations.
///
/// Handles app initialization checks and navigation decisions.
abstract class SplashRepository {
  /// Checks if the user is authenticated.
  Future<ApiResult<bool>> isAuthenticated();

  /// Checks if onboarding has been completed.
  Future<ApiResult<bool>> isOnboardingCompleted();

  /// Checks if the user has selected a language.
  Future<ApiResult<bool>> isLanguageSelected();

  /// Checks if the app is being launched for the first time.
  Future<ApiResult<bool>> isFirstLaunch();

  /// Marks the first launch as completed.
  Future<ApiResult<void>> markFirstLaunchCompleted();

  /// Gets the cached user token if available.
  Future<ApiResult<String?>> getCachedToken();

  /// Performs any necessary app initialization.
  Future<ApiResult<void>> initializeApp();
}
