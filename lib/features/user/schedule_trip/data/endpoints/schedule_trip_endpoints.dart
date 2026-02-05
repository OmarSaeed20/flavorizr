// lib/features/schedule_trip/data/endpoints/schedule_trip_endpoints.dart
/// Defines all API endpoints for scheduled trip operations.
abstract class ScheduleTripEndpoints {
  const ScheduleTripEndpoints._();

  /// Creates a new scheduled trip.
  static const String createScheduledTrip = '/scheduled-trips';

  /// Gets scheduled trips for the user.
  static const String scheduledTrips = '/scheduled-trips';

  /// Gets a specific scheduled trip by ID.
  static String scheduledTripById(String tripId) => '/scheduled-trips/$tripId';

  /// Cancels a scheduled trip.
  static String cancelScheduledTrip(String tripId) =>
      '/scheduled-trips/$tripId/cancel';

  /// Updates a scheduled trip.
  static String updateScheduledTrip(String tripId) =>
      '/scheduled-trips/$tripId';

  /// Gets scheduled trip history.
  static const String scheduledTripHistory = '/scheduled-trips/history';

  /// Gets upcoming scheduled trips.
  static const String upcomingTrips = '/scheduled-trips/upcoming';

  /// Gets past scheduled trips.
  static const String pastTrips = '/scheduled-trips/past';

  /// Gets scheduled trip estimate.
  static const String scheduledTripEstimate = '/scheduled-trips/estimate';

  /// Gets scheduled trip availability.
  static const String tripAvailability = '/scheduled-trips/availability';
}
