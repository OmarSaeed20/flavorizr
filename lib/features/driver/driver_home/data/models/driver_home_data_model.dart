import 'package:flavorizr/features/driver/driver_home/data/models/driver_earnings_model.dart';
import 'package:flavorizr/features/driver/driver_home/data/models/driver_stats_model.dart';
import 'package:flavorizr/features/driver/driver_home/data/models/driver_trip_model.dart';
import 'package:flavorizr/features/driver/driver_home/domain/entities/driver_home_data.dart';

/// Model for driver home data
class DriverHomeDataModel extends DriverHomeData {
  const DriverHomeDataModel({
    required super.stats,
    required super.earnings,
    required super.recentTrips,
    required super.isOnline,
    required super.isAvailable,
    super.currentLocation,
    required super.lastUpdated,
  });

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
      lastUpdated: DateTime.parse(
        json['lastUpdated'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stats': (stats as DriverStatsModel).toJson(),
      'earnings': (earnings as DriverEarningsModel).toJson(),
      'recentTrips': recentTrips
          .map((e) => (e as DriverTripModel).toJson())
          .toList(),
      'isOnline': isOnline,
      'isAvailable': isAvailable,
      'currentLocation': currentLocation,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Converts the model to its entity representation.
  /// Since this model extends the entity, it returns itself.
  DriverHomeData toEntity() => this;
}
