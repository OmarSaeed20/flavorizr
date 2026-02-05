import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_reviews/domain/entities/driver_review.dart';
import 'package:flavorizr/features/driver/driver_reviews/domain/repositories/driver_review_repository.dart';

/// Use case for getting a specific driver review by ID
class GetDriverReviewById {
  final DriverReviewRepository repository;

  GetDriverReviewById(this.repository);

  Future<ApiResult<DriverReview>> call({required String reviewId}) {
    return repository.getDriverReviewById(reviewId: reviewId);
  }
}
