import '../entities/driver_trip.dart';
import '../repositories/driver_trips_repository.dart';

/// Use case for accepting a trip request
class AcceptTrip {
  final DriverTripsRepository repository;

  AcceptTrip(this.repository);

  Future<DriverTrip> call(String tripId) async {
    return await repository.acceptTrip(tripId);
  }
}