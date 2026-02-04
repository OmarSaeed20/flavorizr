class CreateScheduledTripParameters {
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

  const CreateScheduledTripParameters({
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

  Map<String, dynamic> toJson() {
    return {
      'pickup_location': pickupLocation,
      'pickup_latitude': pickupLatitude,
      'pickup_longitude': pickupLongitude,
      'dropoff_location': dropoffLocation,
      'dropoff_latitude': dropoffLatitude,
      'dropoff_longitude': dropoffLongitude,
      'vehicle_type': vehicleType,
      'scheduled_time': scheduledTime.toIso8601String(),
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (notes != null) 'notes': notes,
      if (promoCode != null) 'promo_code': promoCode,
    };
  }
}