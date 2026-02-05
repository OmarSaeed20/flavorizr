// lib/features/driver_trips/data/endpoints/driver_trips_endpoints.dart
/// Defines all API endpoints for driver trips operations.
abstract class DriverTripsEndpoints {
  const DriverTripsEndpoints._();

  /// Gets driver trips with pagination and filtering.
  static const String trips = '/driver/trips';

  /// Gets a specific trip by ID.
  static String tripById(String tripId) => '/driver/trips/$tripId';

  /// Gets pending trip requests.
  static const String pendingTrips = '/driver/trips/pending';

  /// Accepts a trip request.
  static String acceptTrip(String tripId) => '/driver/trips/$tripId/accept';

  /// Rejects a trip request.
  static String rejectTrip(String tripId) => '/driver/trips/$tripId/reject';

  /// Starts a trip.
  static String startTrip(String tripId) => '/driver/trips/$tripId/start';

  /// Completes a trip.
  static String completeTrip(String tripId) => '/driver/trips/$tripId/complete';

  /// Cancels a trip.
  static String cancelTrip(String tripId) => '/driver/trips/$tripId/cancel';

  /// Updates trip location.
  static String updateLocation(String tripId) => '/driver/trips/$tripId/location';

  /// Gets trip route.
  static String tripRoute(String tripId) => '/driver/trips/$tripId/route';

  /// Updates trip status.
  static String updateStatus(String tripId) => '/driver/trips/$tripId/status';

  /// Gets trip history.
  static const String tripHistory = '/driver/trips/history';

  /// Gets current active trip.
  static const String currentTrip = '/driver/trips/current';
}
