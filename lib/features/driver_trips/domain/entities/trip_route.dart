/// Trip route entity containing route information
class TripRoute {
  final String pickupLocation;
  final double pickupLatitude;
  final double pickupLongitude;
  final String dropoffLocation;
  final double dropoffLatitude;
  final double dropoffLongitude;
  final double distance; // in km
  final double duration; // in minutes
  final List<RoutePoint>? waypoints;

  const TripRoute({
    required this.pickupLocation,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffLocation,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    required this.distance,
    required this.duration,
    this.waypoints,
  });

  TripRoute copyWith({
    String? pickupLocation,
    double? pickupLatitude,
    double? pickupLongitude,
    String? dropoffLocation,
    double? dropoffLatitude,
    double? dropoffLongitude,
    double? distance,
    double? duration,
    List<RoutePoint>? waypoints,
  }) {
    return TripRoute(
      pickupLocation: pickupLocation ?? this.pickupLocation,
      pickupLatitude: pickupLatitude ?? this.pickupLatitude,
      pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      dropoffLatitude: dropoffLatitude ?? this.dropoffLatitude,
      dropoffLongitude: dropoffLongitude ?? this.dropoffLongitude,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      waypoints: waypoints ?? this.waypoints,
    );
  }
}

/// Route point entity for waypoints
class RoutePoint {
  final String location;
  final double latitude;
  final double longitude;
  final int order;

  const RoutePoint({
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.order,
  });

  RoutePoint copyWith({
    String? location,
    double? latitude,
    double? longitude,
    int? order,
  }) {
    return RoutePoint(
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      order: order ?? this.order,
    );
  }
}