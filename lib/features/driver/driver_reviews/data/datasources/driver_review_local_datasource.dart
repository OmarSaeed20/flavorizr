import 'package:fast_golden_taxi/core/network/base/datasource/base_local_data_source.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_reviews/data/models/driver_review_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for driver reviews operations.
///
/// Handles all local storage operations related to driver reviews.
/// Uses SharedPreferences for caching review data.
abstract class DriverReviewLocalDataSource {
  /// Gets cached reviews.
  Future<ApiResult<List<DriverReviewModel>>> getCachedReviews();

  /// Saves reviews to cache.
  Future<ApiResult<void>> cacheReviews(List<DriverReviewModel> reviews);

  /// Clears all cached review data.
  Future<ApiResult<void>> clearReviewsCache();
}

/// Implementation of [DriverReviewLocalDataSource] using BaseLocalDataSource.
class DriverReviewLocalDataSourceImpl
    with BaseLocalDataSource
    implements DriverReviewLocalDataSource {
  const DriverReviewLocalDataSourceImpl(this._preferences);
  final SharedPreferences _preferences;

  static const String _reviewsKey = 'driver_reviews';

  @override
  Future<ApiResult<List<DriverReviewModel>>> getCachedReviews() async {
    return getLocalData<List<DriverReviewModel>>(
      key: _reviewsKey,
      fetcher: () async {
        final jsonString = _preferences.getString(_reviewsKey);
        if (jsonString == null) {
          throw Exception('No cached reviews found');
        }
        final data = Map<String, dynamic>.from(
          // ignore: avoid_dynamic_calls
          (_preferences.getString(_reviewsKey)) != null ? {} : {},
        );
        final list = data['reviews'] as List? ?? data['data'] as List? ?? [];
        return list
            .map((e) => DriverReviewModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<ApiResult<void>> cacheReviews(List<DriverReviewModel> reviews) async {
    return saveLocalData<List<DriverReviewModel>>(
      key: _reviewsKey,
      data: reviews,
      saver: (data) async {
        await _preferences.setString(
          _reviewsKey,
          {'reviews': data.map((e) => e.toJson()).toList()}.toString(),
        );
      },
    );
  }

  @override
  Future<ApiResult<void>> clearReviewsCache() async {
    return deleteLocalData(
      key: _reviewsKey,
      deleter: () async {
        await _preferences.remove(_reviewsKey);
      },
    );
  }
}
