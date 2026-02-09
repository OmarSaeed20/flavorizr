import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/domain/entities/driver_trip.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/domain/repositories/driver_trips_repository.dart';

/// Use case for completing a trip
class CompleteTrip {
  final DriverTripsRepository repository;

  CompleteTrip(this.repository);

  Future<ApiResult<DriverTrip>> call(String tripId) async {
    return repository.completeTrip(tripId);
  }
}
