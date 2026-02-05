import '../repositories/driver_trips_repository.dart';

/// Use case for getting trip statistics
class GetTripStats {
  final DriverTripsRepository repository;

  GetTripStats(this.repository);

  Future<Map<String, dynamic>> call() async {
    return await repository.getTripStats();
  }
}