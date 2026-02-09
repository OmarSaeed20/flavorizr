import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/data/parameters/create_scheduled_trip_parameters.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/domain/entities/scheduled_trip.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/domain/repositories/schedule_trip_repository.dart';

/// Use case for updating a scheduled trip.
class UpdateScheduledTripUseCase {
  final ScheduleTripRepository _repository;

  UpdateScheduledTripUseCase(this._repository);

  Future<ApiResult<ScheduledTrip>> call(String tripId, CreateScheduledTripParameters params) {
    return _repository.updateScheduledTrip(tripId, params);
  }
}
