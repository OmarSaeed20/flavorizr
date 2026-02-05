import '../entities/driver_trip.dart';
import '../repositories/driver_home_repository.dart';

/// Use case for getting a specific driver trip by ID
class GetDriverTripById {
  final DriverHomeRepository repository;

  GetDriverTripById(this.repository);

  Future<DriverTrip> call(String tripId) async {
    return await repository.getDriverTripById(tripId);
  }
}