import 'package:fast_golden_taxi/features/driver/driver_trips/domain/entities/trip_route.dart';

/// Driver trip entity representing a trip request
class DriverTrip {
  final String id;
  final String passengerId;
  final String passengerName;
  final String? passengerImage;
  final String passengerPhone;
  final TripRoute route;
  final double estimatedFare;
  final double actualFare;
  final String
  status; // pending, accepted, rejected, in_progress, completed, cancelled
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final String paymentMethod;
  final double? rating;
  final String? ratingComment;
  final String vehicleType;
  final int passengerCount;
  final String? specialRequests;

  const DriverTrip({
    required this.id,
    required this.passengerId,
    required this.passengerName,
    this.passengerImage,
    required this.passengerPhone,
    required this.route,
    required this.estimatedFare,
    required this.actualFare,
    required this.status,
    required this.createdAt,
    this.acceptedAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
    required this.paymentMethod,
    this.rating,
    this.ratingComment,
    required this.vehicleType,
    required this.passengerCount,
    this.specialRequests,
  });

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';

  DriverTrip copyWith({
    String? id,
    String? passengerId,
    String? passengerName,
    String? passengerImage,
    String? passengerPhone,
    TripRoute? route,
    double? estimatedFare,
    double? actualFare,
    String? status,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    String? paymentMethod,
    double? rating,
    String? ratingComment,
    String? vehicleType,
    int? passengerCount,
    String? specialRequests,
  }) {
    return DriverTrip(
      id: id ?? this.id,
      passengerId: passengerId ?? this.passengerId,
      passengerName: passengerName ?? this.passengerName,
      passengerImage: passengerImage ?? this.passengerImage,
      passengerPhone: passengerPhone ?? this.passengerPhone,
      route: route ?? this.route,
      estimatedFare: estimatedFare ?? this.estimatedFare,
      actualFare: actualFare ?? this.actualFare,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      rating: rating ?? this.rating,
      ratingComment: ratingComment ?? this.ratingComment,
      vehicleType: vehicleType ?? this.vehicleType,
      passengerCount: passengerCount ?? this.passengerCount,
      specialRequests: specialRequests ?? this.specialRequests,
    );
  }
}
