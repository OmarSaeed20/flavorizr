import 'package:fast_golden_taxi/core/network/base/repo/base_repository.dart';
import 'package:fast_golden_taxi/core/network/network_info.dart';
import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_reviews/data/datasources/driver_review_local_datasource.dart';
import 'package:fast_golden_taxi/features/driver/driver_reviews/data/datasources/driver_review_remote_datasource.dart';
import 'package:fast_golden_taxi/features/driver/driver_reviews/data/models/driver_review_model.dart';
import 'package:fast_golden_taxi/features/driver/driver_reviews/data/parameters/get_driver_reviews_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_reviews/domain/entities/driver_review.dart';
import 'package:fast_golden_taxi/features/driver/driver_reviews/domain/repositories/driver_review_repository.dart';

/// Implementation of DriverReviewRepository.
///
/// Provides offline capability with caching.
class DriverReviewRepositoryImpl extends BaseRepository implements DriverReviewRepository {
  final DriverReviewRemoteDataSource _remoteDataSource;
  final DriverReviewLocalDataSource _localDataSource;

  DriverReviewRepositoryImpl({
    required DriverReviewRemoteDataSource remoteDataSource,
    required DriverReviewLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  final NetworkInfo _networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  @override
  Future<ApiResult<List<DriverReview>>> getReviews({
    required String driverId,
    int? tripId,
    int? rating,
    int page = 1,
    int limit = 20,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  }) async {
    final builder = GetDriverReviewsParameters.builder()
        .withDriverId(driverId)
        .withPage(page)
        .withLimit(limit)
        .withSortBy(sortBy)
        .withSortOrder(sortOrder);
    if (tripId != null) builder.withTripId(tripId.toString());
    if (rating != null) builder.withRating(rating);
    final parameters = builder.build();

    final result = await fetchWithCache<List<DriverReviewModel>>(
      cacheKey: 'driver_reviews_$driverId',
      remoteFetcher: () => _remoteDataSource.getReviews(parameters),
      localFetcher: _localDataSource.getCachedReviews,
      cacheSaver: (data) async {
        await _localDataSource.cacheReviews(data);
      },
    );

    return result.when(
      success: (data, _) => ApiResult.success(data.map((e) => e.toEntity()).toList()),
      exception: ApiResult.exception,
    );
  }
}
