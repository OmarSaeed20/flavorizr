import 'package:flavorizr/core/network/resluts/dio_reslut.dart';

import '../entities/driver_review.dart';
import '../repositories/driver_review_repository.dart';

/// Use case for getting driver reviews
class GetDriverReviews {
  final DriverReviewRepository repository;

  GetDriverReviews(this.repository);

  Future<ApiResult<List<DriverReview>>> call({
    required String driverId,
    required int page,
    required int limit,
    int? minRating,
    int? maxRating,
    bool? withResponse,
    bool? pendingResponse,
  }) {
    return repository.getDriverReviews(
      driverId: driverId,
      page: page,
      limit: limit,
      minRating: minRating,
      maxRating: maxRating,
      withResponse: withResponse,
      pendingResponse: pendingResponse,
    );
  }
}
