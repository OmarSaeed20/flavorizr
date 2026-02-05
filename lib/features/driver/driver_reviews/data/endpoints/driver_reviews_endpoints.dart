/// Defines all API endpoints for driver reviews operations.
///
/// All endpoints are based on the FAST App API documentation.
/// Base URL: https://fasttaxi.questifysolutions.com/api/v1
abstract class DriverReviewsEndpoints {
  const DriverReviewsEndpoints._();

  /// Get reviews for a specific driver.
  /// Endpoint: GET /user/driver/reviews
  static const String getReviews = '/user/driver/reviews';
}
