class GetAvailableTripsParameters {
  final double pickupLatitude;
  final double pickupLongitude;
  final double dropoffLatitude;
  final double dropoffLongitude;
  final String? vehicleType;
  final int? radius;
  final int? limit;

  const GetAvailableTripsParameters({
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    this.vehicleType,
    this.radius,
    this.limit,
  });

  Map<String, dynamic> toJson() {
    return {
      'pickup_latitude': pickupLatitude,
      'pickup_longitude': pickupLongitude,
      'dropoff_latitude': dropoffLatitude,
      'dropoff_longitude': dropoffLongitude,
      if (vehicleType != null) 'vehicle_type': vehicleType,
      if (radius != null) 'radius': radius,
      if (limit != null) 'limit': limit,
    };
  }
}