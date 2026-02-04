/// Driver earnings entity containing financial information
class DriverEarnings {
  final double todayEarnings;
  final double weeklyEarnings;
  final double monthlyEarnings;
  final double totalEarnings;
  final int todayTrips;
  final int weeklyTrips;
  final int monthlyTrips;
  final int totalTrips;
  final double averageRating;
  final DateTime lastUpdated;

  const DriverEarnings({
    required this.todayEarnings,
    required this.weeklyEarnings,
    required this.monthlyEarnings,
    required this.totalEarnings,
    required this.todayTrips,
    required this.weeklyTrips,
    required this.monthlyTrips,
    required this.totalTrips,
    required this.averageRating,
    required this.lastUpdated,
  });

  DriverEarnings copyWith({
    double? todayEarnings,
    double? weeklyEarnings,
    double? monthlyEarnings,
    double? totalEarnings,
    int? todayTrips,
    int? weeklyTrips,
    int? monthlyTrips,
    int? totalTrips,
    double? averageRating,
    DateTime? lastUpdated,
  }) {
    return DriverEarnings(
      todayEarnings: todayEarnings ?? this.todayEarnings,
      weeklyEarnings: weeklyEarnings ?? this.weeklyEarnings,
      monthlyEarnings: monthlyEarnings ?? this.monthlyEarnings,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      todayTrips: todayTrips ?? this.todayTrips,
      weeklyTrips: weeklyTrips ?? this.weeklyTrips,
      monthlyTrips: monthlyTrips ?? this.monthlyTrips,
      totalTrips: totalTrips ?? this.totalTrips,
      averageRating: averageRating ?? this.averageRating,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}