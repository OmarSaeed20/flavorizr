// lib/features/splash/domain/repositories/splash_repository.dart
import 'package:dartz/dartz.dart';
import 'package:flavorizr/core/error/failures.dart';

/// Repository interface for splash screen operations.
///
/// Handles app initialization checks and navigation decisions.
abstract class SplashRepository {
  /// Checks if the user is authenticated.
  Future<Either<Failure, bool>> isAuthenticated();

  /// Checks if onboarding has been completed.
  Future<Either<Failure, bool>> isOnboardingCompleted();

  /// Checks if the app is being launched for the first time.
  Future<Either<Failure, bool>> isFirstLaunch();

  /// Marks the first launch as completed.
  Future<Either<Failure, void>> markFirstLaunchCompleted();

  /// Gets the cached user token if available.
  Future<Either<Failure, String?>> getCachedToken();

  /// Performs any necessary app initialization.
  Future<Either<Failure, void>> initializeApp();
}
