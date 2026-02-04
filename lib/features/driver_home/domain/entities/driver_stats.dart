/// Driver statistics entity containing performance metrics
class DriverStats {
  final int totalTrips;
  final int completedTrips;
  final int cancelledTrips;
  final double completionRate;
  final double averageRating;
  final int totalReviews;
  final double acceptanceRate;
  final int totalHoursOnline;
  final DateTime lastUpdated;

  const DriverStats({
    required this.totalTrips,
    required this.completedTrips,
    required this.cancelledTrips,
    required this.completionRate,
    required this.averageRating,
    required this.totalReviews,
    required this.acceptanceRate,
    required this.totalHoursOnline,
    required this.lastUpdated,
  });

  DriverStats copyWith({
    int? totalTrips,
    int? completedTrips,
    int? cancelledTrips,
    double? completionRate,
    double? averageRating,
    int? totalReviews,
    double? acceptanceRate,
    int? totalHoursOnline,
    DateTime? lastUpdated,
  }) {
    return DriverStats(
      totalTrips: totalTrips ?? this.totalTrips,
      completedTrips: completedTrips ?? this.completedTrips,
      cancelledTrips: cancelledTrips ?? this.cancelledTrips,
      completionRate: completionRate ?? this.completionRate,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      acceptanceRate: acceptanceRate ?? this.acceptanceRate,
      totalHoursOnline: totalHoursOnline ?? this.totalHoursOnline,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}