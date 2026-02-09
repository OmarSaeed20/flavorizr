import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/core/network/api/endpoints/general_endpoints.dart';
import 'package:fast_golden_taxi/core/network/api/models/api_general.dart';
import 'package:fast_golden_taxi/core/network/api/parameters/general_parameters.dart';
import 'package:fast_golden_taxi/core/network/api/repositories/general_repository.dart';
import 'package:fast_golden_taxi/core/network/api_response.dart';
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';

/// General Repository Implementation
/// Implements the general repository interface using Dio for API calls
class GeneralRepositoryImpl implements GeneralRepository {
  final Dio _dio;

  GeneralRepositoryImpl(this._dio);

  @override
  Future<ApiResult<ApiResponse<ApiAboutUs>>> getAboutUs(GetAboutUsParameters parameters) async {
    try {
      final response = await _dio.get(GeneralEndpoints.getAboutUs);

      final apiResponse = ApiResponse<ApiAboutUs>.fromJson(
        response.data,
        (json) => ApiAboutUs.fromJson(json as Map<String, dynamic>),
      );

      return ApiResult.success(apiResponse);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const ApiResult.exception(TimeoutException());
      }
      if (e.type == DioExceptionType.connectionError) {
        return const ApiResult.exception(NoInternetException());
      }
      return ApiResult.exception(
        ServerException(
          message: e.message ?? 'Failed to get about us information',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(message: 'An unexpected error occurred: $e'),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse<List<ApiQuestion>>>> getQuestions(
    GetQuestionsParameters parameters,
  ) async {
    try {
      final response = await _dio.get(GeneralEndpoints.getQuestions);

      final apiResponse = ApiResponse<List<ApiQuestion>>.fromJson(
        response.data,
        (json) => (json as List)
            .map((item) => ApiQuestion.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

      return ApiResult.success(apiResponse);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const ApiResult.exception(TimeoutException());
      }
      if (e.type == DioExceptionType.connectionError) {
        return const ApiResult.exception(NoInternetException());
      }
      return ApiResult.exception(
        ServerException(
          message: e.message ?? 'Failed to get questions',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(message: 'An unexpected error occurred: $e'),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse<ApiPolicies>>> getPolicies(GetPoliciesParameters parameters) async {
    try {
      final response = await _dio.get(GeneralEndpoints.getPolicies);

      final apiResponse = ApiResponse<ApiPolicies>.fromJson(
        response.data,
        (json) => ApiPolicies.fromJson(json as Map<String, dynamic>),
      );

      return ApiResult.success(apiResponse);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const ApiResult.exception(TimeoutException());
      }
      if (e.type == DioExceptionType.connectionError) {
        return const ApiResult.exception(NoInternetException());
      }
      return ApiResult.exception(
        ServerException(
          message: e.message ?? 'Failed to get policies',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(message: 'An unexpected error occurred: $e'),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse<ApiGeneralSettings>>> getGeneralSettings(
    GetGeneralSettingsParameters parameters,
  ) async {
    try {
      final response = await _dio.get(GeneralEndpoints.getGeneralSettings);

      final apiResponse = ApiResponse<ApiGeneralSettings>.fromJson(
        response.data,
        (json) => ApiGeneralSettings.fromJson(json as Map<String, dynamic>),
      );

      return ApiResult.success(apiResponse);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const ApiResult.exception(TimeoutException());
      }
      if (e.type == DioExceptionType.connectionError) {
        return const ApiResult.exception(NoInternetException());
      }
      return ApiResult.exception(
        ServerException(
          message: e.message ?? 'Failed to get general settings',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(message: 'An unexpected error occurred: $e'),
      );
    }
  }
}
