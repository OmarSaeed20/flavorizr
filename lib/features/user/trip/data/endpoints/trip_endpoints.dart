// lib/features/trip/data/endpoints/trip_endpoints.dart

/// Trip API Endpoints
/// Defines all trip-related API endpoint paths
class TripEndpoints {
  // Base path for trip endpoints
  static const String _basePath = '/user/trip';

  /// Get trip types by location
  /// GET /user/trip/types
  static const String getTripTypes = '$_basePath/types';

  /// Get trip details
  /// GET /user/trip/detail
  static const String getTripDetail = '$_basePath/detail';

  /// Get captain's trip details
  /// GET /user/trip/captain/detail
  static const String getCaptainTripDetail = '$_basePath/captain/detail';

  /// Get trip history
  /// GET /user/trip/history
  static const String getTripHistory = '$_basePath/history';

  /// Get available public trips
  /// GET /user/trip/public/available
  static const String getAvailablePublicTrips = '$_basePath/public/available';

  /// Create a public trip
  /// POST /user/trip/public/store
  static const String storePublicTrip = '$_basePath/public/store';

  /// Create a private trip
  /// POST /user/trip/private/store
  static const String storePrivateTrip = '$_basePath/private/store';

  /// Edit a private trip
  /// POST /user/trip/private/edit
  static const String editPrivateTrip = '$_basePath/private/edit';

  /// Confirm a trip
  /// POST /user/trip/confirm
  static const String confirmTrip = '$_basePath/confirm';

  /// Cancel a trip
  /// POST /user/trip/cancel
  static const String cancelTrip = '$_basePath/cancel';

  /// Report a trip
  /// POST /user/trip/report
  static const String reportTrip = '$_basePath/report';

  /// Evaluate a trip
  /// GET /user/trip/evaluation
  static const String tripEvaluation = '$_basePath/evaluation';

  /// Book a trip now
  /// POST /user/trip/book-now
  static const String bookNowOrder = '$_basePath/book-now';

  /// Get user's orders
  /// GET /user/orders
  static const String getMyOrders = '/user/orders';
}
