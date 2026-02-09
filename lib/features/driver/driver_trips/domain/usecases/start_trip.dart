import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/domain/entities/driver_trip.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/domain/repositories/driver_trips_repository.dart';

/// Use case for starting a trip
class StartTrip {
  final DriverTripsRepository repository;

  StartTrip(this.repository);

  Future<ApiResult<DriverTrip>> call(String tripId) async {
    return repository.startTrip(tripId);
  }
}
