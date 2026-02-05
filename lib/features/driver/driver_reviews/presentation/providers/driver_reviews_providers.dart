import 'package:flavorizr/core/di/providers.dart';
import 'package:flavorizr/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:flavorizr/features/driver/driver_reviews/data/datasources/driver_review_local_datasource.dart';
import 'package:flavorizr/features/driver/driver_reviews/data/datasources/driver_review_remote_datasource.dart';
import 'package:flavorizr/features/driver/driver_reviews/data/repositories/driver_review_repository_impl.dart';
import 'package:flavorizr/features/driver/driver_reviews/domain/repositories/driver_review_repository.dart';
import 'package:flavorizr/features/driver/driver_reviews/domain/usecases/get_driver_reviews.dart';
import 'package:flavorizr/features/driver/driver_reviews/presentation/controllers/driver_reviews_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for driver review remote data source
final driverReviewRemoteDataSourceProvider = Provider<DriverReviewRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DriverReviewRemoteDataSourceImpl(apiClient);
});

/// Provider for driver review local data source
final driverReviewLocalDataSourceProvider = Provider<DriverReviewLocalDataSource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return DriverReviewLocalDataSourceImpl(sharedPreferences);
});

/// Provider for driver review repository
final driverReviewRepositoryProvider = Provider<DriverReviewRepository>((ref) {
  final remoteDataSource = ref.watch(driverReviewRemoteDataSourceProvider);
  final localDataSource = ref.watch(driverReviewLocalDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return DriverReviewRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );
});

/// Provider for get driver reviews use case
final getDriverReviewsProvider = Provider<GetDriverReviews>((ref) {
  final repository = ref.watch(driverReviewRepositoryProvider);
  return GetDriverReviews(repository);
});

/// Provider for driver reviews controller
final driverReviewsControllerProvider =
    StateNotifierProvider<DriverReviewsController, DriverReviewsState>((ref) {
      return DriverReviewsController(getDriverReviews: ref.watch(getDriverReviewsProvider));
    });
