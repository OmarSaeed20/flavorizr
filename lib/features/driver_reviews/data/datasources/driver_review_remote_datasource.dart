import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_client.dart';
import 'package:flavorizr/core/network/base/datasource/base_data_source.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver_reviews/data/endpoints/driver_reviews_endpoints.dart';
import 'package:flavorizr/features/driver_reviews/data/models/driver_review_model.dart';
import 'package:flavorizr/features/driver_reviews/data/models/review_stats_model.dart';
import 'package:flavorizr/features/driver_reviews/data/parameters/get_driver_reviews_parameters.dart';
import 'package:flavorizr/features/driver_reviews/data/parameters/respond_to_review_parameters.dart';

/// Remote data source for driver reviews.
///
/// Handles all HTTP requests related to driver reviews.
/// Returns ApiResult with success or error data.
abstract class DriverReviewRemoteDataSource {
  /// Gets all reviews for a driver.
  Future<ApiResult<List<DriverReviewModel>>> getDriverReviews(
    GetDriverReviewsParameters parameters,
  );

  /// Gets a specific review by ID.
  Future<ApiResult<DriverReviewModel>> getDriverReviewById(String reviewId);

  /// Gets review statistics for a driver.
  Future<ApiResult<ReviewStatsModel>> getDriverReviewStats(String driverId);

  /// Responds to a review.
  Future<ApiResult<DriverReviewModel>> respondToReview(RespondToReviewParameters parameters);

  /// Reports a review.
  Future<ApiResult<void>> reportReview({required String reviewId, required String reason});

  /// Gets reviews for a specific trip.
  Future<ApiResult<List<DriverReviewModel>>> getTripReviews(String tripId);

  /// Gets recent reviews.
  Future<ApiResult<List<DriverReviewModel>>> getRecentReviews({int limit = 10});

  /// Gets reviews with pagination.
  Future<ApiResult<List<DriverReviewModel>>> getPaginatedReviews({int page = 1, int limit = 20});
}

/// Implementation of [DriverReviewRemoteDataSource] using BaseRemoteDataSource.
class DriverReviewRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements DriverReviewRemoteDataSource {
  const DriverReviewRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  @override
  Future<ApiResult<List<DriverReviewModel>>> getDriverReviews(
    GetDriverReviewsParameters parameters,
  ) async {
    return get<List<DriverReviewModel>>(
      path: DriverReviewsEndpoints.reviews,
      queryParameters: parameters.toJson(),
      decoder: (data) {
        final jsonData = data as Map<String, dynamic>;
        final items = (jsonData['reviews'] as List? ?? jsonData['data'] as List? ?? [])
            .map((e) => DriverReviewModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return items;
      },
    );
  }

  @override
  Future<ApiResult<DriverReviewModel>> getDriverReviewById(String reviewId) async {
    return get<DriverReviewModel>(
      path: DriverReviewsEndpoints.reviewById(reviewId),
      decoder: (data) {
        final jsonData = data as Map<String, dynamic>;
        return DriverReviewModel.fromJson(jsonData['review'] as Map<String, dynamic>);
      },
    );
  }

  @override
  Future<ApiResult<ReviewStatsModel>> getDriverReviewStats(String driverId) async {
    return get<ReviewStatsModel>(
      path: DriverReviewsEndpoints.reviewStats,
      queryParameters: {'driverId': driverId},
      decoder: (data) {
        final jsonData = data as Map<String, dynamic>;
        return ReviewStatsModel.fromJson(jsonData['stats'] as Map<String, dynamic>);
      },
    );
  }

  @override
  Future<ApiResult<DriverReviewModel>> respondToReview(RespondToReviewParameters parameters) async {
    return post<DriverReviewModel>(
      path: DriverReviewsEndpoints.respondToReview,
      data: parameters.toJson(),
      decoder: (data) => DriverReviewModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<void>> reportReview({required String reviewId, required String reason}) async {
    return post<void>(
      path: DriverReviewsEndpoints.reportReview(reviewId),
      data: {'reason': reason},
    );
  }

  @override
  Future<ApiResult<List<DriverReviewModel>>> getTripReviews(String tripId) async {
    return get<List<DriverReviewModel>>(
      path: DriverReviewsEndpoints.tripReviews(tripId),
      decoder: (data) {
        final jsonData = data as Map<String, dynamic>;
        final items = (jsonData['reviews'] as List? ?? jsonData['data'] as List? ?? [])
            .map((e) => DriverReviewModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return items;
      },
    );
  }

  @override
  Future<ApiResult<List<DriverReviewModel>>> getRecentReviews({int limit = 10}) async {
    return get<List<DriverReviewModel>>(
      path: DriverReviewsEndpoints.recentReviews,
      queryParameters: {'limit': limit},
      decoder: (data) {
        final jsonData = data as Map<String, dynamic>;
        final items = (jsonData['reviews'] as List? ?? jsonData['data'] as List? ?? [])
            .map((e) => DriverReviewModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return items;
      },
    );
  }

  @override
  Future<ApiResult<List<DriverReviewModel>>> getPaginatedReviews({
    int page = 1,
    int limit = 20,
  }) async {
    return get<List<DriverReviewModel>>(
      path: DriverReviewsEndpoints.paginatedReviews,
      queryParameters: {'page': page, 'limit': limit},
      decoder: (data) {
        final jsonData = data as Map<String, dynamic>;
        final items = (jsonData['reviews'] as List? ?? jsonData['data'] as List? ?? [])
            .map((e) => DriverReviewModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return items;
      },
    );
  }
}
