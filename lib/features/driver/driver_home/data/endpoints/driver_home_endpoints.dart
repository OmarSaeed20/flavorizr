// lib/features/driver_home/data/endpoints/driver_home_endpoints.dart
/// Defines all API endpoints for driver home operations.
abstract class DriverHomeEndpoints {
  const DriverHomeEndpoints._();

  /// Gets complete driver home data.
  static const String homeData = '/driver/home';

  /// Gets driver earnings.
  static const String earnings = '/driver/earnings';

  /// Gets driver statistics.
  static const String stats = '/driver/stats';

  /// Gets driver trips with pagination.
  static const String trips = '/driver/trips';

  /// Gets a specific trip by ID.
  static String tripById(String tripId) => '/driver/trips/$tripId';

  /// Updates driver online status.
  static const String updateOnlineStatus = '/driver/status/online';

  /// Updates driver availability status.
  static const String updateAvailabilityStatus = '/driver/status/availability';

  /// Gets driver current trip.
  static const String currentTrip = '/driver/trips/current';

  /// Gets driver pending trips.
  static const String pendingTrips = '/driver/trips/pending';

  /// Gets driver completed trips.
  static const String completedTrips = '/driver/trips/completed';
}
