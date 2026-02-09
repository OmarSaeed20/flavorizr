import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/core/network/api_client.dart';
import 'package:fast_golden_taxi/core/network/base/datasource/base_data_source.dart';
import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_home/data/endpoints/driver_home_endpoints.dart';
import 'package:fast_golden_taxi/features/driver/driver_home/data/models/driver_home_data_model.dart';

/// Remote data source for driver home data.
///
/// Handles all HTTP requests related to driver home page data.
/// Returns ApiResult with success or error data.
abstract class DriverHomeRemoteDataSource {
  /// Gets complete driver home data.
  Future<ApiResult<DriverHomeDataModel>> getDriverHomeData();
}

/// Implementation of [DriverHomeRemoteDataSource] using BaseRemoteDataSource.
class DriverHomeRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements DriverHomeRemoteDataSource {
  const DriverHomeRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  @override
  Future<ApiResult<DriverHomeDataModel>> getDriverHomeData() async {
    return get<DriverHomeDataModel>(
      path: DriverHomeEndpoints.homeData,
      decoder: (data) => DriverHomeDataModel.fromJson(data as Map<String, dynamic>),
    );
  }
}
