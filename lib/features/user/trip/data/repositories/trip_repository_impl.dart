// lib/features/trip/data/repositories/trip_repository_impl.dart
import 'dart:async';

import 'package:fast_golden_taxi/core/network/base/repo/base_repository.dart';
import 'package:fast_golden_taxi/core/network/network_info.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/trip/data/datasources/trip_local_datasource.dart';
import 'package:fast_golden_taxi/features/user/trip/data/datasources/trip_remote_datasource.dart';
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
import 'package:fast_golden_taxi/features/user/trip/domain/entities/trip.dart';
import 'package:fast_golden_taxi/features/user/trip/domain/entities/trip_evaluation.dart';
import 'package:fast_golden_taxi/features/user/trip/domain/entities/trip_order.dart';
import 'package:fast_golden_taxi/features/user/trip/domain/entities/trip_type.dart';
import 'package:fast_golden_taxi/features/user/trip/domain/repositories/trip_repository.dart';

/// Implementation of [TripRepository].
///
/// Coordinates between remote and local data sources,
/// handles network connectivity, and manages trip state.
class TripRepositoryImpl extends BaseRepository implements TripRepository {
  TripRepositoryImpl({
    required TripRemoteDataSource remoteDataSource,
    required TripLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  final TripRemoteDataSource _remoteDataSource;
  final TripLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  // Stream controllers for trip updates
  final _tripTypesController = StreamController<List<TripType>>.broadcast();
  final _tripHistoryController = StreamController<List<Trip>>.broadcast();
  final _ordersController = StreamController<List<TripOrder>>.broadcast();

  @override
  NetworkInfo get networkInfo => _networkInfo;

  // ==================== Trip Types ====================

  @override
  Future<ApiResult<List<TripType>>> getTripTypes(GetTripTypesParameters parameters) async {
    final result = await fetchWithCache<List<TripTypeModel>>(
      cacheKey: 'trip_types',
      remoteFetcher: () => _remoteDataSource.getTripTypes(parameters),
      localFetcher: _localDataSource.getCachedTripTypes,
      cacheSaver: _localDataSource.saveTripTypes,
      maxCacheAge: const Duration(hours: 1),
    );

    return result.when(
      success: (data, error) {
        final tripTypes = data.map((e) => e.toEntity()).toList();
        _tripTypesController.add(tripTypes);
        return ApiResult.success(tripTypes, error);
      },
      exception: ApiResult.exception,
    );
  }

  // ==================== Trip CRUD ====================

  @override
  Future<ApiResult<Trip>> getTripDetail(GetTripDetailParameters parameters) async {
    final result = await fetchWithCache<TripModel>(
      cacheKey: 'trip_${parameters.tripId}',
      remoteFetcher: () => _remoteDataSource.getTripDetail(parameters),
      localFetcher: () => _localDataSource.getCachedTrip(parameters.tripId.toString()),
      cacheSaver: _localDataSource.saveTrip,
      maxCacheAge: const Duration(minutes: 5),
    );

    return result.when(
      success: (data, error) => ApiResult.success(data.toEntity(), error),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<Trip>> getCaptainTripDetail(GetCaptainTripDetailParameters parameters) async {
    final result = await executeRemoteRequest<TripModel>(
      request: () => _remoteDataSource.getCaptainTripDetail(parameters),
    );

    return result.when(
      success: (data, error) => ApiResult.success(data.toEntity(), error),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<List<Trip>>> getTripHistory(GetTripHistoryParameters parameters) async {
    final result = await fetchWithCache<List<TripModel>>(
      cacheKey: 'trip_history',
      remoteFetcher: () => _remoteDataSource.getTripHistory(parameters),
      localFetcher: _localDataSource.getCachedTripHistory,
      cacheSaver: _localDataSource.saveTripHistory,
      maxCacheAge: const Duration(minutes: 5),
    );

    return result.when(
      success: (data, error) {
        final trips = data.map((e) => e.toEntity()).toList();
        _tripHistoryController.add(trips);
        return ApiResult.success(trips, error);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<List<Trip>>> getAvailablePublicTrips(
    GetAvailablePublicTripsParameters parameters,
  ) async {
    final result = await executeRemoteRequest<List<TripModel>>(
      request: () => _remoteDataSource.getAvailablePublicTrips(parameters),
    );

    return result.when(
      success: (data, error) => ApiResult.success(data.map((e) => e.toEntity()).toList(), error),
      exception: ApiResult.exception,
    );
  }

  // ==================== Trip Creation ====================

  @override
  Future<ApiResult<Trip>> storePublicTrip(StorePublicTripParameters parameters) async {
    final result = await executeRemoteRequest<TripModel>(
      request: () => _remoteDataSource.storePublicTrip(parameters),
    );

    return result.when(
      success: (data, error) async {
        await _localDataSource.saveTrip(data);
        return ApiResult.success(data.toEntity(), error);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<Trip>> storePrivateTrip(StorePrivateTripParameters parameters) async {
    final result = await executeRemoteRequest<TripModel>(
      request: () => _remoteDataSource.storePrivateTrip(parameters),
    );

    return result.when(
      success: (data, error) async {
        await _localDataSource.saveTrip(data);
        return ApiResult.success(data.toEntity(), error);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<Trip>> editPrivateTrip(EditPrivateTripParameters parameters) async {
    final result = await executeRemoteRequest<TripModel>(
      request: () => _remoteDataSource.editPrivateTrip(parameters),
    );

    return result.when(
      success: (data, error) async {
        await _localDataSource.saveTrip(data);
        return ApiResult.success(data.toEntity(), error);
      },
      exception: ApiResult.exception,
    );
  }

  // ==================== Trip Actions ====================

  @override
  Future<ApiResult<Trip>> confirmTrip(ConfirmTripParameters parameters) async {
    final result = await executeRemoteRequest<TripModel>(
      request: () => _remoteDataSource.confirmTrip(parameters),
    );

    return result.when(
      success: (data, error) async {
        await _localDataSource.saveTrip(data);
        return ApiResult.success(data.toEntity(), error);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<void>> cancelTrip(CancelTripParameters parameters) async {
    final result = await executeRemoteRequest<void>(
      request: () => _remoteDataSource.cancelTrip(parameters),
    );

    return result.when(
      success: (_, error) => const ApiResult.success(null),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<void>> reportTrip(ReportTripParameters parameters) async {
    final result = await executeRemoteRequest<void>(
      request: () => _remoteDataSource.reportTrip(parameters),
    );

    return result.when(
      success: (_, error) => const ApiResult.success(null),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<TripEvaluation>> tripEvaluation(TripEvaluationParameters parameters) async {
    final result = await executeRemoteRequest<TripEvaluationModel>(
      request: () => _remoteDataSource.tripEvaluation(parameters),
    );

    return result.when(
      success: (data, error) => ApiResult.success(data.toEntity(), error),
      exception: ApiResult.exception,
    );
  }

  // ==================== Orders ====================

  @override
  Future<ApiResult<TripOrder>> bookNowOrder(BookNowOrderParameters parameters) async {
    final result = await executeRemoteRequest<TripOrderModel>(
      request: () => _remoteDataSource.bookNowOrder(parameters),
    );

    return result.when(
      success: (data, error) async {
        await _localDataSource.saveOrder(data);
        return ApiResult.success(data.toEntity(), error);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<List<TripOrder>>> getMyOrders(GetMyOrdersParameters parameters) async {
    final result = await fetchWithCache<List<TripOrderModel>>(
      cacheKey: 'my_orders',
      remoteFetcher: () => _remoteDataSource.getMyOrders(parameters),
      localFetcher: _localDataSource.getCachedOrders,
      cacheSaver: _localDataSource.saveOrders,
      maxCacheAge: const Duration(minutes: 5),
    );

    return result.when(
      success: (data, error) {
        final orders = data.map((e) => e.toEntity()).toList();
        _ordersController.add(orders);
        return ApiResult.success(orders, error);
      },
      exception: ApiResult.exception,
    );
  }

  /// Disposes resources.
  void dispose() {
    _tripTypesController.close();
    _tripHistoryController.close();
    _ordersController.close();
  }
}
