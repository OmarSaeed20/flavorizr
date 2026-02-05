import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_client.dart';
import 'package:flavorizr/core/network/base/datasource/base_data_source.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/home/data/endpoints/home_endpoints.dart';
import 'package:flavorizr/features/user/home/data/models/banner_model.dart';
import 'package:flavorizr/features/user/home/data/models/advertisement_model.dart';
import 'package:flavorizr/features/user/home/data/models/available_trip_model.dart';
import 'package:flavorizr/features/user/home/data/models/home_data_model.dart';
import 'package:flavorizr/features/user/home/data/parameters/get_available_trips_parameters.dart';

/// Remote data source for home operations.
///
/// Handles all HTTP requests related to home page data.
/// Returns ApiResult with success or error data.
abstract class HomeRemoteDataSource {
  /// Gets home page data including banners, advertisements, and featured trips.
  Future<ApiResult<HomeDataModel>> getHomeData();

  /// Gets all banners.
  Future<ApiResult<List<BannerModel>>> getBanners();

  /// Gets all advertisements.
  Future<ApiResult<List<AdvertisementModel>>> getAdvertisements();

  /// Gets available trips based on location and filters.
  Future<ApiResult<List<AvailableTripModel>>> getAvailableTrips(
    GetAvailableTripsParameters parameters,
  );

  /// Gets notification count.
  Future<ApiResult<int>> getNotificationCount();

  /// Gets featured trips.
  Future<ApiResult<List<AvailableTripModel>>> getFeaturedTrips({int page = 1, int limit = 10});

  /// Gets recent trips.
  Future<ApiResult<List<AvailableTripModel>>> getRecentTrips({int page = 1, int limit = 10});
}

/// Implementation of [HomeRemoteDataSource] using BaseRemoteDataSource.
class HomeRemoteDataSourceImpl with BaseRemoteDataSource implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  @override
  Future<ApiResult<HomeDataModel>> getHomeData() async {
    return get<HomeDataModel>(
      path: HomeEndpoints.homeData,
      decoder: (data) => HomeDataModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<List<BannerModel>>> getBanners() async {
    return get<List<BannerModel>>(
      path: HomeEndpoints.banners,
      decoder: (data) => (data as List<dynamic>)
          .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResult<List<AdvertisementModel>>> getAdvertisements() async {
    return get<List<AdvertisementModel>>(
      path: HomeEndpoints.advertisements,
      decoder: (data) => (data as List<dynamic>)
          .map((e) => AdvertisementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResult<List<AvailableTripModel>>> getAvailableTrips(
    GetAvailableTripsParameters parameters,
  ) async {
    return get<List<AvailableTripModel>>(
      path: HomeEndpoints.availableTrips,
      queryParameters: parameters.toJson(),
      decoder: (data) => (data as List<dynamic>)
          .map((e) => AvailableTripModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResult<int>> getNotificationCount() async {
    return get<int>(path: HomeEndpoints.notificationCount, decoder: (data) => data['count'] as int);
  }

  @override
  Future<ApiResult<List<AvailableTripModel>>> getFeaturedTrips({
    int page = 1,
    int limit = 10,
  }) async {
    return get<List<AvailableTripModel>>(
      path: HomeEndpoints.featuredTrips,
      queryParameters: {'page': page, 'limit': limit},
      decoder: (data) => (data as List<dynamic>)
          .map((e) => AvailableTripModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResult<List<AvailableTripModel>>> getRecentTrips({int page = 1, int limit = 10}) async {
    return get<List<AvailableTripModel>>(
      path: HomeEndpoints.recentTrips,
      queryParameters: {'page': page, 'limit': limit},
      decoder: (data) => (data as List<dynamic>)
          .map((e) => AvailableTripModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
