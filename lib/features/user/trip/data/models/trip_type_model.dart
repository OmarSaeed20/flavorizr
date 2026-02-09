// lib/features/trip/data/models/trip_type_model.dart
import 'package:fast_golden_taxi/features/user/trip/domain/entities/trip_type.dart';

/// Data model for TripType, used for JSON serialization.
///
/// This model handles the conversion between API JSON
/// and the domain TripType entity.
class TripTypeModel {
  const TripTypeModel({
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

  /// Creates a model from JSON.
  factory TripTypeModel.fromJson(Map<String, dynamic> json) {
    return TripTypeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
      basePrice: (json['base_price'] as num).toDouble(),
      pricePerKm: (json['price_per_km'] as num).toDouble(),
      pricePerMinute: (json['price_per_minute'] as num).toDouble(),
      capacity: json['capacity'] as int? ?? 4,
      features: List<String>.from(json['features'] as List? ?? []),
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool? ?? true,
      currency: json['currency'] as String? ?? 'USD',
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    );
  }

  /// Creates a model from a domain entity.
  factory TripTypeModel.fromEntity(TripType entity) {
    return TripTypeModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      icon: entity.icon,
      imageUrl: entity.imageUrl,
      basePrice: entity.basePrice,
      pricePerKm: entity.pricePerKm,
      pricePerMinute: entity.pricePerMinute,
      capacity: entity.capacity,
      features: entity.features,
      isActive: entity.isActive,
      currency: entity.currency,
      metadata: entity.metadata,
    );
  }

  final String id;
  final String name;
  final String? description;
  final String? icon;
  final String? imageUrl;
  final double basePrice;
  final double pricePerKm;
  final double pricePerMinute;
  final int capacity;
  final List<String> features;
  final bool isActive;
  final String currency;
  final Map<String, dynamic> metadata;

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'image_url': imageUrl,
      'base_price': basePrice,
      'price_per_km': pricePerKm,
      'price_per_minute': pricePerMinute,
      'capacity': capacity,
      'features': features,
      'is_active': isActive,
      'currency': currency,
      'metadata': metadata,
    };
  }

  /// Converts to a domain entity.
  TripType toEntity() {
    return TripType(
      id: id,
      name: name,
      description: description,
      icon: icon,
      imageUrl: imageUrl,
      basePrice: basePrice,
      pricePerKm: pricePerKm,
      pricePerMinute: pricePerMinute,
      capacity: capacity,
      features: features,
      isActive: isActive,
      currency: currency,
      metadata: metadata,
    );
  }
}
