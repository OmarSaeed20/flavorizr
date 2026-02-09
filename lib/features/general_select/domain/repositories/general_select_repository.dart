import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
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

/// Repository interface for general select operations.
abstract class GeneralSelectRepository {
  /// Gets select options based on type and filters.
  Future<ApiResult<List<SelectOption>>> getSelectOptions(GetSelectOptionsParameters params);

  /// Gets vehicle types.
  Future<ApiResult<List<SelectOption>>> getVehicleTypes(GetVehicleTypesParameters params);

  /// Gets cities.
  Future<ApiResult<List<SelectOption>>> getCities(GetCitiesParameters params);

  /// Gets common problems.
  Future<ApiResult<List<SelectOption>>> getCommonProblems(GetCommonProblemsParameters params);

  /// Gets countries.
  Future<ApiResult<List<SelectOption>>> getCountries(GetCountriesParameters params);

  /// Gets about us information.
  Future<ApiResult<Map<String, dynamic>>> getAboutUs(GetAboutUsParameters params);

  /// Gets frequently asked questions.
  Future<ApiResult<List<Map<String, dynamic>>>> getQuestions(GetQuestionsParameters params);

  /// Gets app policies.
  Future<ApiResult<Map<String, dynamic>>> getPolicies(GetPoliciesParameters params);

  /// Gets general app settings.
  Future<ApiResult<Map<String, dynamic>>> getGeneralSettings(GetGeneralSettingsParameters params);

  /// Clears all cached data.
  Future<ApiResult<void>> clearAllCachedData();
}
