import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/domain/repositories/driver_trips_repository.dart';

/// Use case for rejecting a trip request
class RejectTrip {
  final DriverTripsRepository repository;

  RejectTrip(this.repository);

  Future<ApiResult<void>> call(String tripId) async {
    return repository.rejectTrip(tripId);
  }
}
