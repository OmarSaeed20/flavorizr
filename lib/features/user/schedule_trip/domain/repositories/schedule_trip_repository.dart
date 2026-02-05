import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/schedule_trip/data/parameters/create_scheduled_trip_parameters.dart';
import 'package:flavorizr/features/user/schedule_trip/data/parameters/get_scheduled_trips_parameters.dart';
import 'package:flavorizr/features/user/schedule_trip/domain/entities/scheduled_trip.dart';

/// Repository interface for schedule trip operations.
abstract class ScheduleTripRepository {
  /// Creates a new scheduled trip.
  Future<ApiResult<ScheduledTrip>> createScheduledTrip(
    CreateScheduledTripParameters params,
  );

  /// Gets scheduled trips for the user.
  Future<ApiResult<List<ScheduledTrip>>> getScheduledTrips(
    GetScheduledTripsParameters params,
  );

  /// Gets a specific scheduled trip by ID.
  Future<ApiResult<ScheduledTrip>> getScheduledTripById(String tripId);

  /// Cancels a scheduled trip.
  Future<ApiResult<void>> cancelScheduledTrip(String tripId);

  /// Updates a scheduled trip.
  Future<ApiResult<ScheduledTrip>> updateScheduledTrip(
    String tripId,
    CreateScheduledTripParameters params,
  );
}
