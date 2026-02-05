import 'package:flavorizr/features/user/direct_booking/domain/entities/driver.dart';

class DriverModel extends Driver {
  const DriverModel({
    required super.id,
    required super.name,
    super.phone,
    super.photo,
    required super.rating,
    required super.totalTrips,
    required super.distance,
    super.vehicleNumber,
    super.vehicleModel,
    super.vehicleColor,
    required super.isAvailable,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      photo: json['photo'] as String?,
      rating: (json['rating'] as num).toDouble(),
      totalTrips: json['total_trips'] as int,
      distance: (json['distance'] as num).toDouble(),
      vehicleNumber: json['vehicle_number'] as String?,
      vehicleModel: json['vehicle_model'] as String?,
      vehicleColor: json['vehicle_color'] as String?,
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'photo': photo,
      'rating': rating,
      'total_trips': totalTrips,
      'distance': distance,
      'vehicle_number': vehicleNumber,
      'vehicle_model': vehicleModel,
      'vehicle_color': vehicleColor,
      'is_available': isAvailable,
    };
  }

  Driver toEntity() => this;
}