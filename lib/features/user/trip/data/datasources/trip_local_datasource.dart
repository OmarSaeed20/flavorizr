// lib/features/trip/data/datasources/trip_local_datasource.dart
import 'dart:convert';

import 'package:fast_golden_taxi/core/network/base/datasource/base_local_data_source.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/trip/data/models/trip_model.dart';
import 'package:fast_golden_taxi/features/user/trip/data/models/trip_order_model.dart';
import 'package:fast_golden_taxi/features/user/trip/data/models/trip_type_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for trip operations.
///
/// Handles local storage and caching of trip data.
abstract class TripLocalDataSource {
  /// Save trip types to local cache.
  Future<ApiResult<void>> saveTripTypes(List<TripTypeModel> tripTypes);

  /// Get cached trip types.
  Future<ApiResult<List<TripTypeModel>>> getCachedTripTypes();

  /// Save trip to local cache.
  Future<ApiResult<void>> saveTrip(TripModel trip);

  /// Get cached trip by ID.
  Future<ApiResult<TripModel>> getCachedTrip(String tripId);

  /// Save trip history to local cache.
  Future<ApiResult<void>> saveTripHistory(List<TripModel> trips);

  /// Get cached trip history.
  Future<ApiResult<List<TripModel>>> getCachedTripHistory();

  /// Save order to local cache.
  Future<ApiResult<void>> saveOrder(TripOrderModel order);

  /// Get cached order by ID.
  Future<ApiResult<TripOrderModel>> getCachedOrder(String orderId);

  /// Save orders to local cache.
  Future<ApiResult<void>> saveOrders(List<TripOrderModel> orders);

  /// Get cached orders.
  Future<ApiResult<List<TripOrderModel>>> getCachedOrders();

  /// Clear all cached trip data.
  Future<ApiResult<void>> clearCache();
}

/// Implementation of [TripLocalDataSource] using BaseLocalDataSource.
class TripLocalDataSourceImpl
    with BaseLocalDataSource
    implements TripLocalDataSource {
  TripLocalDataSourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  static const String _tripTypesKey = 'cached_trip_types';
  static const String _tripHistoryKey = 'cached_trip_history';
  static const String _ordersKey = 'cached_orders';
  static const String _tripPrefix = 'cached_trip_';
  static const String _orderPrefix = 'cached_order_';

  final SharedPreferences _prefs;

  @override
  Future<ApiResult<void>> saveTripTypes(List<TripTypeModel> tripTypes) async {
    return saveLocalDataList<TripTypeModel>(
      key: _tripTypesKey,
      data: tripTypes,
      saver: (data) async {
        final json = jsonEncode(data.map((t) => t.toJson()).toList());
        await _prefs.setString(_tripTypesKey, json);
      },
    );
  }

  @override
  Future<ApiResult<List<TripTypeModel>>> getCachedTripTypes() async {
    return getLocalData<List<TripTypeModel>>(
      key: _tripTypesKey,
      fetcher: () async {
        final json = _prefs.getString(_tripTypesKey);
        if (json == null) return null;

        try {
          final list = jsonDecode(json) as List<dynamic>;
          return list
              .map((e) => TripTypeModel.fromJson(e as Map<String, dynamic>))
              .toList();
        } catch (_) {
          return null;
        }
      },
    );
  }

  @override
  Future<ApiResult<void>> saveTrip(TripModel trip) async {
    return saveLocalData<TripModel>(
      key: '$_tripPrefix${trip.id}',
      data: trip,
      saver: (data) async {
        final json = jsonEncode(data.toJson());
        await _prefs.setString('$_tripPrefix${trip.id}', json);
      },
    );
  }

  @override
  Future<ApiResult<TripModel>> getCachedTrip(String tripId) async {
    return getLocalData<TripModel>(
      key: '$_tripPrefix$tripId',
      fetcher: () async {
        final json = _prefs.getString('$_tripPrefix$tripId');
        if (json == null) return null;

        try {
          final map = jsonDecode(json) as Map<String, dynamic>;
          return TripModel.fromJson(map);
        } catch (_) {
          return null;
        }
      },
    );
  }

  @override
  Future<ApiResult<void>> saveTripHistory(List<TripModel> trips) async {
    return saveLocalDataList<TripModel>(
      key: _tripHistoryKey,
      data: trips,
      saver: (data) async {
        final json = jsonEncode(data.map((t) => t.toJson()).toList());
        await _prefs.setString(_tripHistoryKey, json);
      },
    );
  }

  @override
  Future<ApiResult<List<TripModel>>> getCachedTripHistory() async {
    return getLocalData<List<TripModel>>(
      key: _tripHistoryKey,
      fetcher: () async {
        final json = _prefs.getString(_tripHistoryKey);
        if (json == null) return null;

        try {
          final list = jsonDecode(json) as List<dynamic>;
          return list
              .map((e) => TripModel.fromJson(e as Map<String, dynamic>))
              .toList();
        } catch (_) {
          return null;
        }
      },
    );
  }

  @override
  Future<ApiResult<void>> saveOrder(TripOrderModel order) async {
    return saveLocalData<TripOrderModel>(
      key: '$_orderPrefix${order.id}',
      data: order,
      saver: (data) async {
        final json = jsonEncode(data.toJson());
        await _prefs.setString('$_orderPrefix${order.id}', json);
      },
    );
  }

  @override
  Future<ApiResult<TripOrderModel>> getCachedOrder(String orderId) async {
    return getLocalData<TripOrderModel>(
      key: '$_orderPrefix$orderId',
      fetcher: () async {
        final json = _prefs.getString('$_orderPrefix$orderId');
        if (json == null) return null;

        try {
          final map = jsonDecode(json) as Map<String, dynamic>;
          return TripOrderModel.fromJson(map);
        } catch (_) {
          return null;
        }
      },
    );
  }

  @override
  Future<ApiResult<void>> saveOrders(List<TripOrderModel> orders) async {
    return saveLocalDataList<TripOrderModel>(
      key: _ordersKey,
      data: orders,
      saver: (data) async {
        final json = jsonEncode(data.map((o) => o.toJson()).toList());
        await _prefs.setString(_ordersKey, json);
      },
    );
  }

  @override
  Future<ApiResult<List<TripOrderModel>>> getCachedOrders() async {
    return getLocalData<List<TripOrderModel>>(
      key: _ordersKey,
      fetcher: () async {
        final json = _prefs.getString(_ordersKey);
        if (json == null) return null;

        try {
          final list = jsonDecode(json) as List<dynamic>;
          return list
              .map((e) => TripOrderModel.fromJson(e as Map<String, dynamic>))
              .toList();
        } catch (_) {
          return null;
        }
      },
    );
  }

  @override
  Future<ApiResult<void>> clearCache() async {
    return clearAllLocalData(
      clearer: () async {
        await _prefs.remove(_tripTypesKey);
        await _prefs.remove(_tripHistoryKey);
        await _prefs.remove(_ordersKey);

        // Clear all individual trip and order caches
        final keys = _prefs.getKeys();
        for (final key in keys) {
          if (key.startsWith(_tripPrefix) || key.startsWith(_orderPrefix)) {
            await _prefs.remove(key);
          }
        }
      },
    );
  }
}
