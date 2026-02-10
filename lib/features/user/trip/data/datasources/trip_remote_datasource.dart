// lib/features/trip/data/datasources/trip_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/core/network/api_client.dart';
import 'package:fast_golden_taxi/core/network/base/datasource/base_data_source.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/trip/data/endpoints/trip_endpoints.dart';
import 'package:fast_golden_taxi/features/user/trip/data/models/trip_evaluation_model.dart';
import 'package:fast_golden_taxi/features/user/trip/data/models/trip_model.dart';
import 'package:fast_golden_taxi/features/user/trip/data/models/trip_order_model.dart';
import 'package:fast_golden_taxi/features/user/trip/data/models/trip_type_model.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/book_now_order_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/cancel_trip_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/confirm_trip_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/edit_private_trip_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/get_available_public_trips_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/get_captain_trip_detail_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/get_my_orders_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/get_trip_detail_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/get_trip_history_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/get_trip_types_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/report_trip_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/store_private_trip_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/store_public_trip_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/trip_evaluation_parameters.dart';

/// Remote data source for trip operations.
///
/// Handles all HTTP requests related to trips.
/// Returns ApiResult with success or error data.
abstract class TripRemoteDataSource {
  /// Get trip types.
  Future<ApiResult<List<TripTypeModel>>> getTripTypes(GetTripTypesParameters parameters);

  /// Get trip details.
  Future<ApiResult<TripModel>> getTripDetail(GetTripDetailParameters parameters);

  /// Get captain's trip details.
  Future<ApiResult<TripModel>> getCaptainTripDetail(GetCaptainTripDetailParameters parameters);

  /// Get trip history.
  Future<ApiResult<List<TripModel>>> getTripHistory(GetTripHistoryParameters parameters);

  /// Get available public trips.
  Future<ApiResult<List<TripModel>>> getAvailablePublicTrips(
    GetAvailablePublicTripsParameters parameters,
  );

  /// Create a public trip.
  Future<ApiResult<TripModel>> storePublicTrip(StorePublicTripParameters parameters);

  /// Create a private trip.
  Future<ApiResult<TripModel>> storePrivateTrip(StorePrivateTripParameters parameters);

  /// Edit a private trip.
  Future<ApiResult<TripModel>> editPrivateTrip(EditPrivateTripParameters parameters);

  /// Confirm a trip.
  Future<ApiResult<TripModel>> confirmTrip(ConfirmTripParameters parameters);

  /// Cancel a trip.
  Future<ApiResult<void>> cancelTrip(CancelTripParameters parameters);

  /// Report a trip.
  Future<ApiResult<void>> reportTrip(ReportTripParameters parameters);

  /// Evaluate a trip.
  Future<ApiResult<TripEvaluationModel>> tripEvaluation(TripEvaluationParameters parameters);

  /// Book a trip now.
  Future<ApiResult<TripOrderModel>> bookNowOrder(BookNowOrderParameters parameters);

  /// Get user's orders.
  Future<ApiResult<List<TripOrderModel>>> getMyOrders(GetMyOrdersParameters parameters);
}

/// Implementation of [TripRemoteDataSource] using BaseRemoteDataSource.
class TripRemoteDataSourceImpl with BaseRemoteDataSource implements TripRemoteDataSource {
  const TripRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  @override
  Future<ApiResult<List<TripTypeModel>>> getTripTypes(GetTripTypesParameters parameters) async {
    return get<List<TripTypeModel>>(
      path: TripEndpoints.getTripTypes,
      cancelToken: parameters.cancelToken,
      decoder: (data) => (data as List)
          .map((item) => TripTypeModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResult<TripModel>> getTripDetail(GetTripDetailParameters parameters) async {
    return get<TripModel>(
      path: TripEndpoints.getTripDetail,
      queryParameters: parameters.toJson(),
      cancelToken: parameters.cancelToken,
      decoder: (data) => TripModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<TripModel>> getCaptainTripDetail(
    GetCaptainTripDetailParameters parameters,
  ) async {
    return get<TripModel>(
      path: TripEndpoints.getCaptainTripDetail,
      queryParameters: parameters.toJson(),
      cancelToken: parameters.cancelToken,
      decoder: (data) => TripModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<List<TripModel>>> getTripHistory(GetTripHistoryParameters parameters) async {
    return get<List<TripModel>>(
      path: TripEndpoints.getTripHistory,
      queryParameters: parameters.toJson(),
      cancelToken: parameters.cancelToken,
      decoder: (data) =>
          (data as List).map((item) => TripModel.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  @override
  Future<ApiResult<List<TripModel>>> getAvailablePublicTrips(
    GetAvailablePublicTripsParameters parameters,
  ) async {
    return get<List<TripModel>>(
      path: TripEndpoints.getAvailablePublicTrips,
      queryParameters: parameters.toJson(),
      cancelToken: parameters.cancelToken,
      decoder: (data) =>
          (data as List).map((item) => TripModel.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  @override
  Future<ApiResult<TripModel>> storePublicTrip(StorePublicTripParameters parameters) async {
    return post<TripModel>(
      path: TripEndpoints.storePublicTrip,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
      decoder: (data) => TripModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<TripModel>> storePrivateTrip(StorePrivateTripParameters parameters) async {
    return post<TripModel>(
      path: TripEndpoints.storePrivateTrip,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
      decoder: (data) => TripModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<TripModel>> editPrivateTrip(EditPrivateTripParameters parameters) async {
    return post<TripModel>(
      path: TripEndpoints.editPrivateTrip,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
      decoder: (data) => TripModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<TripModel>> confirmTrip(ConfirmTripParameters parameters) async {
    return post<TripModel>(
      path: TripEndpoints.confirmTrip,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
      decoder: (data) => TripModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<void>> cancelTrip(CancelTripParameters parameters) async {
    return post<void>(
      path: TripEndpoints.cancelTrip,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
    );
  }

  @override
  Future<ApiResult<void>> reportTrip(ReportTripParameters parameters) async {
    return post<void>(
      path: TripEndpoints.reportTrip,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
    );
  }

  @override
  Future<ApiResult<TripEvaluationModel>> tripEvaluation(TripEvaluationParameters parameters) async {
    return get<TripEvaluationModel>(
      path: TripEndpoints.tripEvaluation,
      queryParameters: parameters.toJson(),
      cancelToken: parameters.cancelToken,
      decoder: (data) => TripEvaluationModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<TripOrderModel>> bookNowOrder(BookNowOrderParameters parameters) async {
    return post<TripOrderModel>(
      path: TripEndpoints.bookNowOrder,
      data: parameters.toJson(),
      cancelToken: parameters.cancelToken,
      decoder: (data) => TripOrderModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<List<TripOrderModel>>> getMyOrders(GetMyOrdersParameters parameters) async {
    return get<List<TripOrderModel>>(
      path: TripEndpoints.getMyOrders,
      queryParameters: parameters.toJson(),
      cancelToken: parameters.cancelToken,
      decoder: (data) => (data as List)
          .map((item) => TripOrderModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
