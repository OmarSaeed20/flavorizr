import 'package:flavorizr/features/driver/driver_reviews/domain/entities/review_stats.dart';

/// Model for review statistics
class ReviewStatsModel extends ReviewStats {
  const ReviewStatsModel({
    required super.averageRating,
    required super.totalReviews,
    required super.fiveStarCount,
    required super.fourStarCount,
    required super.threeStarCount,
    required super.twoStarCount,
    required super.oneStarCount,
    required super.respondedCount,
    required super.pendingResponseCount,
    super.lastReviewDate,
  });

  factory ReviewStatsModel.fromJson(Map<String, dynamic> json) {
    return ReviewStatsModel(
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: json['totalReviews'] as int,
      fiveStarCount: json['fiveStarCount'] as int,
      fourStarCount: json['fourStarCount'] as int,
      threeStarCount: json['threeStarCount'] as int,
      twoStarCount: json['twoStarCount'] as int,
      oneStarCount: json['oneStarCount'] as int,
      respondedCount: json['respondedCount'] as int,
      pendingResponseCount: json['pendingResponseCount'] as int,
      lastReviewDate: json['lastReviewDate'] != null
          ? DateTime.parse(json['lastReviewDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'fiveStarCount': fiveStarCount,
      'fourStarCount': fourStarCount,
      'threeStarCount': threeStarCount,
      'twoStarCount': twoStarCount,
      'oneStarCount': oneStarCount,
      'respondedCount': respondedCount,
      'pendingResponseCount': pendingResponseCount,
      'lastReviewDate': lastReviewDate?.toIso8601String(),
    };
  }

  ReviewStats toEntity() {
    return ReviewStats(
      averageRating: averageRating,
      totalReviews: totalReviews,
      fiveStarCount: fiveStarCount,
      fourStarCount: fourStarCount,
      threeStarCount: threeStarCount,
      twoStarCount: twoStarCount,
      oneStarCount: oneStarCount,
      respondedCount: respondedCount,
      pendingResponseCount: pendingResponseCount,
      lastReviewDate: lastReviewDate,
    );
  }

  factory ReviewStatsModel.fromEntity(ReviewStats entity) {
    return ReviewStatsModel(
      averageRating: entity.averageRating,
      totalReviews: entity.totalReviews,
      fiveStarCount: entity.fiveStarCount,
      fourStarCount: entity.fourStarCount,
      threeStarCount: entity.threeStarCount,
      twoStarCount: entity.twoStarCount,
      oneStarCount: entity.oneStarCount,
      respondedCount: entity.respondedCount,
      pendingResponseCount: entity.pendingResponseCount,
      lastReviewDate: entity.lastReviewDate,
    );
  }
}