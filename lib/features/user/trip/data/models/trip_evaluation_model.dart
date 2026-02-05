// lib/features/trip/data/models/trip_evaluation_model.dart
import 'package:flavorizr/features/user/trip/domain/entities/trip_evaluation.dart';

/// Data model for TripEvaluation, used for JSON serialization.
///
/// This model handles the conversion between API JSON
/// and the domain TripEvaluation entity.
class TripEvaluationModel {
  const TripEvaluationModel({
    required this.id,
    required this.tripId,
    required this.userId,
    required this.rating,
    required this.createdAt,
    this.captainId,
    this.comment,
    this.categories,
    this.metadata = const {},
  });

  /// Creates a model from JSON.
  factory TripEvaluationModel.fromJson(Map<String, dynamic> json) {
    return TripEvaluationModel(
      id: json['id'] as String,
      tripId: json['trip_id'] as String? ?? json['tripId'] as String,
      userId: json['user_id'] as String? ?? json['userId'] as String,
      captainId: json['captain_id'] as String? ?? json['captainId'] as String?,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
      categories: json['categories'] != null
          ? EvaluationCategoriesModel.fromJson(json['categories'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    );
  }

  /// Creates a model from a domain entity.
  factory TripEvaluationModel.fromEntity(TripEvaluation entity) {
    return TripEvaluationModel(
      id: entity.id,
      tripId: entity.tripId,
      userId: entity.userId,
      captainId: entity.captainId,
      rating: entity.rating,
      comment: entity.comment,
      categories: entity.categories != null
          ? EvaluationCategoriesModel.fromEntity(entity.categories!)
          : null,
      createdAt: entity.createdAt,
      metadata: entity.metadata,
    );
  }

  final String id;
  final String tripId;
  final String userId;
  final String? captainId;
  final int rating;
  final String? comment;
  final EvaluationCategoriesModel? categories;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trip_id': tripId,
      'user_id': userId,
      'captain_id': captainId,
      'rating': rating,
      'comment': comment,
      'categories': categories?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Converts to a domain entity.
  TripEvaluation toEntity() {
    return TripEvaluation(
      id: id,
      tripId: tripId,
      userId: userId,
      captainId: captainId,
      rating: rating,
      comment: comment,
      categories: categories?.toEntity(),
      createdAt: createdAt,
      metadata: metadata,
    );
  }
}

/// Data model for EvaluationCategories.
class EvaluationCategoriesModel {
  const EvaluationCategoriesModel({
    this.cleanliness,
    this.punctuality,
    this.driving,
    this.attitude,
    this.vehicle,
  });

  factory EvaluationCategoriesModel.fromJson(Map<String, dynamic> json) {
    return EvaluationCategoriesModel(
      cleanliness: (json['cleanliness'] as num?)?.toInt(),
      punctuality: (json['punctuality'] as num?)?.toInt(),
      driving: (json['driving'] as num?)?.toInt(),
      attitude: (json['attitude'] as num?)?.toInt(),
      vehicle: (json['vehicle'] as num?)?.toInt(),
    );
  }

  factory EvaluationCategoriesModel.fromEntity(EvaluationCategories entity) {
    return EvaluationCategoriesModel(
      cleanliness: entity.cleanliness,
      punctuality: entity.punctuality,
      driving: entity.driving,
      attitude: entity.attitude,
      vehicle: entity.vehicle,
    );
  }

  final int? cleanliness;
  final int? punctuality;
  final int? driving;
  final int? attitude;
  final int? vehicle;

  Map<String, dynamic> toJson() {
    return {
      'cleanliness': cleanliness,
      'punctuality': punctuality,
      'driving': driving,
      'attitude': attitude,
      'vehicle': vehicle,
    };
  }

  EvaluationCategories toEntity() {
    return EvaluationCategories(
      cleanliness: cleanliness,
      punctuality: punctuality,
      driving: driving,
      attitude: attitude,
      vehicle: vehicle,
    );
  }
}
