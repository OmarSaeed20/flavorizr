import 'package:fast_golden_taxi/features/user/home/data/models/advertisement_model.dart';
import 'package:fast_golden_taxi/features/user/home/data/models/available_trip_model.dart';
import 'package:fast_golden_taxi/features/user/home/data/models/banner_model.dart';
import 'package:fast_golden_taxi/features/user/home/domain/entities/home_data.dart';

class HomeDataModel extends HomeData {
  const HomeDataModel({
    required super.banners,
    required super.advertisements,
    required super.featuredTrips,
    required super.notificationCount,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      banners:
          (json['banners'] as List<dynamic>?)
              ?.map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      advertisements:
          (json['advertisements'] as List<dynamic>?)
              ?.map((e) => AdvertisementModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      featuredTrips:
          (json['featured_trips'] as List<dynamic>?)
              ?.map((e) => AvailableTripModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      notificationCount: json['notification_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'banners': banners.map((e) => (e as BannerModel).toJson()).toList(),
      'advertisements': advertisements.map((e) => (e as AdvertisementModel).toJson()).toList(),
      'featured_trips': featuredTrips.map((e) => (e as AvailableTripModel).toJson()).toList(),
      'notification_count': notificationCount,
    };
  }

  HomeData toEntity() => this;
}
