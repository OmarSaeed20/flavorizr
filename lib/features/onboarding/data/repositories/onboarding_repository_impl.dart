// lib/features/onboarding/data/repositories/onboarding_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:flavorizr/core/error/failures.dart';
import 'package:flavorizr/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:flavorizr/features/onboarding/domain/entities/onboarding_page.dart';
import 'package:flavorizr/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Implementation of [OnboardingRepository].
class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl({required OnboardingLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final OnboardingLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<OnboardingPage>>> getOnboardingPages() async {
    try {
      final pages = _localDataSource.getOnboardingPages();
      return Right(pages);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get onboarding pages: $e'));
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
  Future<Either<Failure, void>> completeOnboarding() async {
    try {
      await _localDataSource.completeOnboarding();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to complete onboarding: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetOnboarding() async {
    try {
      await _localDataSource.resetOnboarding();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to reset onboarding: $e'));
    }
  }
}
