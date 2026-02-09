import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/domain/entities/scheduled_trip.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/domain/repositories/schedule_trip_repository.dart';

/// Use case for getting a scheduled trip by ID.
class GetScheduledTripByIdUseCase {
  final ScheduleTripRepository _repository;

  GetScheduledTripByIdUseCase(this._repository);

  Future<ApiResult<ScheduledTrip>> call(String tripId) {
    return _repository.getScheduledTripById(tripId);
  }
}
