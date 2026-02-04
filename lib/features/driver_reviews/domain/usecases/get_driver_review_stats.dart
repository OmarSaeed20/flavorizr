import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver_reviews/domain/entities/review_stats.dart';
import 'package:flavorizr/features/driver_reviews/domain/repositories/driver_review_repository.dart';

/// Use case for getting driver review statistics
class GetDriverReviewStats {
  final DriverReviewRepository repository;

  GetDriverReviewStats(this.repository);

  Future<ApiResult<ReviewStats>> call({required String driverId}) {
    return repository.getDriverReviewStats(driverId: driverId);
  }
}
