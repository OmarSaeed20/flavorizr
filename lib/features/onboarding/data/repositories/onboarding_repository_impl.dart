// lib/features/onboarding/data/repositories/onboarding_repository_impl.dart
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:fast_golden_taxi/features/onboarding/domain/entities/onboarding_page.dart';
import 'package:fast_golden_taxi/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Implementation of [OnboardingRepository].
class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl({
    required OnboardingLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  final OnboardingLocalDataSource _localDataSource;

  @override
  Future<ApiResult<List<OnboardingPage>>> getOnboardingPages() async {
    try {
      final pages = _localDataSource.getOnboardingPages();
      return ApiResult.success(pages);
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to get onboarding pages: $e'),
      );
    }
  }

  @override
  Future<ApiResult<bool>> isOnboardingCompleted() async {
    try {
      final completed = await _localDataSource.isOnboardingCompleted();
      return ApiResult.success(completed);
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(
          message: 'Failed to check onboarding status: $e',
        ),
      );
    }
  }

  @override
  Future<ApiResult<void>> completeOnboarding() async {
    try {
      await _localDataSource.completeOnboarding();
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to complete onboarding: $e'),
      );
    }
  }

  @override
  Future<ApiResult<void>> resetOnboarding() async {
    try {
      await _localDataSource.resetOnboarding();
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to reset onboarding: $e'),
      );
    }
  }
}
