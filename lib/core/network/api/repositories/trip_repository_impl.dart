import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api/endpoints/trip_endpoints.dart';
import 'package:flavorizr/core/network/api/models/api_trip.dart';
import 'package:flavorizr/core/network/api/parameters/trip_parameters.dart';
import 'package:flavorizr/core/network/api/repositories/trip_repository.dart';
import 'package:flavorizr/core/network/api_response.dart';
import 'package:flavorizr/core/network/exception/network_exceptions.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';

/// Trip Repository Implementation
/// Handles all trip-related API calls
class TripRepositoryImpl implements TripRepository {
  final Dio _dio;

  TripRepositoryImpl(this._dio);

  @override
  Future<ApiResult<ApiResponse<List<ApiTripType>>>> getTripTypes(
    GetTripTypesParameters parameters,
  ) async {
    try {
      final response = await _dio.get(
        TripEndpoints.typesByLocation,
        queryParameters: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final tripTypes = data
            .map((json) => ApiTripType.fromJson(json))
            .toList();

        return ApiResult.success(
          ApiResponse.success(tripTypes, statusCode: response.statusCode),
        );
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Failed to get trip types',
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
          message:
              e.response?.data['message'] ??
              e.message ??
              'Failed to get trip types',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(
          message: 'An unexpected error occurred: $e',
          exception: e,
        ),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse<ApiTrip>>> getCaptainTripDetail(
    GetCaptainTripDetailParameters parameters,
  ) async {
    try {
      final response = await _dio.get(
        TripEndpoints.captainDetail,
        queryParameters: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200) {
        final trip = ApiTrip.fromJson(response.data['data']);

        return ApiResult.success(
          ApiResponse.success(trip, statusCode: response.statusCode),
        );
      } else {
        return ApiResult.exception(
          ServerException(
            message:
                response.data['message'] ?? 'Failed to get captain trip detail',
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
          message:
              e.response?.data['message'] ??
              e.message ??
              'Failed to get captain trip detail',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(
          message: 'An unexpected error occurred: $e',
          exception: e,
        ),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse<ApiTrip>>> storePublicTrip(
    StorePublicTripParameters parameters,
  ) async {
    try {
      final response = await _dio.post(
        TripEndpoints.storePublic,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final trip = ApiTrip.fromJson(response.data['data']);

        return ApiResult.success(
          ApiResponse.success(trip, statusCode: response.statusCode),
        );
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Failed to store public trip',
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
          message:
              e.response?.data['message'] ??
              e.message ??
              'Failed to store public trip',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(
          message: 'An unexpected error occurred: $e',
          exception: e,
        ),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse<ApiTrip>>> storePrivateTrip(
    StorePrivateTripParameters parameters,
  ) async {
    try {
      final response = await _dio.post(
        TripEndpoints.storePrivate,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final trip = ApiTrip.fromJson(response.data['data']);

        return ApiResult.success(
          ApiResponse.success(trip, statusCode: response.statusCode),
        );
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Failed to store private trip',
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
          message:
              e.response?.data['message'] ??
              e.message ??
              'Failed to store private trip',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(
          message: 'An unexpected error occurred: $e',
          exception: e,
        ),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse<ApiTrip>>> editPrivateTrip(
    EditPrivateTripParameters parameters,
  ) async {
    try {
      final response = await _dio.put(
        TripEndpoints.editPrivate,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final trip = ApiTrip.fromJson(response.data['data']);

        return ApiResult.success(
          ApiResponse.success(trip, statusCode: response.statusCode),
        );
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Failed to edit private trip',
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
          message:
              e.response?.data['message'] ??
              e.message ??
              'Failed to edit private trip',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(
          message: 'An unexpected error occurred: $e',
          exception: e,
        ),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse<ApiTripOrder>>> bookNowOrder(
    BookNowOrderParameters parameters,
  ) async {
    try {
      final response = await _dio.post(
        TripEndpoints.bookNow,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final order = ApiTripOrder.fromJson(response.data['data']);

        return ApiResult.success(
          ApiResponse.success(order, statusCode: response.statusCode),
        );
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Failed to book order',
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
          message:
              e.response?.data['message'] ??
              e.message ??
              'Failed to book order',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(
          message: 'An unexpected error occurred: $e',
          exception: e,
        ),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse<List<ApiTrip>>>> getTripHistory(
    GetTripHistoryParameters parameters,
  ) async {
    try {
      final response = await _dio.get(
        TripEndpoints.history,
        queryParameters: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final trips = data.map((json) => ApiTrip.fromJson(json)).toList();

        return ApiResult.success(
          ApiResponse.success(trips, statusCode: response.statusCode),
        );
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Failed to get trip history',
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
          message:
              e.response?.data['message'] ??
              e.message ??
              'Failed to get trip history',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(
          message: 'An unexpected error occurred: $e',
          exception: e,
        ),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse<List<ApiTripOrder>>>> getMyOrders(
    GetMyOrdersParameters parameters,
  ) async {
    try {
      final response = await _dio.get(
        TripEndpoints.myOrders,
        queryParameters: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final orders = data.map((json) => ApiTripOrder.fromJson(json)).toList();

        return ApiResult.success(
          ApiResponse.success(orders, statusCode: response.statusCode),
        );
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Failed to get my orders',
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
          message:
              e.response?.data['message'] ??
              e.message ??
              'Failed to get my orders',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(
          message: 'An unexpected error occurred: $e',
          exception: e,
        ),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse<List<ApiTrip>>>> getAvailablePublicTrips(
    GetAvailablePublicTripsParameters parameters,
  ) async {
    try {
      final response = await _dio.get(
        TripEndpoints.availablePublic,
        queryParameters: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final trips = data.map((json) => ApiTrip.fromJson(json)).toList();

        return ApiResult.success(
          ApiResponse.success(trips, statusCode: response.statusCode),
        );
      } else {
        return ApiResult.exception(
          ServerException(
            message:
                response.data['message'] ??
                'Failed to get available public trips',
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
          message:
              e.response?.data['message'] ??
              e.message ??
              'Failed to get available public trips',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(
          message: 'An unexpected error occurred: $e',
          exception: e,
        ),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse<ApiTrip>>> confirmTrip(
    ConfirmTripParameters parameters,
  ) async {
    try {
      final response = await _dio.post(
        TripEndpoints.confirm,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final trip = ApiTrip.fromJson(response.data['data']);

        return ApiResult.success(
          ApiResponse.success(trip, statusCode: response.statusCode),
        );
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Failed to confirm trip',
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
          message:
              e.response?.data['message'] ??
              e.message ??
              'Failed to confirm trip',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(
          message: 'An unexpected error occurred: $e',
          exception: e,
        ),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse<void>>> cancelTrip(
    CancelTripParameters parameters,
  ) async {
    try {
      final response = await _dio.post(
        TripEndpoints.cancel,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return ApiResult.success(
          ApiResponse.success(null, statusCode: response.statusCode),
        );
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Failed to cancel trip',
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
          message:
              e.response?.data['message'] ??
              e.message ??
              'Failed to cancel trip',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(
          message: 'An unexpected error occurred: $e',
          exception: e,
        ),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse<void>>> reportTrip(
    ReportTripParameters parameters,
  ) async {
    try {
      final response = await _dio.post(
        TripEndpoints.report,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResult.success(
          ApiResponse.success(null, statusCode: response.statusCode),
        );
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Failed to report trip',
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
          message:
              e.response?.data['message'] ??
              e.message ??
              'Failed to report trip',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(
          message: 'An unexpected error occurred: $e',
          exception: e,
        ),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse<ApiTripEvaluation>>> tripEvaluation(
    TripEvaluationParameters parameters,
  ) async {
    try {
      final response = await _dio.post(
        TripEndpoints.evaluation,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final evaluation = ApiTripEvaluation.fromJson(response.data['data']);

        return ApiResult.success(
          ApiResponse.success(evaluation, statusCode: response.statusCode),
        );
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Failed to evaluate trip',
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
          message:
              e.response?.data['message'] ??
              e.message ??
              'Failed to evaluate trip',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(
          message: 'An unexpected error occurred: $e',
          exception: e,
        ),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse<ApiTrip>>> getTripDetail(
    GetTripDetailParameters parameters,
  ) async {
    try {
      final response = await _dio.get(
        TripEndpoints.detail,
        queryParameters: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      );

      if (response.statusCode == 200) {
        final trip = ApiTrip.fromJson(response.data['data']);

        return ApiResult.success(
          ApiResponse.success(trip, statusCode: response.statusCode),
        );
      } else {
        return ApiResult.exception(
          ServerException(
            message: response.data['message'] ?? 'Failed to get trip detail',
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
          message:
              e.response?.data['message'] ??
              e.message ??
              'Failed to get trip detail',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(
          message: 'An unexpected error occurred: $e',
          exception: e,
        ),
      );
    }
  }
}
