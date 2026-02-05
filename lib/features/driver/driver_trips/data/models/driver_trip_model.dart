import 'package:flavorizr/features/driver/driver_trips/data/models/trip_route_model.dart';
import 'package:flavorizr/features/driver/driver_trips/domain/entities/driver_trip.dart';
import 'package:flavorizr/features/driver/driver_trips/domain/entities/trip_route.dart';

/// Model for driver trip
class DriverTripModel extends DriverTrip {
  const DriverTripModel({
    required String id,
    required String passengerId,
    required String passengerName,
    String? passengerImage,
    required String passengerPhone,
    required TripRoute route,
    required double estimatedFare,
    required double actualFare,
    required String status,
    required DateTime createdAt,
    DateTime? acceptedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    required String paymentMethod,
    double? rating,
    String? ratingComment,
    required String vehicleType,
    required int passengerCount,
    String? specialRequests,
  }) : super(
         id: id,
         passengerId: passengerId,
         passengerName: passengerName,
         passengerImage: passengerImage,
         passengerPhone: passengerPhone,
         route: route,
         estimatedFare: estimatedFare,
         actualFare: actualFare,
         status: status,
         createdAt: createdAt,
         acceptedAt: acceptedAt,
         startedAt: startedAt,
         completedAt: completedAt,
         cancelledAt: cancelledAt,
         cancellationReason: cancellationReason,
         paymentMethod: paymentMethod,
         rating: rating,
         ratingComment: ratingComment,
         vehicleType: vehicleType,
         passengerCount: passengerCount,
         specialRequests: specialRequests,
       );

  factory DriverTripModel.fromJson(Map<String, dynamic> json) {
    return DriverTripModel(
      id: json['id'] ?? '',
      passengerId: json['passengerId'] ?? '',
      passengerName: json['passengerName'] ?? '',
      passengerImage: json['passengerImage'],
      passengerPhone: json['passengerPhone'] ?? '',
      route: TripRouteModel.fromJson(json['route'] ?? {}),
      estimatedFare: (json['estimatedFare'] ?? 0).toDouble(),
      actualFare: (json['actualFare'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      acceptedAt: json['acceptedAt'] != null ? DateTime.parse(json['acceptedAt']) : null,
      startedAt: json['startedAt'] != null ? DateTime.parse(json['startedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      cancelledAt: json['cancelledAt'] != null ? DateTime.parse(json['cancelledAt']) : null,
      cancellationReason: json['cancellationReason'],
      paymentMethod: json['paymentMethod'] ?? 'cash',
      rating: json['rating']?.toDouble(),
      ratingComment: json['ratingComment'],
      vehicleType: json['vehicleType'] ?? 'standard',
      passengerCount: json['passengerCount'] ?? 1,
      specialRequests: json['specialRequests'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'passengerId': passengerId,
      'passengerName': passengerName,
      'passengerImage': passengerImage,
      'passengerPhone': passengerPhone,
      'route': (route as TripRouteModel).toJson(),
      'estimatedFare': estimatedFare,
      'actualFare': actualFare,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'cancellationReason': cancellationReason,
      'paymentMethod': paymentMethod,
      'rating': rating,
      'ratingComment': ratingComment,
      'vehicleType': vehicleType,
      'passengerCount': passengerCount,
      'specialRequests': specialRequests,
    };
  }
}
