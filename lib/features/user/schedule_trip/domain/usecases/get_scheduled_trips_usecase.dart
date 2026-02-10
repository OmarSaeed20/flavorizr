import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/data/parameters/get_scheduled_trips_parameters.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/domain/entities/scheduled_trip.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/domain/repositories/schedule_trip_repository.dart';

/// Use case for getting scheduled trips.
class GetScheduledTripsUseCase {
  final ScheduleTripRepository _repository;

  GetScheduledTripsUseCase(this._repository);

  Future<ApiResult<List<ScheduledTrip>>> call(GetScheduledTripsParameters params) {
    return _repository.getScheduledTrips(params);
  }
}
