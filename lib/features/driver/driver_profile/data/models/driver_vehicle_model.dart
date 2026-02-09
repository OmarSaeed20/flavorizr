import 'package:fast_golden_taxi/features/driver/driver_profile/domain/entities/driver_vehicle.dart';

/// Model for DriverVehicle entity.
class DriverVehicleModel extends DriverVehicle {
  DriverVehicleModel({
    required super.id,
    required super.driverId,
    required super.make,
    required super.model,
    required super.year,
    required super.color,
    required super.licensePlate,
    required super.vehicleType,
    super.capacity,
    super.vin,
    super.registrationNumber,
    super.registrationExpiry,
    required super.isActive,
    required super.createdAt,
    super.updatedAt,
  });

  factory DriverVehicleModel.fromJson(Map<String, dynamic> json) {
    return DriverVehicleModel(
      id: json['id'] as String,
      driverId: json['driver_id'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      color: json['color'] as String,
      licensePlate: json['license_plate'] as String,
      vehicleType: json['vehicle_type'] as String,
      capacity: json['capacity'] as int?,
      vin: json['vin'] as String?,
      registrationNumber: json['registration_number'] as String?,
      registrationExpiry: json['registration_expiry'] != null
          ? DateTime.parse(json['registration_expiry'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'make': make,
      'model': model,
      'year': year,
      'color': color,
      'license_plate': licensePlate,
      'vehicle_type': vehicleType,
      'capacity': capacity,
      'vin': vin,
      'registration_number': registrationNumber,
      'registration_expiry': registrationExpiry?.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  DriverVehicle toEntity() {
    return DriverVehicle(
      id: id,
      driverId: driverId,
      make: make,
      model: model,
      year: year,
      color: color,
      licensePlate: licensePlate,
      vehicleType: vehicleType,
      capacity: capacity,
      vin: vin,
      registrationNumber: registrationNumber,
      registrationExpiry: registrationExpiry,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
