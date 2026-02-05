/// Defines all API endpoints for driver trip operations.
///
/// All endpoints are based on the FAST App API documentation.
/// Base URL: https://fasttaxi.questifysolutions.com/api/v1
abstract class DriverTripsEndpoints {
  const DriverTripsEndpoints._();

  /// Accept a trip request.
  /// Endpoint: POST /driver/trip/accept
  static const String acceptTrip = '/driver/trip/accept';

  /// Reject a trip request.
  /// Endpoint: POST /driver/trip/reject
  static const String rejectTrip = '/driver/trip/reject';

  /// Start a trip.
  /// Endpoint: PATCH /driver/trip/start
  static const String startTrip = '/driver/trip/start';

  /// Mark driver as arrived at pickup location.
  /// Endpoint: PATCH /driver/trip/arrived
  static const String arrived = '/driver/trip/arrived';

  /// Complete a trip.
  /// Endpoint: PATCH /driver/trip/complete
  static const String completeTrip = '/driver/trip/complete';

  /// Cancel a trip.
  /// Endpoint: PATCH /driver/trip/cancel
  static const String cancelTrip = '/driver/trip/cancel';

  /// Get driver's scheduled trips.
  /// Endpoint: GET /driver/schedule-trip/trips
  static const String getScheduleTrips = '/driver/schedule-trip/trips';

  /// Create a schedule trip request.
  /// Endpoint: POST /driver/schedule-trip/create-request
  static const String createScheduleRequest =
      '/driver/schedule-trip/create-request';

  /// Get driver's schedule trip requests.
  /// Endpoint: POST /driver/schedule-trip/my-requests
  static const String getScheduleRequests = '/driver/schedule-trip/my-requests';
}
