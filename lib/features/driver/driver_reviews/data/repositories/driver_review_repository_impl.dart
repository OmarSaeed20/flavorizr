import 'package:flavorizr/core/network/base/repo/base_repository.dart';
import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_reviews/data/datasources/driver_review_remote_datasource.dart';
import 'package:flavorizr/features/driver/driver_reviews/data/parameters/get_driver_reviews_params.dart';
import 'package:flavorizr/features/driver/driver_reviews/data/parameters/respond_to_review_params.dart';
import 'package:flavorizr/features/driver/driver_reviews/domain/entities/driver_review.dart';
import 'package:flavorizr/features/driver/driver_reviews/domain/entities/review_stats.dart';
import 'package:flavorizr/features/driver/driver_reviews/domain/repositories/driver_review_repository.dart';

/// Implementation of driver review repository
class DriverReviewRepositoryImpl extends BaseRepository implements DriverReviewRepository {
  final DriverReviewRemoteDataSource remoteDataSource;

  DriverReviewRepositoryImpl({required this.remoteDataSource, required NetworkInfo networkInfo})
    : _networkInfo = networkInfo;
  final NetworkInfo _networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  @override
  Future<ApiResult<List<DriverReview>>> getDriverReviews({
    required String driverId,
    required int page,
    required int limit,
    int? minRating,
    int? maxRating,
    bool? withResponse,
    bool? pendingResponse,
  }) async {
    final params = GetDriverReviewsParams(
      driverId: driverId,
      page: page,
      limit: limit,
      minRating: minRating,
      maxRating: maxRating,
      withResponse: withResponse,
      pendingResponse: pendingResponse,
    );

    final result = await executeRemoteRequest(
      request: () => remoteDataSource.getDriverReviews(params.toQueryParameters()),
    );

    return result.when(
      success: (reviews, _) {
        return ApiResult.success(reviews.map((model) => model.toEntity()).toList());
      },
      exception: (message) {
        return ApiResult.exception(message);
      },
    );
  }

  @override
  Future<ApiResult<DriverReview>> getDriverReviewById({required String reviewId}) async {
    final result = await executeRemoteRequest(
      request: () => remoteDataSource.getDriverReviewById(reviewId),
    );

    return result.when(
      success: (review, _) {
        return ApiResult.success(review.toEntity());
      },
      exception: (message) {
        return ApiResult.exception(message);
      },
    );
  }

  @override
  Future<ApiResult<ReviewStats>> getDriverReviewStats({required String driverId}) async {
    final result = await executeRemoteRequest(
      request: () => remoteDataSource.getDriverReviewStats(driverId),
    );

    return result.when(
      success: (stats, _) {
        return ApiResult.success(stats.toEntity());
      },
      exception: (message) {
        return ApiResult.exception(message);
      },
    );
  }

  @override
  Future<ApiResult<DriverReview>> respondToReview({
    required String reviewId,
    required String response,
  }) async {
    final params = RespondToReviewParams(reviewId: reviewId, response: response);

    final result = await executeRemoteRequest(
      request: () => remoteDataSource.respondToReview(params.toJson()),
    );

    return result.when(
      success: (review, _) {
        return ApiResult.success(review.toEntity());
      },
      exception: (message) {
        return ApiResult.exception(message);
      },
    );
  }
}
