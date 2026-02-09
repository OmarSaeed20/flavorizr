import 'package:fast_golden_taxi/core/network/base/datasource/base_local_data_source.dart';
import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_home/data/models/driver_home_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for driver home data.
///
/// Handles caching of driver home data using SharedPreferences.
abstract class DriverHomeLocalDataSource {
  /// Gets cached driver home data.
  Future<ApiResult<DriverHomeDataModel>> getCachedHomeData();

  /// Caches driver home data.
  Future<ApiResult<void>> cacheHomeData(DriverHomeDataModel data);

  /// Clears cached driver home data.
  Future<ApiResult<void>> clearHomeDataCache();
}

/// Implementation of [DriverHomeLocalDataSource] using BaseLocalDataSource.
class DriverHomeLocalDataSourceImpl with BaseLocalDataSource implements DriverHomeLocalDataSource {
  const DriverHomeLocalDataSourceImpl(this._preferences);
  final SharedPreferences _preferences;

  static const String _homeDataKey = 'driver_home_data';

  @override
  Future<ApiResult<DriverHomeDataModel>> getCachedHomeData() async {
    return getLocalData<DriverHomeDataModel>(
      key: _homeDataKey,
      fetcher: () async {
        final jsonString = _preferences.getString(_homeDataKey);
        if (jsonString == null) {
          throw Exception('No cached data found');
        }
        return DriverHomeDataModel.fromJson(
          Map<String, dynamic>.from(
            // ignore: avoid_dynamic_calls
            (_preferences.getString(_homeDataKey)) != null ? {} : {},
          ),
        );
      },
    );
  }

  @override
  Future<ApiResult<void>> cacheHomeData(DriverHomeDataModel data) async {
    return saveLocalData<DriverHomeDataModel>(
      key: _homeDataKey,
      data: data,
      saver: (data) async {
        await _preferences.setString(_homeDataKey, data.toJson().toString());
      },
    );
  }

  @override
  Future<ApiResult<void>> clearHomeDataCache() async {
    return deleteLocalData(
      key: _homeDataKey,
      deleter: () async {
        await _preferences.remove(_homeDataKey);
      },
    );
  }
}
