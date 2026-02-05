/* import 'package:flavorizr/core/network/api/models/api_general.dart';
import 'package:flavorizr/core/network/api/parameters/general_parameters.dart';
import 'package:flavorizr/core/network/api/repositories/general_repository.dart';
import 'package:flavorizr/core/network/api_response.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';

/// General Service
/// Business logic layer for general/settings operations
class GeneralService {
  final GeneralRepository _repository;

  GeneralService({required GeneralRepository repository}) : _repository = repository;

  /// Get about us information
  /// Returns NetworkResult with ApiAboutUs on success
  Future<ApiResult<ApiResponse<ApiAboutUs>>> getAboutUs() async {
    final parameters = GetAboutUsParameters.builder().build();

    return _repository.getAboutUs(parameters);
  }

  /// Get questions/FAQ
  /// Returns NetworkResult with List<ApiQuestion> on success
  Future<ApiResult<ApiResponse<List<ApiQuestion>>>> getQuestions() async {
    final parameters = GetQuestionsParameters.builder().build();

    return _repository.getQuestions(parameters);
  }

  /// Get policies
  /// Returns NetworkResult with ApiPolicies on success
  Future<ApiResult<ApiResponse<ApiPolicies>>> getPolicies() async {
    final parameters = GetPoliciesParameters.builder().build();

    return _repository.getPolicies(parameters);
  }

  /// Get general settings
  /// Returns NetworkResult with ApiGeneralSettings on success
  Future<ApiResult<ApiResponse<ApiGeneralSettings>>> getGeneralSettings() async {
    final parameters = GetGeneralSettingsParameters.builder().build();

    return _repository.getGeneralSettings(parameters);
  }
}
 */
