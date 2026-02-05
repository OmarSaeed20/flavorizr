import 'package:flavorizr/features/driver/driver_home/domain/entities/driver_stats.dart';

/// Model for driver statistics
class DriverStatsModel extends DriverStats {
  const DriverStatsModel({
    required super.totalTrips,
    required super.completedTrips,
    required super.cancelledTrips,
    required super.completionRate,
    required super.averageRating,
    required super.totalReviews,
    required super.acceptanceRate,
    required super.totalHoursOnline,
    required super.lastUpdated,
  });

  factory DriverStatsModel.fromJson(Map<String, dynamic> json) {
    return DriverStatsModel(
      totalTrips: json['totalTrips'] ?? 0,
      completedTrips: json['completedTrips'] ?? 0,
      cancelledTrips: json['cancelledTrips'] ?? 0,
      completionRate: (json['completionRate'] ?? 0.0).toDouble(),
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      acceptanceRate: (json['acceptanceRate'] ?? 0.0).toDouble(),
      totalHoursOnline: json['totalHoursOnline'] ?? 0,
      lastUpdated: DateTime.parse(
        json['lastUpdated'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalTrips': totalTrips,
      'completedTrips': completedTrips,
      'cancelledTrips': cancelledTrips,
      'completionRate': completionRate,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'acceptanceRate': acceptanceRate,
      'totalHoursOnline': totalHoursOnline,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
