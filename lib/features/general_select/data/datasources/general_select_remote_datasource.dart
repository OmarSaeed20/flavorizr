import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_client.dart';
import 'package:flavorizr/core/network/base/datasource/base_data_source.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/general_select/data/endpoints/general_select_endpoints.dart';
import 'package:flavorizr/features/general_select/data/models/select_option_model.dart';
import 'package:flavorizr/features/general_select/data/parameters/get_about_us_parameters.dart';
import 'package:flavorizr/features/general_select/data/parameters/get_cities_parameters.dart';
import 'package:flavorizr/features/general_select/data/parameters/get_common_problems_parameters.dart';
import 'package:flavorizr/features/general_select/data/parameters/get_countries_parameters.dart';
import 'package:flavorizr/features/general_select/data/parameters/get_general_settings_parameters.dart';
import 'package:flavorizr/features/general_select/data/parameters/get_policies_parameters.dart';
import 'package:flavorizr/features/general_select/data/parameters/get_questions_parameters.dart';
import 'package:flavorizr/features/general_select/data/parameters/get_select_options_parameters.dart';
import 'package:flavorizr/features/general_select/data/parameters/get_vehicle_types_parameters.dart';

/// Remote data source for general select operations.
///
/// Handles all HTTP requests related to select options and settings.
/// Returns ApiResult with success or error data.
abstract class GeneralSelectRemoteDataSource {
  /// Gets select options based on type and filters.
  Future<ApiResult<List<SelectOptionModel>>> getSelectOptions(
    GetSelectOptionsParameters parameters,
  );

  /// Gets vehicle types.
  /// Endpoint: GET /select/vehicle-type
  Future<ApiResult<List<SelectOptionModel>>> getVehicleTypes(
    GetVehicleTypesParameters parameters,
  );

  /// Gets cities.
  /// Endpoint: GET /select/cities
  Future<ApiResult<List<SelectOptionModel>>> getCities(
    GetCitiesParameters parameters,
  );

  /// Gets common problems.
  /// Endpoint: GET /select/common-problem
  Future<ApiResult<List<SelectOptionModel>>> getCommonProblems(
    GetCommonProblemsParameters parameters,
  );

  /// Gets countries.
  /// Endpoint: GET /select/countries
  Future<ApiResult<List<SelectOptionModel>>> getCountries(
    GetCountriesParameters parameters,
  );

  /// Gets about us information.
  /// Endpoint: GET /setting/about_us
  Future<ApiResult<Map<String, dynamic>>> getAboutUs(
    GetAboutUsParameters parameters,
  );

  /// Gets frequently asked questions.
  /// Endpoint: GET /setting/questions
  Future<ApiResult<List<Map<String, dynamic>>>> getQuestions(
    GetQuestionsParameters parameters,
  );

  /// Gets app policies.
  /// Endpoint: GET /setting/policies
  Future<ApiResult<Map<String, dynamic>>> getPolicies(
    GetPoliciesParameters parameters,
  );

  /// Gets general app settings.
  /// Endpoint: GET /setting/general
  Future<ApiResult<Map<String, dynamic>>> getGeneralSettings(
    GetGeneralSettingsParameters parameters,
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

  @override
  Future<ApiResult<List<SelectOptionModel>>> getVehicleTypes(
    GetVehicleTypesParameters parameters,
  ) async {
    return get<List<SelectOptionModel>>(
      path: GeneralSelectEndpoints.vehicleTypes,
      queryParameters: parameters.toJson(),
      decoder: (data) => (data as List<dynamic>)
          .map((e) => SelectOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResult<List<SelectOptionModel>>> getCities(
    GetCitiesParameters parameters,
  ) async {
    return get<List<SelectOptionModel>>(
      path: GeneralSelectEndpoints.cities,
      queryParameters: parameters.toJson(),
      decoder: (data) => (data as List<dynamic>)
          .map((e) => SelectOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResult<List<SelectOptionModel>>> getCommonProblems(
    GetCommonProblemsParameters parameters,
  ) async {
    return get<List<SelectOptionModel>>(
      path: GeneralSelectEndpoints.commonProblems,
      queryParameters: parameters.toJson(),
      decoder: (data) => (data as List<dynamic>)
          .map((e) => SelectOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResult<List<SelectOptionModel>>> getCountries(
    GetCountriesParameters parameters,
  ) async {
    return get<List<SelectOptionModel>>(
      path: GeneralSelectEndpoints.countries,
      queryParameters: parameters.toJson(),
      decoder: (data) => (data as List<dynamic>)
          .map((e) => SelectOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getAboutUs(
    GetAboutUsParameters parameters,
  ) async {
    return get<Map<String, dynamic>>(
      path: GeneralSelectEndpoints.aboutUs,
      queryParameters: parameters.toJson(),
      decoder: (data) => data as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getQuestions(
    GetQuestionsParameters parameters,
  ) async {
    return get<List<Map<String, dynamic>>>(
      path: GeneralSelectEndpoints.questions,
      queryParameters: parameters.toJson(),
      decoder: (data) => (data as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getPolicies(
    GetPoliciesParameters parameters,
  ) async {
    return get<Map<String, dynamic>>(
      path: GeneralSelectEndpoints.policies,
      queryParameters: parameters.toJson(),
      decoder: (data) => data as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getGeneralSettings(
    GetGeneralSettingsParameters parameters,
  ) async {
    return get<Map<String, dynamic>>(
      path: GeneralSelectEndpoints.general,
      queryParameters: parameters.toJson(),
      decoder: (data) => data as Map<String, dynamic>,
    );
  }
}
