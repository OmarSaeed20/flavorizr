/// Parameters for updating trip location
class UpdateTripLocationParameters {
  final String tripId;
  final double latitude;
  final double longitude;

  UpdateTripLocationParameters({
    required this.tripId,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}