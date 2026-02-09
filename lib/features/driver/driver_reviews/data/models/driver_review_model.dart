import 'package:fast_golden_taxi/features/driver/driver_reviews/domain/entities/driver_review.dart';

/// Model for driver review
class DriverReviewModel extends DriverReview {
  const DriverReviewModel({
    required super.id,
    required super.driverId,
    required super.passengerId,
    required super.passengerName,
    super.passengerAvatar,
    required super.rating,
    required super.comment,
    required super.createdAt,
    super.response,
    super.respondedAt,
    required super.tripId,
    super.tripDetails,
  });

  factory DriverReviewModel.fromJson(Map<String, dynamic> json) {
    return DriverReviewModel(
      id: json['id'] as String,
      driverId: json['driverId'] as String,
      passengerId: json['passengerId'] as String,
      passengerName: json['passengerName'] as String,
      passengerAvatar: json['passengerAvatar'] as String?,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      response: json['response'] as String?,
      respondedAt: json['respondedAt'] != null
          ? DateTime.parse(json['respondedAt'] as String)
          : null,
      tripId: json['tripId'] as String,
      tripDetails: json['tripDetails'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'passengerId': passengerId,
      'passengerName': passengerName,
      'passengerAvatar': passengerAvatar,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'response': response,
      'respondedAt': respondedAt?.toIso8601String(),
      'tripId': tripId,
      'tripDetails': tripDetails,
    };
  }

  DriverReview toEntity() {
    return DriverReview(
      id: id,
      driverId: driverId,
      passengerId: passengerId,
      passengerName: passengerName,
      passengerAvatar: passengerAvatar,
      rating: rating,
      comment: comment,
      createdAt: createdAt,
      response: response,
      respondedAt: respondedAt,
      tripId: tripId,
      tripDetails: tripDetails,
    );
  }

  factory DriverReviewModel.fromEntity(DriverReview entity) {
    return DriverReviewModel(
      id: entity.id,
      driverId: entity.driverId,
      passengerId: entity.passengerId,
      passengerName: entity.passengerName,
      passengerAvatar: entity.passengerAvatar,
      rating: entity.rating,
      comment: entity.comment,
      createdAt: entity.createdAt,
      response: entity.response,
      respondedAt: entity.respondedAt,
      tripId: entity.tripId,
      tripDetails: entity.tripDetails,
    );
  }
}
