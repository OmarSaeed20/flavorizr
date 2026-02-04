import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver_reviews/domain/entities/driver_review.dart';
import 'package:flavorizr/features/driver_reviews/domain/entities/review_stats.dart';

/// Repository interface for driver reviews
abstract class DriverReviewRepository {
  /// Get all reviews for a driver with pagination
  Future<ApiResult<List<DriverReview>>> getDriverReviews({
    required String driverId,
    required int page,
    required int limit,
    int? minRating,
    int? maxRating,
    bool? withResponse,
    bool? pendingResponse,
  });

  /// Get a specific review by ID
  Future<ApiResult<DriverReview>> getDriverReviewById({required String reviewId});

  /// Get review statistics for a driver
  Future<ApiResult<ReviewStats>> getDriverReviewStats({required String driverId});

  /// Respond to a review
  Future<ApiResult<DriverReview>> respondToReview({
    required String reviewId,
    required String response,
  });
}
