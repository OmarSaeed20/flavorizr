// lib/features/trip/domain/entities/trip.dart


/// Represents a trip in the domain layer.
///
/// This entity contains all trip-related information that the app
/// needs to function. Properties are immutable to ensure data consistency.
class Trip {
  /// Creates a new [Trip] instance.
  const Trip({
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

  /// Creates a trip from a map.
  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'] as String,
      userId: map['userId'] as String?,
      captainId: map['captainId'] as String?,
      tripTypeId: map['tripTypeId'] as String,
      tripType: map['tripType'] as String?,
      status: TripStatus.fromString(map['status'] as String? ?? 'pending'),
      origin: TripLocation.fromMap(map['origin'] as Map<String, dynamic>),
      destination: TripLocation.fromMap(map['destination'] as Map<String, dynamic>),
      scheduledAt: map['scheduledAt'] != null
          ? DateTime.parse(map['scheduledAt'] as String)
          : null,
      startedAt: map['startedAt'] != null
          ? DateTime.parse(map['startedAt'] as String)
          : null,
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'] as String)
          : null,
      cancelledAt: map['cancelledAt'] != null
          ? DateTime.parse(map['cancelledAt'] as String)
          : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      distance: (map['distance'] as num?)?.toDouble(),
      duration: map['duration'] as int?,
      price: (map['price'] as num?)?.toDouble(),
      currency: map['currency'] as String? ?? 'USD',
      passengerCount: map['passengerCount'] as int? ?? 1,
      notes: map['notes'] as String?,
      metadata: Map<String, dynamic>.from(map['metadata'] as Map? ?? {}),
    );
  }

  /// Unique identifier for the trip.
  final String id;

  /// User ID who created the trip.
  final String? userId;

  /// Captain ID assigned to the trip.
  final String? captainId;

  /// Trip type ID.
  final String tripTypeId;

  /// Trip type name.
  final String? tripType;

  /// Current status of the trip.
  final TripStatus status;

  /// Origin location.
  final TripLocation origin;

  /// Destination location.
  final TripLocation destination;

  /// Scheduled departure time.
  final DateTime? scheduledAt;

  /// Actual start time.
  final DateTime? startedAt;

  /// Completion time.
  final DateTime? completedAt;

  /// Cancellation time.
  final DateTime? cancelledAt;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Distance in kilometers.
  final double? distance;

  /// Duration in minutes.
  final int? duration;

  /// Trip price.
  final double? price;

  /// Currency code.
  final String currency;

  /// Number of passengers.
  final int passengerCount;

  /// Additional notes.
  final String? notes;

  /// Additional metadata.
  final Map<String, dynamic> metadata;

  /// Converts to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'captainId': captainId,
      'tripTypeId': tripTypeId,
      'tripType': tripType,
      'status': status.value,
      'origin': origin.toMap(),
      'destination': destination.toMap(),
      'scheduledAt': scheduledAt?.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'distance': distance,
      'duration': duration,
      'price': price,
      'currency': currency,
      'passengerCount': passengerCount,
      'notes': notes,
      'metadata': metadata,
    };
  }

  /// Creates a copy with modified fields.
  Trip copyWith({
    String? id,
    String? userId,
    String? captainId,
    String? tripTypeId,
    String? tripType,
    TripStatus? status,
    TripLocation? origin,
    TripLocation? destination,
    DateTime? scheduledAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    DateTime? createdAt,
    double? distance,
    int? duration,
    double? price,
    String? currency,
    int? passengerCount,
    String? notes,
    Map<String, dynamic>? metadata,
  }) {
    return Trip(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      captainId: captainId ?? this.captainId,
      tripTypeId: tripTypeId ?? this.tripTypeId,
      tripType: tripType ?? this.tripType,
      status: status ?? this.status,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      createdAt: createdAt ?? this.createdAt,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      passengerCount: passengerCount ?? this.passengerCount,
      notes: notes ?? this.notes,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Represents a location for a trip.
class TripLocation {
  const TripLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.country,
    this.placeId,
  });

  factory TripLocation.fromMap(Map<String, dynamic> map) {
    return TripLocation(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      address: map['address'] as String?,
      city: map['city'] as String?,
      country: map['country'] as String?,
      placeId: map['placeId'] as String?,
    );
  }

  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? country;
  final String? placeId;

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'country': country,
      'placeId': placeId,
    };
  }

  TripLocation copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? country,
    String? placeId,
  }) {
    return TripLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      placeId: placeId ?? this.placeId,
    );
  }
}

/// Trip status enumeration.
enum TripStatus {
  pending('pending'),
  searching('searching'),
  confirmed('confirmed'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled'),
  failed('failed');

  const TripStatus(this.value);
  final String value;

  static TripStatus fromString(String value) {
    return TripStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TripStatus.pending,
    );
  }
}