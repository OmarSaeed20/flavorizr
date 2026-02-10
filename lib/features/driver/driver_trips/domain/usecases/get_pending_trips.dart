import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/domain/entities/driver_trip.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/domain/repositories/driver_trips_repository.dart';

/// Use case for getting pending trip requests
class GetPendingTrips {
  final DriverTripsRepository repository;

  GetPendingTrips(this.repository);

  Future<ApiResult<List<DriverTrip>>> call() async {
    return repository.getScheduleRequests(status: 'pending');
  }
}
