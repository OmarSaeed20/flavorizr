/// Entity representing a scheduled trip.
class ScheduledTrip {
  final String id;
  final String pickupLocation;
  final String pickupLatitude;
  final String pickupLongitude;
  final String dropoffLocation;
  final String dropoffLatitude;
  final String dropoffLongitude;
  final String vehicleType;
  final DateTime scheduledTime;
  final String status;
  final String estimatedFare;
  final String? notes;
  final String? promoCode;
  final DateTime createdAt;

  const ScheduledTrip({
    required this.id,
    required this.pickupLocation,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffLocation,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    required this.vehicleType,
    required this.scheduledTime,
    required this.status,
    required this.estimatedFare,
    this.notes,
    this.promoCode,
    required this.createdAt,
  });
}
