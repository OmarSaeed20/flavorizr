import '../entities/driver_trip.dart';
import '../repositories/driver_trips_repository.dart';

/// Use case for completing a trip
class CompleteTrip {
  final DriverTripsRepository repository;

  CompleteTrip(this.repository);

  Future<DriverTrip> call(String tripId, double actualFare) async {
    return await repository.completeTrip(tripId, actualFare);
  }
}