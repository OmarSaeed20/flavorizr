import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/home/domain/entities/banner.dart';
import 'package:flavorizr/features/user/home/domain/entities/advertisement.dart';
import 'package:flavorizr/features/user/home/domain/entities/available_trip.dart';
import 'package:flavorizr/features/user/home/domain/entities/home_data.dart';
import 'package:flavorizr/features/user/home/data/parameters/get_available_trips_parameters.dart';

abstract class HomeRepository {
  Future<ApiResult<HomeData>> getHomeData();
  Future<ApiResult<List<Banner>>> getBanners();
  Future<ApiResult<List<Advertisement>>> getAdvertisements();
  Future<ApiResult<List<AvailableTrip>>> getAvailableTrips(GetAvailableTripsParameters params);
  Future<ApiResult<int>> getNotificationCount();
}