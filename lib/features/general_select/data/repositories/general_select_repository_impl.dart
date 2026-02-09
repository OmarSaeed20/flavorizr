import 'package:fast_golden_taxi/core/network/base/repo/base_repository.dart';
import 'package:fast_golden_taxi/core/network/network_info.dart';
import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/general_select/data/datasources/general_select_local_datasource.dart';
import 'package:fast_golden_taxi/features/general_select/data/datasources/general_select_remote_datasource.dart';
import 'package:fast_golden_taxi/features/general_select/data/models/select_option_model.dart';
import 'package:fast_golden_taxi/features/general_select/data/parameters/get_about_us_parameters.dart';
import 'package:fast_golden_taxi/features/general_select/data/parameters/get_cities_parameters.dart';
import 'package:fast_golden_taxi/features/general_select/data/parameters/get_common_problems_parameters.dart';
import 'package:fast_golden_taxi/features/general_select/data/parameters/get_countries_parameters.dart';
import 'package:fast_golden_taxi/features/general_select/data/parameters/get_general_settings_parameters.dart';
import 'package:fast_golden_taxi/features/general_select/data/parameters/get_policies_parameters.dart';
import 'package:fast_golden_taxi/features/general_select/data/parameters/get_questions_parameters.dart';
import 'package:fast_golden_taxi/features/general_select/data/parameters/get_select_options_parameters.dart';
import 'package:fast_golden_taxi/features/general_select/data/parameters/get_vehicle_types_parameters.dart';
import 'package:fast_golden_taxi/features/general_select/domain/entities/select_option.dart';
import 'package:fast_golden_taxi/features/general_select/domain/repositories/general_select_repository.dart';

/// Implementation of [GeneralSelectRepository].
class GeneralSelectRepositoryImpl extends BaseRepository implements GeneralSelectRepository {
  final GeneralSelectRemoteDataSource _remoteDataSource;
  final GeneralSelectLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  GeneralSelectRepositoryImpl({
    required GeneralSelectRemoteDataSource remoteDataSource,
    required GeneralSelectLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  @override
  Future<ApiResult<List<SelectOption>>> getSelectOptions(GetSelectOptionsParameters params) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.getSelectOptions(params),
    );
    return result.map(
      success: (data) => ApiResult.success(data.data.map((e) => e.toEntity()).toList()),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }

  @override
  Future<ApiResult<List<SelectOption>>> getVehicleTypes(GetVehicleTypesParameters params) async {
    final result = await fetchWithCache<List<SelectOptionModel>>(
      cacheKey: 'vehicle_types',
      remoteFetcher: () => _remoteDataSource.getVehicleTypes(params),
      localFetcher: _localDataSource.getCachedVehicleTypes,
      cacheSaver: _localDataSource.cacheVehicleTypes,
      maxCacheAge: const Duration(hours: 24),
    );
    return result.when(
      success: (data, error) {
        final vehicleTypes = data.map((e) => e.toEntity()).toList();
        return ApiResult.success(vehicleTypes, error);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<List<SelectOption>>> getCities(GetCitiesParameters params) async {
    final result = await fetchWithCache<List<SelectOptionModel>>(
      cacheKey: 'cities',
      remoteFetcher: () => _remoteDataSource.getCities(params),
      localFetcher: _localDataSource.getCachedCities,
      cacheSaver: _localDataSource.cacheCities,
      maxCacheAge: const Duration(hours: 24),
    );
    return result.when(
      success: (data, error) {
        final cities = data.map((e) => e.toEntity()).toList();
        return ApiResult.success(cities, error);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<List<SelectOption>>> getCommonProblems(
    GetCommonProblemsParameters params,
  ) async {
    final result = await fetchWithCache<List<SelectOptionModel>>(
      cacheKey: 'common_problems',
      remoteFetcher: () => _remoteDataSource.getCommonProblems(params),
      localFetcher: _localDataSource.getCachedCommonProblems,
      cacheSaver: _localDataSource.cacheCommonProblems,
      maxCacheAge: const Duration(hours: 24),
    );
    return result.when(
      success: (data, error) {
        final problems = data.map((e) => e.toEntity()).toList();
        return ApiResult.success(problems, error);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<List<SelectOption>>> getCountries(GetCountriesParameters params) async {
    final result = await fetchWithCache<List<SelectOptionModel>>(
      cacheKey: 'countries',
      remoteFetcher: () => _remoteDataSource.getCountries(params),
      localFetcher: _localDataSource.getCachedCountries,
      cacheSaver: _localDataSource.cacheCountries,
      maxCacheAge: const Duration(hours: 24),
    );
    return result.when(
      success: (data, error) {
        final countries = data.map((e) => e.toEntity()).toList();
        return ApiResult.success(countries, error);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getAboutUs(GetAboutUsParameters params) async {
    final result = await fetchWithCache<Map<String, dynamic>>(
      cacheKey: 'about_us',
      remoteFetcher: () => _remoteDataSource.getAboutUs(params),
      localFetcher: () async {
        final cached = await _localDataSource.getCachedAboutUs();
        return cached.when(
          success: (data, error) => ApiResult.success(data ?? {}, error),
          exception: ApiResult.exception,
        );
      },
      cacheSaver: _localDataSource.cacheAboutUs,
      maxCacheAge: const Duration(hours: 24),
    );
    return result;
  }

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getQuestions(GetQuestionsParameters params) async {
    final result = await fetchWithCache<List<Map<String, dynamic>>>(
      cacheKey: 'questions',
      remoteFetcher: () => _remoteDataSource.getQuestions(params),
      localFetcher: () async {
        final cached = await _localDataSource.getCachedQuestions();
        return cached.when(
          success: (data, error) => ApiResult.success(data ?? [], error),
          exception: ApiResult.exception,
        );
      },
      cacheSaver: _localDataSource.cacheQuestions,
      maxCacheAge: const Duration(hours: 24),
    );
    return result;
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getPolicies(GetPoliciesParameters params) async {
    final result = await fetchWithCache<Map<String, dynamic>>(
      cacheKey: 'policies',
      remoteFetcher: () => _remoteDataSource.getPolicies(params),
      localFetcher: () async {
        final cached = await _localDataSource.getCachedPolicies();
        return cached.when(
          success: (data, error) => ApiResult.success(data ?? {}, error),
          exception: ApiResult.exception,
        );
      },
      cacheSaver: _localDataSource.cachePolicies,
      maxCacheAge: const Duration(hours: 24),
    );
    return result;
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getGeneralSettings(
    GetGeneralSettingsParameters params,
  ) async {
    final result = await fetchWithCache<Map<String, dynamic>>(
      cacheKey: 'general_settings',
      remoteFetcher: () => _remoteDataSource.getGeneralSettings(params),
      localFetcher: () async {
        final cached = await _localDataSource.getCachedGeneralSettings();
        return cached.when(
          success: (data, error) => ApiResult.success(data ?? {}, error),
          exception: ApiResult.exception,
        );
      },
      cacheSaver: _localDataSource.cacheGeneralSettings,
      maxCacheAge: const Duration(hours: 24),
    );
    return result;
  }

  @override
  Future<ApiResult<void>> clearAllCachedData() async {
    return clearAllCache(clearer: _localDataSource.clearAllCache);
  }
}
