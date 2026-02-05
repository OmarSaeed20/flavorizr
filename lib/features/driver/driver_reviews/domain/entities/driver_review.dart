import 'package:equatable/equatable.dart';

/// Represents a driver review entity
class DriverReview extends Equatable {
  final String id;
  final String driverId;
  final String passengerId;
  final String passengerName;
  final String? passengerAvatar;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final String? response;
  final DateTime? respondedAt;
  final String tripId;
  final String? tripDetails;

  const DriverReview({
    required this.id,
    required this.driverId,
    required this.passengerId,
    required this.passengerName,
    this.passengerAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.response,
    this.respondedAt,
    required this.tripId,
    this.tripDetails,
  });

  @override
  List<Object?> get props => [
    id,
    driverId,
    passengerId,
    passengerName,
    passengerAvatar,
    rating,
    comment,
    createdAt,
    response,
    respondedAt,
    tripId,
    tripDetails,
  ];

  DriverReview copyWith({
    String? id,
    String? driverId,
    String? passengerId,
    String? passengerName,
    String? passengerAvatar,
    int? rating,
    String? comment,
    DateTime? createdAt,
    String? response,
    DateTime? respondedAt,
    String? tripId,
    String? tripDetails,
  }) {
    return DriverReview(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      passengerId: passengerId ?? this.passengerId,
      passengerName: passengerName ?? this.passengerName,
      passengerAvatar: passengerAvatar ?? this.passengerAvatar,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      response: response ?? this.response,
      respondedAt: respondedAt ?? this.respondedAt,
      tripId: tripId ?? this.tripId,
      tripDetails: tripDetails ?? this.tripDetails,
    );
  }
}
