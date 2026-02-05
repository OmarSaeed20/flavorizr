import '../entities/driver_trip.dart';
import '../repositories/driver_trips_repository.dart';

/// Use case for getting a specific driver trip by ID
class GetDriverTripById {
  final DriverTripsRepository repository;

  GetDriverTripById(this.repository);

  Future<DriverTrip> call(String tripId) async {
    return await repository.getDriverTripById(tripId);
  }
}