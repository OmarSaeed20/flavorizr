import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/data/parameters/create_scheduled_trip_parameters.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/domain/entities/scheduled_trip.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/domain/repositories/schedule_trip_repository.dart';

/// Use case for creating a scheduled trip.
class CreateScheduledTripUseCase {
  final ScheduleTripRepository _repository;

  CreateScheduledTripUseCase(this._repository);

  Future<ApiResult<ScheduledTrip>> call(CreateScheduledTripParameters params) {
    return _repository.createScheduledTrip(params);
  }
}
