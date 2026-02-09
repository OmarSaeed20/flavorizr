import 'package:fast_golden_taxi/features/user/home/domain/entities/advertisement.dart';
import 'package:fast_golden_taxi/features/user/home/domain/entities/available_trip.dart';
import 'package:fast_golden_taxi/features/user/home/domain/entities/banner.dart';

class HomeData {
  final List<Banner> banners;
  final List<Advertisement> advertisements;
  final List<AvailableTrip> featuredTrips;
  final int notificationCount;

  const HomeData({
    required this.banners,
    required this.advertisements,
    required this.featuredTrips,
    required this.notificationCount,
  });

  HomeData copyWith({
    List<Banner>? banners,
    List<Advertisement>? advertisements,
    List<AvailableTrip>? featuredTrips,
    int? notificationCount,
  }) {
    return HomeData(
      banners: banners ?? this.banners,
      advertisements: advertisements ?? this.advertisements,
      featuredTrips: featuredTrips ?? this.featuredTrips,
      notificationCount: notificationCount ?? this.notificationCount,
    );
  }
}
