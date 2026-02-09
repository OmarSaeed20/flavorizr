import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_reviews/domain/entities/driver_review.dart';

/// Repository interface for driver reviews.
abstract class DriverReviewRepository {
  /// Gets reviews for a specific driver.
  Future<ApiResult<List<DriverReview>>> getReviews({
    required String driverId,
    int? tripId,
    int? rating,
    int page = 1,
    int limit = 20,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  });
}
