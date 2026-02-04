import 'package:flavorizr/features/driver_home/data/models/driver_earnings_model.dart';
import 'package:flavorizr/features/driver_home/data/models/driver_stats_model.dart';
import 'package:flavorizr/features/driver_home/data/models/driver_trip_model.dart';
import 'package:flavorizr/features/driver_home/domain/entities/driver_earnings.dart';
import 'package:flavorizr/features/driver_home/domain/entities/driver_home_data.dart';
import 'package:flavorizr/features/driver_home/domain/entities/driver_stats.dart';

/// Model for driver home data
class DriverHomeDataModel extends DriverHomeData {
  const DriverHomeDataModel({
    required DriverStats stats,
    required DriverEarnings earnings,
    required List<DriverTrip> recentTrips,
    required bool isOnline,
    required bool isAvailable,
    String? currentLocation,
    required DateTime lastUpdated,
  }) : super(
         stats: stats,
         earnings: earnings,
         recentTrips: recentTrips,
         isOnline: isOnline,
         isAvailable: isAvailable,
         currentLocation: currentLocation,
         lastUpdated: lastUpdated,
       );

  factory DriverHomeDataModel.fromJson(Map<String, dynamic> json) {
    return DriverHomeDataModel(
      stats: DriverStatsModel.fromJson(json['stats'] ?? {}),
      earnings: DriverEarningsModel.fromJson(json['earnings'] ?? {}),
      recentTrips:
          (json['recentTrips'] as List<dynamic>?)
              ?.map((e) => DriverTripModel.fromJson(e))
              .toList() ??
          [],
      isOnline: json['isOnline'] ?? false,
      isAvailable: json['isAvailable'] ?? false,
      currentLocation: json['currentLocation'],
      lastUpdated: DateTime.parse(json['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stats': (stats as DriverStatsModel).toJson(),
      'earnings': (earnings as DriverEarningsModel).toJson(),
      'recentTrips': recentTrips.map((e) => (e as DriverTripModel).toJson()).toList(),
      'isOnline': isOnline,
      'isAvailable': isAvailable,
      'currentLocation': currentLocation,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
