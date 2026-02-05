import 'package:equatable/equatable.dart';

/// Represents driver review statistics
class ReviewStats extends Equatable {
  final double averageRating;
  final int totalReviews;
  final int fiveStarCount;
  final int fourStarCount;
  final int threeStarCount;
  final int twoStarCount;
  final int oneStarCount;
  final int respondedCount;
  final int pendingResponseCount;
  final DateTime? lastReviewDate;

  const ReviewStats({
    required this.averageRating,
    required this.totalReviews,
    required this.fiveStarCount,
    required this.fourStarCount,
    required this.threeStarCount,
    required this.twoStarCount,
    required this.oneStarCount,
    required this.respondedCount,
    required this.pendingResponseCount,
    this.lastReviewDate,
  });

  @override
  List<Object?> get props => [
        averageRating,
        totalReviews,
        fiveStarCount,
        fourStarCount,
        threeStarCount,
        twoStarCount,
        oneStarCount,
        respondedCount,
        pendingResponseCount,
        lastReviewDate,
      ];

  ReviewStats copyWith({
    double? averageRating,
    int? totalReviews,
    int? fiveStarCount,
    int? fourStarCount,
    int? threeStarCount,
    int? twoStarCount,
    int? oneStarCount,
    int? respondedCount,
    int? pendingResponseCount,
    DateTime? lastReviewDate,
  }) {
    return ReviewStats(
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      fiveStarCount: fiveStarCount ?? this.fiveStarCount,
      fourStarCount: fourStarCount ?? this.fourStarCount,
      threeStarCount: threeStarCount ?? this.threeStarCount,
      twoStarCount: twoStarCount ?? this.twoStarCount,
      oneStarCount: oneStarCount ?? this.oneStarCount,
      respondedCount: respondedCount ?? this.respondedCount,
      pendingResponseCount: pendingResponseCount ?? this.pendingResponseCount,
      lastReviewDate: lastReviewDate ?? this.lastReviewDate,
    );
  }
}