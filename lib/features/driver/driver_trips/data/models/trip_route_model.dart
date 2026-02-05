import '../../domain/entities/trip_route.dart';

/// Model for trip route
class TripRouteModel extends TripRoute {
  const TripRouteModel({
    required String pickupLocation,
    required double pickupLatitude,
    required double pickupLongitude,
    required String dropoffLocation,
    required double dropoffLatitude,
    required double dropoffLongitude,
    required double distance,
    required double duration,
    List<RoutePoint>? waypoints,
  }) : super(
          pickupLocation: pickupLocation,
          pickupLatitude: pickupLatitude,
          pickupLongitude: pickupLongitude,
          dropoffLocation: dropoffLocation,
          dropoffLatitude: dropoffLatitude,
          dropoffLongitude: dropoffLongitude,
          distance: distance,
          duration: duration,
          waypoints: waypoints,
        );

  factory TripRouteModel.fromJson(Map<String, dynamic> json) {
    return TripRouteModel(
      pickupLocation: json['pickupLocation'] ?? '',
      pickupLatitude: (json['pickupLatitude'] ?? 0).toDouble(),
      pickupLongitude: (json['pickupLongitude'] ?? 0).toDouble(),
      dropoffLocation: json['dropoffLocation'] ?? '',
      dropoffLatitude: (json['dropoffLatitude'] ?? 0).toDouble(),
      dropoffLongitude: (json['dropoffLongitude'] ?? 0).toDouble(),
      distance: (json['distance'] ?? 0).toDouble(),
      duration: (json['duration'] ?? 0).toDouble(),
      waypoints: (json['waypoints'] as List<dynamic>?)
              ?.map((e) => RoutePointModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickupLocation': pickupLocation,
      'pickupLatitude': pickupLatitude,
      'pickupLongitude': pickupLongitude,
      'dropoffLocation': dropoffLocation,
      'dropoffLatitude': dropoffLatitude,
      'dropoffLongitude': dropoffLongitude,
      'distance': distance,
      'duration': duration,
      'waypoints': waypoints?.map((e) => (e as RoutePointModel).toJson()).toList(),
    };
  }
}

/// Model for route point
class RoutePointModel extends RoutePoint {
  const RoutePointModel({
    required String location,
    required double latitude,
    required double longitude,
    required int order,
  }) : super(
          location: location,
          latitude: latitude,
          longitude: longitude,
          order: order,
        );

  factory RoutePointModel.fromJson(Map<String, dynamic> json) {
    return RoutePointModel(
      location: json['location'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'order': order,
    };
  }
}