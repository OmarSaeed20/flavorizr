// lib/features/driver_reviews/data/endpoints/driver_reviews_endpoints.dart
/// Defines all API endpoints for driver reviews operations.
abstract class DriverReviewsEndpoints {
  const DriverReviewsEndpoints._();

  /// Gets all reviews for a driver.
  static const String reviews = '/driver/reviews';

  /// Gets a specific review by ID.
  static String reviewById(String reviewId) => '/driver/reviews/$reviewId';

  /// Gets review statistics for a driver.
  static const String reviewStats = '/driver/reviews/stats';

  /// Responds to a review.
  static const String respondToReview = '/driver/reviews/respond';

  /// Reports a review.
  static String reportReview(String reviewId) => '/driver/reviews/$reviewId/report';

  /// Gets reviews for a specific trip.
  static String tripReviews(String tripId) => '/driver/reviews/trip/$tripId';

  /// Gets recent reviews.
  static const String recentReviews = '/driver/reviews/recent';

  /// Gets reviews with pagination.
  static const String paginatedReviews = '/driver/reviews/paginated';
}
