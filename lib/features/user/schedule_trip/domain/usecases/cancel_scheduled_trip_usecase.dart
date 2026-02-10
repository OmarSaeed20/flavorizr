import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/domain/repositories/schedule_trip_repository.dart';

/// Use case for cancelling a scheduled trip.
class CancelScheduledTripUseCase {
  final ScheduleTripRepository _repository;

  CancelScheduledTripUseCase(this._repository);

  Future<ApiResult<void>> call(String tripId) {
    return _repository.cancelScheduledTrip(tripId);
  }
}
