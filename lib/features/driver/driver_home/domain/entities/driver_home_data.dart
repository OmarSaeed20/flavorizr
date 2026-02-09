import 'package:fast_golden_taxi/features/driver/driver_home/domain/entities/driver_earnings.dart';
import 'package:fast_golden_taxi/features/driver/driver_home/domain/entities/driver_stats.dart';
import 'package:fast_golden_taxi/features/driver/driver_home/domain/entities/driver_trip.dart';

/// Driver home data entity that aggregates all information needed for the driver home screen
class DriverHomeData {
  final DriverStats stats;
  final DriverEarnings earnings;
  final List<DriverTrip> recentTrips;
  final bool isOnline;
  final bool isAvailable;
  final String? currentLocation;
  final DateTime lastUpdated;

  const DriverHomeData({
    required this.stats,
    required this.earnings,
    required this.recentTrips,
    required this.isOnline,
    required this.isAvailable,
    this.currentLocation,
    required this.lastUpdated,
  });

  DriverHomeData copyWith({
    DriverStats? stats,
    DriverEarnings? earnings,
    List<DriverTrip>? recentTrips,
    bool? isOnline,
    bool? isAvailable,
    String? currentLocation,
    DateTime? lastUpdated,
  }) {
    return DriverHomeData(
      stats: stats ?? this.stats,
      earnings: earnings ?? this.earnings,
      recentTrips: recentTrips ?? this.recentTrips,
      isOnline: isOnline ?? this.isOnline,
      isAvailable: isAvailable ?? this.isAvailable,
      currentLocation: currentLocation ?? this.currentLocation,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
