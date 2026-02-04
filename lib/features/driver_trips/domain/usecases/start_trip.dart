import '../entities/driver_trip.dart';
import '../repositories/driver_trips_repository.dart';

/// Use case for starting a trip
class StartTrip {
  final DriverTripsRepository repository;

  StartTrip(this.repository);

  Future<DriverTrip> call(String tripId) async {
    return await repository.startTrip(tripId);
  }
}