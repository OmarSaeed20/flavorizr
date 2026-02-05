import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_client.dart';
import 'package:flavorizr/core/network/base/datasource/base_data_source.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_reviews/data/endpoints/driver_reviews_endpoints.dart';
import 'package:flavorizr/features/driver/driver_reviews/data/models/driver_review_model.dart';
import 'package:flavorizr/features/driver/driver_reviews/data/parameters/get_driver_reviews_parameters.dart';

/// Remote data source for driver reviews.
///
/// Handles all HTTP requests related to driver reviews.
/// Returns ApiResult with success or error data.
abstract class DriverReviewRemoteDataSource {
  /// Gets reviews for a specific driver.
  Future<ApiResult<List<DriverReviewModel>>> getReviews(GetDriverReviewsParameters parameters);
}

/// Implementation of [DriverReviewRemoteDataSource] using BaseRemoteDataSource.
class DriverReviewRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements DriverReviewRemoteDataSource {
  const DriverReviewRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  @override
  Future<ApiResult<List<DriverReviewModel>>> getReviews(
    GetDriverReviewsParameters parameters,
  ) async {
    return get<List<DriverReviewModel>>(
      path: DriverReviewsEndpoints.getReviews,
      queryParameters: parameters.toJson(),
      decoder: (data) {
        final jsonData = data as Map<String, dynamic>;
        final items = (jsonData['reviews'] as List? ?? jsonData['data'] as List? ?? [])
            .map((e) => DriverReviewModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return items;
      },
    );
  }
}
