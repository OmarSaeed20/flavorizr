import '../entities/driver_trip.dart';
import '../repositories/driver_trips_repository.dart';

/// Use case for getting driver trips with pagination and filtering
class GetDriverTrips {
  final DriverTripsRepository repository;

  GetDriverTrips(this.repository);

  Future<List<DriverTrip>> call({
    int page = 1,
    int limit = 10,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await repository.getDriverTrips(
      page: page,
      limit: limit,
      status: status,
      startDate: startDate,
      endDate: endDate,
    );
  }
}