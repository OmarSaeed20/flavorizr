import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/domain/entities/driver_trip.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/domain/repositories/driver_trips_repository.dart';

/// Use case for getting driver trips with pagination and filtering
class GetDriverTrips {
  final DriverTripsRepository repository;

  GetDriverTrips(this.repository);

  Future<ApiResult<List<DriverTrip>>> call({
    String? date,
    String? status,
  }) async {
    return repository.getScheduleRequests(date: date, status: status);
  }
}
