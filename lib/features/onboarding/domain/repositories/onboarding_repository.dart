// lib/features/onboarding/domain/repositories/onboarding_repository.dart
import 'package:dartz/dartz.dart';
import 'package:flavorizr/core/error/failures.dart';
import 'package:flavorizr/features/onboarding/domain/entities/onboarding_page.dart';

/// Repository interface for onboarding operations.
abstract class OnboardingRepository {
  /// Gets the list of onboarding pages.
  Future<Either<Failure, List<OnboardingPage>>> getOnboardingPages();

  /// Checks if onboarding has been completed.
  Future<Either<Failure, bool>> isOnboardingCompleted();

  /// Marks onboarding as completed.
  Future<Either<Failure, void>> completeOnboarding();

  /// Resets onboarding status (for testing/debugging).
  Future<Either<Failure, void>> resetOnboarding();
}
