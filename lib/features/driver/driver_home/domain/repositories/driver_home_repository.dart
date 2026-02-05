import '../entities/driver_home_data.dart';
import '../entities/driver_earnings.dart';
import '../entities/driver_stats.dart';
import '../entities/driver_trip.dart';

/// Repository interface for driver home data operations
abstract class DriverHomeRepository {
  /// Get complete driver home data including stats, earnings, and recent trips
  Future<DriverHomeData> getDriverHomeData();

  /// Get driver earnings for different time periods
  Future<DriverEarnings> getDriverEarnings();

  /// Get driver statistics
  Future<DriverStats> getDriverStats();

  /// Get recent driver trips with pagination
  Future<List<DriverTrip>> getDriverTrips({
    int page = 1,
    int limit = 10,
    String? status,
  });

  /// Get a specific trip by ID
  Future<DriverTrip> getDriverTripById(String tripId);

  /// Update driver online status
  Future<bool> updateOnlineStatus(bool isOnline);

  /// Update driver availability status
  Future<bool> updateAvailabilityStatus(bool isAvailable);
}