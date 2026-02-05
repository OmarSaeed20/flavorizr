// lib/features/trip/domain/entities/trip_evaluation.dart

/// Represents a trip evaluation in the domain layer.
///
/// Trip evaluations allow users to rate and review their trips.
class TripEvaluation {
  /// Creates a new [TripEvaluation] instance.
  const TripEvaluation({
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

  /// Creates a trip evaluation from a map.
  factory TripEvaluation.fromMap(Map<String, dynamic> map) {
    return TripEvaluation(
      id: map['id'] as String,
      tripId: map['tripId'] as String,
      userId: map['userId'] as String,
      captainId: map['captainId'] as String?,
      rating: (map['rating'] as num).toInt(),
      comment: map['comment'] as String?,
      categories: map['categories'] != null
          ? EvaluationCategories.fromMap(
              map['categories'] as Map<String, dynamic>,
            )
          : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      metadata: Map<String, dynamic>.from(map['metadata'] as Map? ?? {}),
    );
  }

  /// Unique identifier for the evaluation.
  final String id;

  /// Associated trip ID.
  final String tripId;

  /// User ID who created the evaluation.
  final String userId;

  /// Captain ID being evaluated.
  final String? captainId;

  /// Overall rating (1-5).
  final int rating;

  /// User comment.
  final String? comment;

  /// Category ratings.
  final EvaluationCategories? categories;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Additional metadata.
  final Map<String, dynamic> metadata;

  /// Converts to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripId': tripId,
      'userId': userId,
      'captainId': captainId,
      'rating': rating,
      'comment': comment,
      'categories': categories?.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Creates a copy with modified fields.
  TripEvaluation copyWith({
    String? id,
    String? tripId,
    String? userId,
    String? captainId,
    int? rating,
    String? comment,
    EvaluationCategories? categories,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return TripEvaluation(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      userId: userId ?? this.userId,
      captainId: captainId ?? this.captainId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      categories: categories ?? this.categories,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Evaluation categories for detailed ratings.
class EvaluationCategories {
  const EvaluationCategories({
    this.cleanliness,
    this.punctuality,
    this.driving,
    this.attitude,
    this.vehicle,
  });

  factory EvaluationCategories.fromMap(Map<String, dynamic> map) {
    return EvaluationCategories(
      cleanliness: (map['cleanliness'] as num?)?.toInt(),
      punctuality: (map['punctuality'] as num?)?.toInt(),
      driving: (map['driving'] as num?)?.toInt(),
      attitude: (map['attitude'] as num?)?.toInt(),
      vehicle: (map['vehicle'] as num?)?.toInt(),
    );
  }

  /// Cleanliness rating (1-5).
  final int? cleanliness;

  /// Punctuality rating (1-5).
  final int? punctuality;

  /// Driving skill rating (1-5).
  final int? driving;

  /// Attitude rating (1-5).
  final int? attitude;

  /// Vehicle condition rating (1-5).
  final int? vehicle;

  Map<String, dynamic> toMap() {
    return {
      'cleanliness': cleanliness,
      'punctuality': punctuality,
      'driving': driving,
      'attitude': attitude,
      'vehicle': vehicle,
    };
  }

  EvaluationCategories copyWith({
    int? cleanliness,
    int? punctuality,
    int? driving,
    int? attitude,
    int? vehicle,
  }) {
    return EvaluationCategories(
      cleanliness: cleanliness ?? this.cleanliness,
      punctuality: punctuality ?? this.punctuality,
      driving: driving ?? this.driving,
      attitude: attitude ?? this.attitude,
      vehicle: vehicle ?? this.vehicle,
    );
  }
}
