import '../entities/driver_trip.dart';
import '../entities/trip_request.dart';

/// Repository interface for driver trips operations
abstract class DriverTripsRepository {
  /// Get driver trips with pagination and filtering
  Future<List<DriverTrip>> getDriverTrips({
    int page = 1,
    int limit = 10,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get a specific trip by ID
  Future<DriverTrip> getDriverTripById(String tripId);

  /// Get pending trip requests for the driver
  Future<List<DriverTrip>> getPendingTrips();

  /// Accept a trip request
  Future<DriverTrip> acceptTrip(String tripId);

  /// Reject a trip request
  Future<bool> rejectTrip(String tripId, String? reason);

  /// Start a trip
  Future<DriverTrip> startTrip(String tripId);

  /// Complete a trip
  Future<DriverTrip> completeTrip(String tripId, double actualFare);

  /// Cancel a trip
  Future<bool> cancelTrip(String tripId, String reason);

  /// Update trip location
  Future<bool> updateTripLocation(String tripId, double latitude, double longitude);

  /// Get trip statistics
  Future<Map<String, dynamic>> getTripStats();
}