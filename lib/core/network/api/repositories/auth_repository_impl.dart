import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api/endpoints/auth_endpoints.dart';
import 'package:flavorizr/core/network/api/models/api_user.dart';
import 'package:flavorizr/core/network/api/parameters/auth_parameters.dart';
import 'package:flavorizr/core/network/api/repositories/auth_repository.dart';
import 'package:flavorizr/core/network/api_response.dart';
import 'package:flavorizr/core/network/exception/network_exceptions.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/auth/data/parameters/refresh_token_parameters.dart';

/// Auth Repository Implementation
/// Handles all authentication-related API calls
class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  const AuthRepositoryImpl(this._dio);

  @override
  Future<ApiResult<ApiResponse<ApiAuthResponse>>> login(LoginParameters parameters) async {
    try {
      final response = await _dio.post(
        AuthEndpoints.login,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = ApiAuthResponse.fromJson(response.data['data']);

        // Update the authorization header with the new token
        _dio.options.headers['Authorization'] = 'Bearer ${authResponse.token}';
        return ApiResult.success(
          ApiResponse.success(authResponse, statusCode: response.statusCode),
        );
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Login failed',
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
          message: e.response?.data['message'] ?? e.message ?? 'Login failed',
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
  Future<ApiResult<ApiResponse<ApiAuthResponse>>> register(RegisterParameters parameters) async {
    try {
      final response = await _dio.post(
        AuthEndpoints.register,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = ApiAuthResponse.fromJson(response.data['data']);

        // Update the authorization header with the new token
        _dio.options.headers['Authorization'] = 'Bearer ${authResponse.token}';

        return ApiResult.success(
          ApiResponse.success(authResponse, statusCode: response.statusCode),
        );
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Registration failed',
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
          message: e.response?.data['message'] ?? e.message ?? 'Registration failed',
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
  Future<ApiResult<ApiResponse<void>>> logout(LogoutParameters parameters) async {
    try {
      final response = await _dio.post(AuthEndpoints.logout, cancelToken: parameters.cancelToken);

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Clear the authorization header
        _dio.options.headers.remove('Authorization');

        return ApiResult.success(ApiResponse.success(null, statusCode: response.statusCode));
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Logout failed',
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
          message: e.response?.data['message'] ?? e.message ?? 'Logout failed',
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
  Future<ApiResult<ApiResponse<ApiAuthResponse>>> refreshToken(
    RefreshTokenParameters parameters,
  ) async {
    try {
      final response = await _dio.post(
        AuthEndpoints.refreshToken,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = ApiAuthResponse.fromJson(response.data['data']);

        // Update the authorization header with the new token
        _dio.options.headers['Authorization'] = 'Bearer ${authResponse.token}';

        return ApiResult.success(
          ApiResponse.success(authResponse, statusCode: response.statusCode),
        );
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Token refresh failed',
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
          message: e.response?.data['message'] ?? e.message ?? 'Token refresh failed',
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
  Future<ApiResult<ApiResponse<ApiUser>>> verifyUser(VerifyUserParameters parameters) async {
    try {
      final response = await _dio.post(
        AuthEndpoints.verifyUser,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final user = ApiUser.fromJson(response.data['data']);

        return ApiResult.success(ApiResponse.success(user, statusCode: response.statusCode));
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'User verification failed',
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
          message: e.response?.data['message'] ?? e.message ?? 'User verification failed',
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
  Future<ApiResult<ApiResponse<void>>> resetPassword(ResetPasswordParameters parameters) async {
    try {
      final response = await _dio.post(
        AuthEndpoints.resetPassword,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResult.success(ApiResponse.success(null, statusCode: response.statusCode));
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Password reset failed',
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
          message: e.response?.data['message'] ?? e.message ?? 'Password reset failed',
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
  Future<ApiResult<ApiResponse<void>>> forgetPassword(ForgetPasswordParameters parameters) async {
    try {
      final response = await _dio.post(
        AuthEndpoints.forgetPassword,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResult.success(ApiResponse.success(null, statusCode: response.statusCode));
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Forget password request failed',
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
          message: e.response?.data['message'] ?? e.message ?? 'Forget password request failed',
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
  Future<ApiResult<ApiResponse<void>>> confirmationCode(
    ConfirmationCodeParameters parameters,
  ) async {
    try {
      final response = await _dio.post(
        AuthEndpoints.confirmationCode,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResult.success(ApiResponse.success(null, statusCode: response.statusCode));
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Confirmation code request failed',
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
          message: e.response?.data['message'] ?? e.message ?? 'Confirmation code request failed',
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
