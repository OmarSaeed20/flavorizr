import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_reviews/domain/entities/driver_review.dart';
import 'package:flavorizr/features/driver/driver_reviews/domain/repositories/driver_review_repository.dart';

/// Use case for responding to a driver review
class RespondToReview {
  final DriverReviewRepository repository;

  RespondToReview(this.repository);

  Future<ApiResult<DriverReview>> call({required String reviewId, required String response}) {
    return repository.respondToReview(reviewId: reviewId, response: response);
  }
}
