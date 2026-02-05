import 'package:flavorizr/features/user/schedule_trip/domain/entities/scheduled_trip.dart';

class ScheduledTripModel extends ScheduledTrip {
  const ScheduledTripModel({
    required super.id,
    required super.pickupLocation,
    required super.pickupLatitude,
    required super.pickupLongitude,
    required super.dropoffLocation,
    required super.dropoffLatitude,
    required super.dropoffLongitude,
    required super.vehicleType,
    required super.scheduledTime,
    required super.status,
    required super.estimatedFare,
    super.notes,
    super.promoCode,
    required super.createdAt,
  });

  factory ScheduledTripModel.fromJson(Map<String, dynamic> json) {
    return ScheduledTripModel(
      id: json['id'] as String,
      pickupLocation: json['pickup_location'] as String,
      pickupLatitude: json['pickup_latitude'] as String,
      pickupLongitude: json['pickup_longitude'] as String,
      dropoffLocation: json['dropoff_location'] as String,
      dropoffLatitude: json['dropoff_latitude'] as String,
      dropoffLongitude: json['dropoff_longitude'] as String,
      vehicleType: json['vehicle_type'] as String,
      scheduledTime: DateTime.parse(json['scheduled_time'] as String),
      status: json['status'] as String,
      estimatedFare: json['estimated_fare'] as String,
      notes: json['notes'] as String?,
      promoCode: json['promo_code'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pickup_location': pickupLocation,
      'pickup_latitude': pickupLatitude,
      'pickup_longitude': pickupLongitude,
      'dropoff_location': dropoffLocation,
      'dropoff_latitude': dropoffLatitude,
      'dropoff_longitude': dropoffLongitude,
      'vehicle_type': vehicleType,
      'scheduled_time': scheduledTime.toIso8601String(),
      'status': status,
      'estimated_fare': estimatedFare,
      'notes': notes,
      'promo_code': promoCode,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ScheduledTrip toEntity() => this;
}
