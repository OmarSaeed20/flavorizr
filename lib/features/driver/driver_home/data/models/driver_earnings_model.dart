import 'package:flavorizr/features/driver/driver_home/domain/entities/driver_earnings.dart';

/// Model for driver earnings
class DriverEarningsModel extends DriverEarnings {
  const DriverEarningsModel({
    required super.todayEarnings,
    required super.weeklyEarnings,
    required super.monthlyEarnings,
    required super.totalEarnings,
    required super.todayTrips,
    required super.weeklyTrips,
    required super.monthlyTrips,
    required super.totalTrips,
    required super.averageRating,
    required super.lastUpdated,
  });

  factory DriverEarningsModel.fromJson(Map<String, dynamic> json) {
    return DriverEarningsModel(
      todayEarnings: (json['todayEarnings'] ?? 0).toDouble(),
      weeklyEarnings: (json['weeklyEarnings'] ?? 0).toDouble(),
      monthlyEarnings: (json['monthlyEarnings'] ?? 0).toDouble(),
      totalEarnings: (json['totalEarnings'] ?? 0).toDouble(),
      todayTrips: json['todayTrips'] ?? 0,
      weeklyTrips: json['weeklyTrips'] ?? 0,
      monthlyTrips: json['monthlyTrips'] ?? 0,
      totalTrips: json['totalTrips'] ?? 0,
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      lastUpdated: DateTime.parse(
        json['lastUpdated'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todayEarnings': todayEarnings,
      'weeklyEarnings': weeklyEarnings,
      'monthlyEarnings': monthlyEarnings,
      'totalEarnings': totalEarnings,
      'todayTrips': todayTrips,
      'weeklyTrips': weeklyTrips,
      'monthlyTrips': monthlyTrips,
      'totalTrips': totalTrips,
      'averageRating': averageRating,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
