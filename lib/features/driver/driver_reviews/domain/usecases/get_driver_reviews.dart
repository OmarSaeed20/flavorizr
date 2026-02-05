import 'package:flavorizr/core/network/resluts/dio_reslut.dart';

import 'package:flavorizr/features/driver/driver_reviews/domain/entities/driver_review.dart';
import 'package:flavorizr/features/driver/driver_reviews/domain/repositories/driver_review_repository.dart';

/// Use case for getting driver reviews
class GetDriverReviews {
  final DriverReviewRepository repository;

  GetDriverReviews(this.repository);

  Future<ApiResult<List<DriverReview>>> call({
    required String driverId,
    int? tripId,
    int? rating,
    int page = 1,
    int limit = 20,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  }) {
    return repository.getReviews(
      driverId: driverId,
      tripId: tripId,
      rating: rating,
      page: page,
      limit: limit,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }
}
