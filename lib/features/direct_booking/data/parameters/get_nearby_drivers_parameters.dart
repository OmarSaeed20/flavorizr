class GetNearbyDriversParameters {
  final String latitude;
  final String longitude;
  final String? vehicleType;
  final int? radius;

  const GetNearbyDriversParameters({
    required this.latitude,
    required this.longitude,
    this.vehicleType,
    this.radius,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      if (vehicleType != null) 'vehicle_type': vehicleType,
      if (radius != null) 'radius': radius,
    };
  }
}