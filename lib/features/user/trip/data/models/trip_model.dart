// lib/features/trip/data/models/trip_model.dart
import 'package:fast_golden_taxi/features/user/trip/domain/entities/trip.dart';

/// Data model for Trip, used for JSON serialization.
///
/// This model handles the conversion between API JSON
/// and the domain Trip entity.
class TripModel {
  const TripModel({
    required this.id,
    required this.tripTypeId,
    required this.origin,
    required this.destination,
    required this.createdAt,
    this.userId,
    this.captainId,
    this.status = TripStatus.pending,
    this.tripType,
    this.scheduledAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.distance,
    this.duration,
    this.price,
    this.currency = 'USD',
    this.passengerCount = 1,
    this.notes,
    this.metadata = const {},
  });

  /// Creates a model from JSON.
  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? json['userId'] as String?,
      captainId: json['captain_id'] as String? ?? json['captainId'] as String?,
      tripTypeId:
          json['trip_type_id'] as String? ?? json['tripTypeId'] as String,
      tripType: json['trip_type'] as String? ?? json['tripType'] as String?,
      status: TripStatus.fromString(json['status'] as String? ?? 'pending'),
      origin: TripLocationModel.fromJson(
        json['origin'] as Map<String, dynamic>,
      ),
      destination: TripLocationModel.fromJson(
        json['destination'] as Map<String, dynamic>,
      ),
      scheduledAt: json['scheduled_at'] != null
          ? DateTime.parse(json['scheduled_at'] as String)
          : json['scheduledAt'] != null
          ? DateTime.parse(json['scheduledAt'] as String)
          : null,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'] as String)
          : json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      distance: (json['distance'] as num?)?.toDouble(),
      duration: json['duration'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      passengerCount:
          json['passenger_count'] as int? ??
          json['passengerCount'] as int? ??
          1,
      notes: json['notes'] as String?,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    );
  }

  /// Creates a model from a domain entity.
  factory TripModel.fromEntity(Trip entity) {
    return TripModel(
      id: entity.id,
      userId: entity.userId,
      captainId: entity.captainId,
      tripTypeId: entity.tripTypeId,
      tripType: entity.tripType,
      status: entity.status,
      origin: TripLocationModel.fromEntity(entity.origin),
      destination: TripLocationModel.fromEntity(entity.destination),
      scheduledAt: entity.scheduledAt,
      startedAt: entity.startedAt,
      completedAt: entity.completedAt,
      cancelledAt: entity.cancelledAt,
      createdAt: entity.createdAt,
      distance: entity.distance,
      duration: entity.duration,
      price: entity.price,
      currency: entity.currency,
      passengerCount: entity.passengerCount,
      notes: entity.notes,
      metadata: entity.metadata,
    );
  }

  final String id;
  final String? userId;
  final String? captainId;
  final String tripTypeId;
  final String? tripType;
  final TripStatus status;
  final TripLocationModel origin;
  final TripLocationModel destination;
  final DateTime? scheduledAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final DateTime createdAt;
  final double? distance;
  final int? duration;
  final double? price;
  final String currency;
  final int passengerCount;
  final String? notes;
  final Map<String, dynamic> metadata;

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'captain_id': captainId,
      'trip_type_id': tripTypeId,
      'trip_type': tripType,
      'status': status.value,
      'origin': origin.toJson(),
      'destination': destination.toJson(),
      'scheduled_at': scheduledAt?.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'distance': distance,
      'duration': duration,
      'price': price,
      'currency': currency,
      'passenger_count': passengerCount,
      'notes': notes,
      'metadata': metadata,
    };
  }

  /// Converts to a domain entity.
  Trip toEntity() {
    return Trip(
      id: id,
      userId: userId,
      captainId: captainId,
      tripTypeId: tripTypeId,
      tripType: tripType,
      status: status,
      origin: origin.toEntity(),
      destination: destination.toEntity(),
      scheduledAt: scheduledAt,
      startedAt: startedAt,
      completedAt: completedAt,
      cancelledAt: cancelledAt,
      createdAt: createdAt,
      distance: distance,
      duration: duration,
      price: price,
      currency: currency,
      passengerCount: passengerCount,
      notes: notes,
      metadata: metadata,
    );
  }
}

/// Data model for TripLocation.
class TripLocationModel {
  const TripLocationModel({
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.country,
    this.placeId,
  });

  factory TripLocationModel.fromJson(Map<String, dynamic> json) {
    return TripLocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      placeId: json['place_id'] as String? ?? json['placeId'] as String?,
    );
  }

  factory TripLocationModel.fromEntity(TripLocation entity) {
    return TripLocationModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
      city: entity.city,
      country: entity.country,
      placeId: entity.placeId,
    );
  }

  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? country;
  final String? placeId;

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'country': country,
      'place_id': placeId,
    };
  }

  TripLocation toEntity() {
    return TripLocation(
      latitude: latitude,
      longitude: longitude,
      address: address,
      city: city,
      country: country,
      placeId: placeId,
    );
  }
}
