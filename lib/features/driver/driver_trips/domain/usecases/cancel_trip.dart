import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_trips/domain/repositories/driver_trips_repository.dart';

/// Use case for cancelling a trip
class CancelTrip {
  final DriverTripsRepository repository;

  CancelTrip(this.repository);

  Future<ApiResult<void>> call(String tripId) async {
    return repository.cancelTrip(tripId);
  }
}
