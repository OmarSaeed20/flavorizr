import '../repositories/driver_trips_repository.dart';

/// Use case for rejecting a trip request
class RejectTrip {
  final DriverTripsRepository repository;

  RejectTrip(this.repository);

  Future<bool> call(String tripId, String? reason) async {
    return await repository.rejectTrip(tripId, reason);
  }
}