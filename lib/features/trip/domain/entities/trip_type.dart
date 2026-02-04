// lib/features/trip/domain/entities/trip_type.dart


/// Represents a trip type in the domain layer.
///
/// Trip types define different categories of trips (e.g., economy, premium, etc.)
/// with their associated pricing and features.
class TripType {
  /// Creates a new [TripType] instance.
  const TripType({
    required this.id,
    required this.name,
    required this.basePrice,
    required this.pricePerKm,
    required this.pricePerMinute,
    this.description,
    this.icon,
    this.imageUrl,
    this.capacity = 4,
    this.features = const [],
    this.isActive = true,
    this.currency = 'USD',
    this.metadata = const {},
  });

  /// Creates a trip type from a map.
  factory TripType.fromMap(Map<String, dynamic> map) {
    return TripType(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      icon: map['icon'] as String?,
      imageUrl: map['imageUrl'] as String?,
      basePrice: (map['basePrice'] as num).toDouble(),
      pricePerKm: (map['pricePerKm'] as num).toDouble(),
      pricePerMinute: (map['pricePerMinute'] as num).toDouble(),
      capacity: map['capacity'] as int? ?? 4,
      features: List<String>.from(map['features'] as List? ?? []),
      isActive: map['isActive'] as bool? ?? true,
      currency: map['currency'] as String? ?? 'USD',
      metadata: Map<String, dynamic>.from(map['metadata'] as Map? ?? {}),
    );
  }

  /// Unique identifier for the trip type.
  final String id;

  /// Trip type name (e.g., "Economy", "Premium").
  final String name;

  /// Description of the trip type.
  final String? description;

  /// Icon identifier.
  final String? icon;

  /// Image URL for the trip type.
  final String? imageUrl;

  /// Base price for the trip.
  final double basePrice;

  /// Price per kilometer.
  final double pricePerKm;

  /// Price per minute.
  final double pricePerMinute;

  /// Maximum passenger capacity.
  final int capacity;

  /// List of features (e.g., "AC", "WiFi", "Pet Friendly").
  final List<String> features;

  /// Whether this trip type is active.
  final bool isActive;

  /// Currency code.
  final String currency;

  /// Additional metadata.
  final Map<String, dynamic> metadata;

  /// Converts to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'imageUrl': imageUrl,
      'basePrice': basePrice,
      'pricePerKm': pricePerKm,
      'pricePerMinute': pricePerMinute,
      'capacity': capacity,
      'features': features,
      'isActive': isActive,
      'currency': currency,
      'metadata': metadata,
    };
  }

  /// Creates a copy with modified fields.
  TripType copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? imageUrl,
    double? basePrice,
    double? pricePerKm,
    double? pricePerMinute,
    int? capacity,
    List<String>? features,
    bool? isActive,
    String? currency,
    Map<String, dynamic>? metadata,
  }) {
    return TripType(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
      basePrice: basePrice ?? this.basePrice,
      pricePerKm: pricePerKm ?? this.pricePerKm,
      pricePerMinute: pricePerMinute ?? this.pricePerMinute,
      capacity: capacity ?? this.capacity,
      features: features ?? this.features,
      isActive: isActive ?? this.isActive,
      currency: currency ?? this.currency,
      metadata: metadata ?? this.metadata,
    );
  }
}