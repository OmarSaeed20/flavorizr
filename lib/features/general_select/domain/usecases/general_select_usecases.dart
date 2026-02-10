// lib/features/general_select/domain/usecases/general_select_usecases.dart
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
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
import 'package:fast_golden_taxi/shared/domain/usecases/usecase.dart';

/// Use case for getting select options.
class GetSelectOptionsUseCase
    implements UseCase<List<SelectOption>, GetSelectOptionsParameters> {
  GetSelectOptionsUseCase(this._repository);

  final GeneralSelectRepository _repository;

  @override
  Future<ApiResult<List<SelectOption>>> call(
    GetSelectOptionsParameters params,
  ) {
    return _repository.getSelectOptions(params);
  }
}

/// Use case for getting vehicle types.
class GetVehicleTypesUseCase
    implements UseCase<List<SelectOption>, GetVehicleTypesParameters> {
  GetVehicleTypesUseCase(this._repository);

  final GeneralSelectRepository _repository;

  @override
  Future<ApiResult<List<SelectOption>>> call(GetVehicleTypesParameters params) {
    return _repository.getVehicleTypes(params);
  }
}

/// Use case for getting cities.
class GetCitiesUseCase
    implements UseCase<List<SelectOption>, GetCitiesParameters> {
  GetCitiesUseCase(this._repository);

  final GeneralSelectRepository _repository;

  @override
  Future<ApiResult<List<SelectOption>>> call(GetCitiesParameters params) {
    return _repository.getCities(params);
  }
}

/// Use case for getting common problems.
class GetCommonProblemsUseCase
    implements UseCase<List<SelectOption>, GetCommonProblemsParameters> {
  GetCommonProblemsUseCase(this._repository);

  final GeneralSelectRepository _repository;

  @override
  Future<ApiResult<List<SelectOption>>> call(
    GetCommonProblemsParameters params,
  ) {
    return _repository.getCommonProblems(params);
  }
}

/// Use case for getting countries.
class GetCountriesUseCase
    implements UseCase<List<SelectOption>, GetCountriesParameters> {
  GetCountriesUseCase(this._repository);

  final GeneralSelectRepository _repository;

  @override
  Future<ApiResult<List<SelectOption>>> call(GetCountriesParameters params) {
    return _repository.getCountries(params);
  }
}

/// Use case for getting about us information.
class GetAboutUsUseCase
    implements UseCase<Map<String, dynamic>, GetAboutUsParameters> {
  GetAboutUsUseCase(this._repository);

  final GeneralSelectRepository _repository;

  @override
  Future<ApiResult<Map<String, dynamic>>> call(GetAboutUsParameters params) {
    return _repository.getAboutUs(params);
  }
}

/// Use case for getting frequently asked questions.
class GetQuestionsUseCase
    implements UseCase<List<Map<String, dynamic>>, GetQuestionsParameters> {
  GetQuestionsUseCase(this._repository);

  final GeneralSelectRepository _repository;

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> call(
    GetQuestionsParameters params,
  ) {
    return _repository.getQuestions(params);
  }
}

/// Use case for getting app policies.
class GetPoliciesUseCase
    implements UseCase<Map<String, dynamic>, GetPoliciesParameters> {
  GetPoliciesUseCase(this._repository);

  final GeneralSelectRepository _repository;

  @override
  Future<ApiResult<Map<String, dynamic>>> call(GetPoliciesParameters params) {
    return _repository.getPolicies(params);
  }
}

/// Use case for getting general app settings.
class GetGeneralSettingsUseCase
    implements UseCase<Map<String, dynamic>, GetGeneralSettingsParameters> {
  GetGeneralSettingsUseCase(this._repository);

  final GeneralSelectRepository _repository;

  @override
  Future<ApiResult<Map<String, dynamic>>> call(
    GetGeneralSettingsParameters params,
  ) {
    return _repository.getGeneralSettings(params);
  }
}

/// Use case for clearing general select cache.
class ClearGeneralSelectCacheUseCase implements UseCase<void, void> {
  ClearGeneralSelectCacheUseCase(this._repository);

  final GeneralSelectRepository _repository;

  @override
  Future<ApiResult<void>> call(void params) {
    return _repository.clearAllCachedData();
  }
}
