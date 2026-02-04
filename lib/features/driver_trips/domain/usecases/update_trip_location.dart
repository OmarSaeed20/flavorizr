import '../repositories/driver_trips_repository.dart';

/// Use case for updating trip location
class UpdateTripLocation {
  final DriverTripsRepository repository;

  UpdateTripLocation(this.repository);

  Future<bool> call(String tripId, double latitude, double longitude) async {
    return await repository.updateTripLocation(tripId, latitude, longitude);
  }
}