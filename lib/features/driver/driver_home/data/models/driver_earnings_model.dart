import '../../domain/entities/driver_earnings.dart';

/// Model for driver earnings
class DriverEarningsModel extends DriverEarnings {
  const DriverEarningsModel({
    required double todayEarnings,
    required double weeklyEarnings,
    required double monthlyEarnings,
    required double totalEarnings,
    required int todayTrips,
    required int weeklyTrips,
    required int monthlyTrips,
    required int totalTrips,
    required double averageRating,
    required DateTime lastUpdated,
  }) : super(
          todayEarnings: todayEarnings,
          weeklyEarnings: weeklyEarnings,
          monthlyEarnings: monthlyEarnings,
          totalEarnings: totalEarnings,
          todayTrips: todayTrips,
          weeklyTrips: weeklyTrips,
          monthlyTrips: monthlyTrips,
          totalTrips: totalTrips,
          averageRating: averageRating,
          lastUpdated: lastUpdated,
        );

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
      lastUpdated: DateTime.parse(json['lastUpdated'] ?? DateTime.now().toIso8601String()),
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