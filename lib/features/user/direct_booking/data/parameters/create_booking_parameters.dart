class CreateBookingParameters {
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

  const CreateBookingParameters({
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

  Map<String, dynamic> toJson() {
    return {
      'pickup_location': pickupLocation,
      'pickup_latitude': pickupLatitude,
      'pickup_longitude': pickupLongitude,
      if (dropoffLocation != null) 'dropoff_location': dropoffLocation,
      if (dropoffLatitude != null) 'dropoff_latitude': dropoffLatitude,
      if (dropoffLongitude != null) 'dropoff_longitude': dropoffLongitude,
      'vehicle_type': vehicleType,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (notes != null) 'notes': notes,
      if (promoCode != null) 'promo_code': promoCode,
    };
  }
}
