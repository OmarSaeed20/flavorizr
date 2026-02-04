/// Entity representing a booking request.
class BookingRequest {
  final String pickupLocation;
  final String pickupLatitude;
  final String pickupLongitude;
  final String? dropoffLocation;
  final String? dropoffLatitude;
  final String? dropoffLongitude;
  final String vehicleType;
  final String? paymentMethod;
  final String? notes;
  final String? promoCode;

  const BookingRequest({
    required this.pickupLocation,
    required this.pickupLatitude,
    required this.pickupLongitude,
    this.dropoffLocation,
    this.dropoffLatitude,
    this.dropoffLongitude,
    required this.vehicleType,
    this.paymentMethod,
    this.notes,
    this.promoCode,
  });
}