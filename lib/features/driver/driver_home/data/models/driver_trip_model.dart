import 'package:fast_golden_taxi/features/driver/driver_home/domain/entities/driver_trip.dart';

/// Model for driver trip
class DriverTripModel extends DriverTrip {
  const DriverTripModel({
    required super.id,
    required super.passengerName,
    super.passengerImage,
    required super.pickupLocation,
    required super.dropoffLocation,
    required super.distance,
    required super.fare,
    required super.status,
    required super.startTime,
    super.endTime,
    super.rating,
    super.ratingComment,
    required super.paymentMethod,
    required super.duration,
  });

  factory DriverTripModel.fromJson(Map<String, dynamic> json) {
    return DriverTripModel(
      id: json['id'] ?? '',
      passengerName: json['passengerName'] ?? '',
      passengerImage: json['passengerImage'],
      pickupLocation: json['pickupLocation'] ?? '',
      dropoffLocation: json['dropoffLocation'] ?? '',
      distance: (json['distance'] ?? 0).toDouble(),
      fare: (json['fare'] ?? 0).toDouble(),
      status: json['status'] ?? 'completed',
      startTime: DateTime.parse(
        json['startTime'] ?? DateTime.now().toIso8601String(),
      ),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      rating: json['rating']?.toDouble(),
      ratingComment: json['ratingComment'],
      paymentMethod: json['paymentMethod'] ?? 'cash',
      duration: (json['duration'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'passengerName': passengerName,
      'passengerImage': passengerImage,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'distance': distance,
      'fare': fare,
      'status': status,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'rating': rating,
      'ratingComment': ratingComment,
      'paymentMethod': paymentMethod,
      'duration': duration,
    };
  }
}
