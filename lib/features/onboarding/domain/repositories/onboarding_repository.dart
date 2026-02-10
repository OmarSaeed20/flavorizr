// lib/features/onboarding/domain/repositories/onboarding_repository.dart
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/onboarding/domain/entities/onboarding_page.dart';

/// Repository interface for onboarding operations.
abstract class OnboardingRepository {
  /// Gets the list of onboarding pages.
  Future<ApiResult<List<OnboardingPage>>> getOnboardingPages();

  /// Checks if onboarding has been completed.
  Future<ApiResult<bool>> isOnboardingCompleted();

  /// Marks onboarding as completed.
  Future<ApiResult<void>> completeOnboarding();

  /// Resets onboarding status (for testing/debugging).
  Future<ApiResult<void>> resetOnboarding();
}
