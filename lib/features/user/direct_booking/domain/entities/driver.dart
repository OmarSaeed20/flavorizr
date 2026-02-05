/// Entity representing a driver.
class TaxiDriver {
  final String id;
  final String name;
  final String? phone;
  final String? photo;
  final double rating;
  final int totalTrips;
  final double distance;
  final String? vehicleNumber;
  final String? vehicleModel;
  final String? vehicleColor;
  final bool isAvailable;

  const TaxiDriver({
    required this.id,
    required this.name,
    this.phone,
    this.photo,
    required this.rating,
    required this.totalTrips,
    required this.distance,
    this.vehicleNumber,
    this.vehicleModel,
    this.vehicleColor,
    required this.isAvailable,
  });
}
