/// Parameters for responding to a review
class RespondToReviewParams {
  final String reviewId;
  final String response;

  RespondToReviewParams({required this.reviewId, required this.response});

  Map<String, dynamic> toJson() {
    return {'reviewId': reviewId, 'response': response};
  }
}
