import 'package:fast_golden_taxi/core/network/api/models/api_general.dart';
import 'package:fast_golden_taxi/core/network/api/parameters/general_parameters.dart';
import 'package:fast_golden_taxi/core/network/api_response.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';

/// General Repository Interface
/// Defines the contract for general/settings data operations
abstract class GeneralRepository {
  /// Get about us information
  /// Returns NetworkResult with ApiAboutUs on success
  Future<ApiResult<ApiResponse<ApiAboutUs>>> getAboutUs(GetAboutUsParameters parameters);

  /// Get questions/FAQ
  /// Returns NetworkResult with List<ApiQuestion> on success
  Future<ApiResult<ApiResponse<List<ApiQuestion>>>> getQuestions(GetQuestionsParameters parameters);

  /// Get policies
  /// Returns NetworkResult with ApiPolicies on success
  Future<ApiResult<ApiResponse<ApiPolicies>>> getPolicies(GetPoliciesParameters parameters);

  /// Get general settings
  /// Returns NetworkResult with ApiGeneralSettings on success
  Future<ApiResult<ApiResponse<ApiGeneralSettings>>> getGeneralSettings(
    GetGeneralSettingsParameters parameters,
  );
}
