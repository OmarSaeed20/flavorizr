// lib/features/direct_booking/data/endpoints/direct_booking_endpoints.dart
/// Defines all API endpoints for direct booking operations.
abstract class DirectBookingEndpoints {
  const DirectBookingEndpoints._();

  /// Creates a new booking.
  static const String createBooking = '/bookings';

  /// Gets a specific booking by ID.
  static String bookingById(String bookingId) => '/bookings/$bookingId';

  /// Gets nearby drivers based on location.
  static const String nearbyDrivers = '/drivers/nearby';

  /// Gets available vehicle types.
  static const String vehicleTypes = '/vehicle-types';

  /// Cancels a booking.
  static String cancelBooking(String bookingId) => '/bookings/$bookingId/cancel';

  /// Gets booking estimate.
  static const String bookingEstimate = '/bookings/estimate';

  /// Gets booking history.
  static const String bookingHistory = '/bookings/history';

  /// Gets active booking.
  static const String activeBooking = '/bookings/active';

  /// Updates booking.
  static String updateBooking(String bookingId) => '/bookings/$bookingId';

  /// Gets booking status.
  static String bookingStatus(String bookingId) => '/bookings/$bookingId/status';
}
