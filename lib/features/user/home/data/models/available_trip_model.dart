import 'package:flavorizr/features/user/home/domain/entities/available_trip.dart';

class AvailableTripModel extends AvailableTrip {
  const AvailableTripModel({
    required super.id,
    super.driverName,
    super.driverPhone,
    super.driverImage,
    super.vehicleType,
    super.vehicleModel,
    super.vehiclePlate,
    required super.pickupLatitude,
    required super.pickupLongitude,
    required super.pickupAddress,
    required super.dropoffLatitude,
    required super.dropoffLongitude,
    required super.dropoffAddress,
    super.estimatedDistance,
    super.estimatedDuration,
    super.estimatedPrice,
    super.currency,
    super.availableSeats,
    super.departureTime,
    super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AvailableTripModel.fromJson(Map<String, dynamic> json) {
    return AvailableTripModel(
      id: json['id'] as int,
      driverName: json['driver_name'] as String?,
      driverPhone: json['driver_phone'] as String?,
      driverImage: json['driver_image'] as String?,
      vehicleType: json['vehicle_type'] as String?,
      vehicleModel: json['vehicle_model'] as String?,
      vehiclePlate: json['vehicle_plate'] as String?,
      pickupLatitude: (json['pickup_latitude'] as num).toDouble(),
      pickupLongitude: (json['pickup_longitude'] as num).toDouble(),
      pickupAddress: json['pickup_address'] as String,
      dropoffLatitude: (json['dropoff_latitude'] as num).toDouble(),
      dropoffLongitude: (json['dropoff_longitude'] as num).toDouble(),
      dropoffAddress: json['dropoff_address'] as String,
      estimatedDistance: json['estimated_distance'] != null
          ? (json['estimated_distance'] as num).toDouble()
          : null,
      estimatedDuration: json['estimated_duration'] != null
          ? (json['estimated_duration'] as num).toDouble()
          : null,
      estimatedPrice: json['estimated_price'] != null
          ? (json['estimated_price'] as num).toDouble()
          : null,
      currency: json['currency'] as String?,
      availableSeats: json['available_seats'] as int?,
      departureTime: json['departure_time'] != null
          ? DateTime.parse(json['departure_time'] as String)
          : null,
      status: json['status'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'driver_image': driverImage,
      'vehicle_type': vehicleType,
      'vehicle_model': vehicleModel,
      'vehicle_plate': vehiclePlate,
      'pickup_latitude': pickupLatitude,
      'pickup_longitude': pickupLongitude,
      'pickup_address': pickupAddress,
      'dropoff_latitude': dropoffLatitude,
      'dropoff_longitude': dropoffLongitude,
      'dropoff_address': dropoffAddress,
      'estimated_distance': estimatedDistance,
      'estimated_duration': estimatedDuration,
      'estimated_price': estimatedPrice,
      'currency': currency,
      'available_seats': availableSeats,
      'departure_time': departureTime?.toIso8601String(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AvailableTrip toEntity() => this;
}