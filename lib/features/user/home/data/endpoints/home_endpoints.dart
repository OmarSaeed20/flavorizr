// lib/features/home/data/endpoints/home_endpoints.dart
/// Defines all API endpoints for home page operations.
abstract class HomeEndpoints {
  const HomeEndpoints._();

  /// Gets home page data including banners, advertisements, and featured trips.
  static const String homeData = '/user/trip/home';

  /// Gets all banners.
  static const String banners = '/user/banner';

  /// Gets all advertisements.
  static const String advertisements = '/user/advertisement';

  /// Gets available trips based on location and filters.
  static const String availableTrips = '/user/trip/available';

  /// Gets notification count.
  static const String notificationCount = '/user/notification/count';

  /// Gets featured trips.
  static const String featuredTrips = '/user/trip/featured';

  /// Gets recent trips.
  static const String recentTrips = '/user/trip/recent';
}
