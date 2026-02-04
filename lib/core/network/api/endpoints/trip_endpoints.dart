/// Trip API Endpoints
/// Contains all trip-related API endpoint paths
class TripEndpoints {
  TripEndpoints._();

  /// Get types trips by location endpoint
  /// GET /api/user/trip/types-by-location
  static const String typesByLocation = '/api/user/trip/types-by-location';

  /// Captain trip detail by trip id endpoint
  /// GET /api/user/trip/captain-detail
  static const String captainDetail = '/api/user/trip/captain-detail';

  /// Store public trip endpoint
  /// POST /api/user/trip/store-public
  static const String storePublic = '/api/user/trip/store-public';

  /// Store private trip endpoint
  /// POST /api/user/trip/store-private
  static const String storePrivate = '/api/user/trip/store-private';

  /// Edit private trip endpoint
  /// PUT /api/user/trip/edit-private
  static const String editPrivate = '/api/user/trip/edit-private';

  /// Book now order endpoint
  /// POST /api/user/trip/book-now
  static const String bookNow = '/api/user/trip/book-now';

  /// Trip history endpoint
  /// GET /api/user/trip/history
  static const String history = '/api/user/trip/history';

  /// My orders endpoint
  /// GET /api/user/trip/my-orders
  static const String myOrders = '/api/user/trip/my-orders';

  /// Available public trips endpoint
  /// GET /api/user/trip/available-public
  static const String availablePublic = '/api/user/trip/available-public';

  /// Confirm trip endpoint
  /// POST /api/user/trip/confirm
  static const String confirm = '/api/user/trip/confirm';

  /// Cancel trip endpoint
  /// POST /api/user/trip/cancel
  static const String cancel = '/api/user/trip/cancel';

  /// Report trip endpoint
  /// POST /api/user/trip/report
  static const String report = '/api/user/trip/report';

  /// Trip evaluation endpoint
  /// POST /api/user/trip/evaluation
  static const String evaluation = '/api/user/trip/evaluation';

  /// Trip detail endpoint
  /// GET /api/user/trip/detail
  static const String detail = '/api/user/trip/detail';
}
