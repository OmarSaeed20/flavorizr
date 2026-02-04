import 'package:flavorizr/features/direct_booking/domain/entities/vehicle_type.dart';

class VehicleTypeModel extends VehicleType {
  const VehicleTypeModel({
    required super.id,
    required super.name,
    super.description,
    super.imageUrl,
    required super.baseFare,
    required super.farePerKm,
    required super.farePerMinute,
    required super.capacity,
    required super.isAvailable,
  });

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) {
    return VehicleTypeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      baseFare: (json['base_fare'] as num).toDouble(),
      farePerKm: (json['fare_per_km'] as num).toDouble(),
      farePerMinute: (json['fare_per_minute'] as num).toDouble(),
      capacity: json['capacity'] as int,
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'base_fare': baseFare,
      'fare_per_km': farePerKm,
      'fare_per_minute': farePerMinute,
      'capacity': capacity,
      'is_available': isAvailable,
    };
  }

  VehicleType toEntity() => this;
}