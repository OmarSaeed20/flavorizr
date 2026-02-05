/// Entity representing a vehicle type.
class VehicleType {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final double baseFare;
  final double farePerKm;
  final double farePerMinute;
  final int capacity;
  final bool isAvailable;

  const VehicleType({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.baseFare,
    required this.farePerKm,
    required this.farePerMinute,
    required this.capacity,
    required this.isAvailable,
  });
}
