/// Trip request entity for creating a new trip
class TripRequest {
  final String passengerId;
  final String pickupLocation;
  final String pickupLatitude;
  final String pickupLongitude;
  final String dropoffLocation;
  final String dropoffLatitude;
  final String dropoffLongitude;
  final String vehicleType;
  final int passengerCount;
  final String paymentMethod;
  final String? specialRequests;
  final double estimatedDistance;
  final double estimatedDuration;
  final double estimatedFare;

  const TripRequest({
    required this.passengerId,
    required this.pickupLocation,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffLocation,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    required this.vehicleType,
    required this.passengerCount,
    required this.paymentMethod,
    this.specialRequests,
    required this.estimatedDistance,
    required this.estimatedDuration,
    required this.estimatedFare,
  });

  TripRequest copyWith({
    String? passengerId,
    String? pickupLocation,
    String? pickupLatitude,
    String? pickupLongitude,
    String? dropoffLocation,
    String? dropoffLatitude,
    String? dropoffLongitude,
    String? vehicleType,
    int? passengerCount,
    String? paymentMethod,
    String? specialRequests,
    double? estimatedDistance,
    double? estimatedDuration,
    double? estimatedFare,
  }) {
    return TripRequest(
      passengerId: passengerId ?? this.passengerId,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      pickupLatitude: pickupLatitude ?? this.pickupLatitude,
      pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      dropoffLatitude: dropoffLatitude ?? this.dropoffLatitude,
      dropoffLongitude: dropoffLongitude ?? this.dropoffLongitude,
      vehicleType: vehicleType ?? this.vehicleType,
      passengerCount: passengerCount ?? this.passengerCount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      specialRequests: specialRequests ?? this.specialRequests,
      estimatedDistance: estimatedDistance ?? this.estimatedDistance,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      estimatedFare: estimatedFare ?? this.estimatedFare,
    );
  }
}