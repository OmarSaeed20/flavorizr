import '../repositories/driver_trips_repository.dart';

/// Use case for cancelling a trip
class CancelTrip {
  final DriverTripsRepository repository;

  CancelTrip(this.repository);

  Future<bool> call(String tripId, String reason) async {
    return await repository.cancelTrip(tripId, reason);
  }
}