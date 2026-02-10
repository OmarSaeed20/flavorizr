// lib/features/splash/data/repositories/splash_repository_impl.dart
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/splash/data/datasources/splash_local_datasource.dart';
import 'package:fast_golden_taxi/features/splash/domain/repositories/splash_repository.dart';

/// Implementation of [SplashRepository].
class SplashRepositoryImpl implements SplashRepository {
  const SplashRepositoryImpl({required SplashLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final SplashLocalDataSource _localDataSource;

  @override
  Future<ApiResult<bool>> isAuthenticated() async {
    try {
      final hasToken = await _localDataSource.hasValidToken();
      return ApiResult.success(hasToken);
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to check authentication status: $e'),
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
        UnknownNetworkException(message: 'Failed to check onboarding status: $e'),
      );
    }
  }

  @override
  Future<ApiResult<bool>> isLanguageSelected() async {
    try {
      final selected = await _localDataSource.isLanguageSelected();
      return ApiResult.success(selected);
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to check language selection status: $e'),
      );
    }
  }

  @override
  Future<ApiResult<bool>> isFirstLaunch() async {
    try {
      final isFirst = await _localDataSource.isFirstLaunch();
      return ApiResult.success(isFirst);
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to check first launch status: $e'),
      );
    }
  }

  @override
  Future<ApiResult<void>> markFirstLaunchCompleted() async {
    try {
      await _localDataSource.markFirstLaunchCompleted();
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to mark first launch completed: $e'),
      );
    }
  }

  @override
  Future<ApiResult<String?>> getCachedToken() async {
    try {
      final token = await _localDataSource.getCachedToken();
      return ApiResult.success(token);
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to get cached token: $e'),
      );
    }
  }

  @override
  Future<ApiResult<void>> initializeApp() async {
    try {
      // Add any app initialization logic here
      // For example: checking app version, migrations, etc.
      await Future<void>.delayed(const Duration(milliseconds: 500));
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.exception(UnknownNetworkException(message: 'Failed to initialize app: $e'));
    }
  }
}
