/// Parameters for responding to a review.
class RespondToReviewParameters {
  const RespondToReviewParameters({required this.reviewId, required this.response});

  final String reviewId;
  final String response;

  Map<String, dynamic> toJson() {
    return {'review_id': reviewId, 'response': response};
  }

  RespondToReviewParameters copyWith({String? reviewId, String? response}) {
    return RespondToReviewParameters(
      reviewId: reviewId ?? this.reviewId,
      response: response ?? this.response,
    );
  }
}
