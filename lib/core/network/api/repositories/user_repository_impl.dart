import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/core/network/api/endpoints/user_endpoints.dart';
import 'package:fast_golden_taxi/core/network/api/models/api_user_profile.dart';
import 'package:fast_golden_taxi/core/network/api/parameters/user_parameters.dart';
import 'package:fast_golden_taxi/core/network/api/repositories/user_repository.dart';
import 'package:fast_golden_taxi/core/network/api_response.dart';
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';

/// User Repository Implementation
/// Handles all user-related API calls
class UserRepositoryImpl implements UserRepository {
  final Dio _dio;

  UserRepositoryImpl(this._dio);

  @override
  Future<ApiResult<ApiResponse<ApiUserProfile>>> getProfile(GetProfileParameters parameters) async {
    try {
      final response = await _dio.get(UserEndpoints.profile, cancelToken: parameters.cancelToken);

      if (response.statusCode == 200) {
        final profile = ApiUserProfile.fromJson(response.data['data']);

        return ApiResult.success(ApiResponse.success(profile, statusCode: response.statusCode));
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Failed to get profile',
            statusCode: response.statusCode,
          ),
        );
      }
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
          message: e.response?.data['message'] ?? e.message ?? 'Failed to get profile',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(message: 'An unexpected error occurred: $e', exception: e),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse<ApiUserProfile>>> updateProfile(
    UpdateProfileParameters parameters,
  ) async {
    try {
      final response = await _dio.put(
        UserEndpoints.updateInfo,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final profile = ApiUserProfile.fromJson(response.data['data']);

        return ApiResult.success(ApiResponse.success(profile, statusCode: response.statusCode));
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Failed to update profile',
            statusCode: response.statusCode,
          ),
        );
      }
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
          message: e.response?.data['message'] ?? e.message ?? 'Failed to update profile',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(message: 'An unexpected error occurred: $e', exception: e),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse<ApiUserProfile>>> getProfileDetail(
    GetProfileParameters parameters,
  ) async {
    try {
      final response = await _dio.get(
        UserEndpoints.profileDetail,
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200) {
        final profile = ApiUserProfile.fromJson(response.data['data']);

        return ApiResult.success(ApiResponse.success(profile, statusCode: response.statusCode));
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Failed to get profile detail',
            statusCode: response.statusCode,
          ),
        );
      }
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
          message: e.response?.data['message'] ?? e.message ?? 'Failed to get profile detail',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(message: 'An unexpected error occurred: $e', exception: e),
      );
    }
  }
}
