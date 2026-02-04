import '../entities/driver_trip.dart';
import '../repositories/driver_trips_repository.dart';

/// Use case for getting pending trip requests
class GetPendingTrips {
  final DriverTripsRepository repository;

  GetPendingTrips(this.repository);

  Future<List<DriverTrip>> call() async {
    return await repository.getPendingTrips();
  }
}