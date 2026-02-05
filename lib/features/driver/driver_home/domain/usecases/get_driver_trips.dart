import '../entities/driver_trip.dart';
import '../repositories/driver_home_repository.dart';

/// Use case for getting driver trips with pagination
class GetDriverTrips {
  final DriverHomeRepository repository;

  GetDriverTrips(this.repository);

  Future<List<DriverTrip>> call({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    return await repository.getDriverTrips(
      page: page,
      limit: limit,
      status: status,
    );
  }
}