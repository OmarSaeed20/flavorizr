class AvailableTrip {
  final int id;
  final String? driverName;
  final String? driverPhone;
  final String? driverImage;
  final String? vehicleType;
  final String? vehicleModel;
  final String? vehiclePlate;
  final double pickupLatitude;
  final double pickupLongitude;
  final String pickupAddress;
  final double dropoffLatitude;
  final double dropoffLongitude;
  final String dropoffAddress;
  final double? estimatedDistance;
  final double? estimatedDuration;
  final double? estimatedPrice;
  final String? currency;
  final int? availableSeats;
  final DateTime? departureTime;
  final String? status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AvailableTrip({
    required this.id,
    this.driverName,
    this.driverPhone,
    this.driverImage,
    this.vehicleType,
    this.vehicleModel,
    this.vehiclePlate,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.pickupAddress,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    required this.dropoffAddress,
    this.estimatedDistance,
    this.estimatedDuration,
    this.estimatedPrice,
    this.currency,
    this.availableSeats,
    this.departureTime,
    this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  AvailableTrip copyWith({
    int? id,
    String? driverName,
    String? driverPhone,
    String? driverImage,
    String? vehicleType,
    String? vehicleModel,
    String? vehiclePlate,
    double? pickupLatitude,
    double? pickupLongitude,
    String? pickupAddress,
    double? dropoffLatitude,
    double? dropoffLongitude,
    String? dropoffAddress,
    double? estimatedDistance,
    double? estimatedDuration,
    double? estimatedPrice,
    String? currency,
    int? availableSeats,
    DateTime? departureTime,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AvailableTrip(
      id: id ?? this.id,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      driverImage: driverImage ?? this.driverImage,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      pickupLatitude: pickupLatitude ?? this.pickupLatitude,
      pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      dropoffLatitude: dropoffLatitude ?? this.dropoffLatitude,
      dropoffLongitude: dropoffLongitude ?? this.dropoffLongitude,
      dropoffAddress: dropoffAddress ?? this.dropoffAddress,
      estimatedDistance: estimatedDistance ?? this.estimatedDistance,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      currency: currency ?? this.currency,
      availableSeats: availableSeats ?? this.availableSeats,
      departureTime: departureTime ?? this.departureTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}