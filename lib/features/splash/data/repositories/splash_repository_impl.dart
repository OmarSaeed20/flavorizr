// lib/features/splash/data/repositories/splash_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:flavorizr/core/error/failures.dart';
import 'package:flavorizr/features/splash/data/datasources/splash_local_datasource.dart';
import 'package:flavorizr/features/splash/domain/repositories/splash_repository.dart';

/// Implementation of [SplashRepository].
class SplashRepositoryImpl implements SplashRepository {
  const SplashRepositoryImpl({required SplashLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final SplashLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final hasToken = await _localDataSource.hasValidToken();
      return Right(hasToken);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to check authentication status: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isOnboardingCompleted() async {
    try {
      final completed = await _localDataSource.isOnboardingCompleted();
      return Right(completed);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to check onboarding status: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isFirstLaunch() async {
    try {
      final isFirst = await _localDataSource.isFirstLaunch();
      return Right(isFirst);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to check first launch status: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markFirstLaunchCompleted() async {
    try {
      await _localDataSource.markFirstLaunchCompleted();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to mark first launch completed: $e'));
    }
  }

  @override
  Future<Either<Failure, String?>> getCachedToken() async {
    try {
      final token = await _localDataSource.getCachedToken();
      return Right(token);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get cached token: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> initializeApp() async {
    try {
      // Add any app initialization logic here
      // For example: checking app version, migrations, etc.
      await Future<void>.delayed(const Duration(milliseconds: 500));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to initialize app: $e'));
    }
  }
}
