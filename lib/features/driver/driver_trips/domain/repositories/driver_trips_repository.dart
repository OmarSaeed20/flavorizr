import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/domain/entities/driver_trip.dart';

/// Repository interface for driver trips operations.
abstract class DriverTripsRepository {
  /// Accepts a trip request.
  Future<ApiResult<DriverTrip>> acceptTrip(String tripId);

  /// Rejects a trip request.
  Future<ApiResult<void>> rejectTrip(String tripId);

  /// Starts a trip.
  Future<ApiResult<DriverTrip>> startTrip(String tripId);

  /// Marks driver as arrived at pickup location.
  Future<ApiResult<DriverTrip>> arrived(String tripId);

  /// Completes a trip.
  Future<ApiResult<DriverTrip>> completeTrip(String tripId);

  /// Cancels a trip.
  Future<ApiResult<void>> cancelTrip(String tripId);

  /// Gets driver's scheduled trips.
  Future<ApiResult<List<DriverTrip>>> getScheduleTrips();

  /// Creates a schedule trip request.
  Future<ApiResult<DriverTrip>> createScheduleRequest({
    required String pickUpLongitude,
    required String pickUpLatitude,
    required String destinationLongitude,
    required String destinationLatitude,
    required String pickupName,
    required String destinationName,
    required String date,
    required String pickUpTime,
    required String dropUpTime,
    required int vehicleTypeId,
  });

  /// Gets driver's schedule trip requests.
  Future<ApiResult<List<DriverTrip>>> getScheduleRequests({String? date, String? status});
}
