import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/domain/entities/driver_trip.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/domain/repositories/driver_trips_repository.dart';

/// Use case for getting a specific driver trip by ID
class GetDriverTripById {
  final DriverTripsRepository repository;

  GetDriverTripById(this.repository);

  Future<ApiResult<DriverTrip>> call(String tripId) async {
    final result = await repository.getScheduleTrips();

    return result.when(
      success: (trips, _) {
        final trip = trips.firstWhere(
          (t) => t.id == tripId,
          orElse: () => throw const NotFoundException(message: 'Trip not found'),
        );
        return ApiResult.success(trip);
      },
      exception: ApiResult.exception,
    );
  }
}
