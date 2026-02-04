import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_client.dart';
import 'package:flavorizr/core/network/base/datasource/base_data_source.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/general_select/data/endpoints/general_select_endpoints.dart';
import 'package:flavorizr/features/general_select/data/models/select_option_model.dart';
import 'package:flavorizr/features/general_select/data/parameters/get_select_options_parameters.dart';

/// Remote data source for general select operations.
///
/// Handles all HTTP requests related to select options.
/// Returns ApiResult with success or error data.
abstract class GeneralSelectRemoteDataSource {
  /// Gets select options based on type and filters.
  Future<ApiResult<List<SelectOptionModel>>> getSelectOptions(
    GetSelectOptionsParameters parameters,
  );
}

/// Implementation of [GeneralSelectRemoteDataSource] using BaseRemoteDataSource.
class GeneralSelectRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements GeneralSelectRemoteDataSource {
  const GeneralSelectRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  @override
  Future<ApiResult<List<SelectOptionModel>>> getSelectOptions(
    GetSelectOptionsParameters parameters,
  ) async {
    return get<List<SelectOptionModel>>(
      path: GeneralSelectEndpoints.selectOptions,
      queryParameters: parameters.toJson(),
      decoder: (data) => (data as List<dynamic>)
          .map((e) => SelectOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
