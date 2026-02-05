/// Driver vehicle entity.
class DriverVehicle {
  final String id;
  final String driverId;
  final String make;
  final String model;
  final int year;
  final String color;
  final String licensePlate;
  final String vehicleType;
  final int? capacity;
  final String? vin;
  final String? registrationNumber;
  final DateTime? registrationExpiry;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  DriverVehicle({
    required this.id,
    required this.driverId,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.licensePlate,
    required this.vehicleType,
    this.capacity,
    this.vin,
    this.registrationNumber,
    this.registrationExpiry,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  String get displayName => '$year $make $model';
}
