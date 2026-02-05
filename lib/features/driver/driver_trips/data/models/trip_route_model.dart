import 'package:flavorizr/features/driver/driver_trips/domain/entities/trip_route.dart';

/// Model for trip route
class TripRouteModel extends TripRoute {
  const TripRouteModel({
    required super.pickupLocation,
    required super.pickupLatitude,
    required super.pickupLongitude,
    required super.dropoffLocation,
    required super.dropoffLatitude,
    required super.dropoffLongitude,
    required super.distance,
    required super.duration,
    super.waypoints,
  });

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
      waypoints:
          (json['waypoints'] as List<dynamic>?)
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
      'waypoints': waypoints
          ?.map((e) => (e as RoutePointModel).toJson())
          .toList(),
    };
  }
}

/// Model for route point
class RoutePointModel extends RoutePoint {
  const RoutePointModel({
    required super.location,
    required super.latitude,
    required super.longitude,
    required super.order,
  });

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
