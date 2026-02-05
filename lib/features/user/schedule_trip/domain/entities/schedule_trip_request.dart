/// Entity representing a schedule trip request.
class ScheduleTripRequest {
  final String pickupLocation;
  final String pickupLatitude;
  final String pickupLongitude;
  final String dropoffLocation;
  final String dropoffLatitude;
  final String dropoffLongitude;
  final String vehicleType;
  final DateTime scheduledTime;
  final String? paymentMethod;
  final String? notes;
  final String? promoCode;

  const ScheduleTripRequest({
    required this.pickupLocation,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffLocation,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    required this.vehicleType,
    required this.scheduledTime,
    this.paymentMethod,
    this.notes,
    this.promoCode,
  });
}
