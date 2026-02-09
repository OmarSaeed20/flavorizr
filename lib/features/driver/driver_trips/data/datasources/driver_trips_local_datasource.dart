import 'dart:convert';

import 'package:fast_golden_taxi/core/network/base/datasource/base_local_data_source.dart';
import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/data/models/driver_trip_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for driver trips operations.
///
/// Handles all local storage operations related to driver trip management.
/// Uses SharedPreferences for caching trip data.
abstract class DriverTripsLocalDataSource {
  /// Gets cached scheduled trips.
  Future<ApiResult<List<DriverTripModel>>> getCachedScheduleTrips();

  /// Saves scheduled trips to cache.
  Future<ApiResult<void>> cacheScheduleTrips(List<DriverTripModel> trips);

  /// Gets cached schedule requests.
  Future<ApiResult<List<DriverTripModel>>> getCachedScheduleRequests();

  /// Saves schedule requests to cache.
  Future<ApiResult<void>> cacheScheduleRequests(List<DriverTripModel> requests);

  /// Clears all cached trip data.
  Future<ApiResult<void>> clearTripsCache();
}

/// Implementation of [DriverTripsLocalDataSource] using BaseLocalDataSource.
class DriverTripsLocalDataSourceImpl
    with BaseLocalDataSource
    implements DriverTripsLocalDataSource {
  DriverTripsLocalDataSourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  static const String _scheduleTripsKey = 'driver_schedule_trips';
  static const String _scheduleRequestsKey = 'driver_schedule_requests';

  final SharedPreferences _prefs;

  @override
  Future<ApiResult<List<DriverTripModel>>> getCachedScheduleTrips() async {
    return getLocalDataList<DriverTripModel>(
      key: _scheduleTripsKey,
      fetcher: () async {
        final json = _prefs.getString(_scheduleTripsKey);
        if (json == null) return null;
        try {
          final list = jsonDecode(json) as List<dynamic>;
          return list.map((e) => DriverTripModel.fromJson(e as Map<String, dynamic>)).toList();
        } catch (_) {
          return null;
        }
      },
    );
  }

  @override
  Future<ApiResult<void>> cacheScheduleTrips(List<DriverTripModel> trips) async {
    return saveLocalDataList<DriverTripModel>(
      key: _scheduleTripsKey,
      data: trips,
      saver: (data) async {
        final json = jsonEncode(data.map((e) => e.toJson()).toList());
        await _prefs.setString(_scheduleTripsKey, json);
      },
    );
  }

  @override
  Future<ApiResult<List<DriverTripModel>>> getCachedScheduleRequests() async {
    return getLocalDataList<DriverTripModel>(
      key: _scheduleRequestsKey,
      fetcher: () async {
        final json = _prefs.getString(_scheduleRequestsKey);
        if (json == null) return null;
        try {
          final list = jsonDecode(json) as List<dynamic>;
          return list.map((e) => DriverTripModel.fromJson(e as Map<String, dynamic>)).toList();
        } catch (_) {
          return null;
        }
      },
    );
  }

  @override
  Future<ApiResult<void>> cacheScheduleRequests(List<DriverTripModel> requests) async {
    return saveLocalDataList<DriverTripModel>(
      key: _scheduleRequestsKey,
      data: requests,
      saver: (data) async {
        final json = jsonEncode(data.map((e) => e.toJson()).toList());
        await _prefs.setString(_scheduleRequestsKey, json);
      },
    );
  }

  @override
  Future<ApiResult<void>> clearTripsCache() async {
    await deleteLocalData(
      key: _scheduleTripsKey,
      deleter: () async => _prefs.remove(_scheduleTripsKey),
    );
    return deleteLocalData(
      key: _scheduleRequestsKey,
      deleter: () async => _prefs.remove(_scheduleRequestsKey),
    );
  }
}
