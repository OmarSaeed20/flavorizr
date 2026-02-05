import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting driver reviews.
@immutable
class GetDriverReviewsParameters extends Parameters {
  final String? _driverId;
  final String? _tripId;
  final int? _rating;
  final int _page;
  final int _limit;
  final String _sortBy;
  final String _sortOrder;
  final CancelToken? _cancelToken;

  const GetDriverReviewsParameters._({
    String? driverId,
    String? tripId,
    int? rating,
    int page = 1,
    int limit = 20,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
    CancelToken? cancelToken,
  }) : _driverId = driverId,
       _tripId = tripId,
       _rating = rating,
       _page = page,
       _limit = limit,
       _sortBy = sortBy,
       _sortOrder = sortOrder,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {
      if (_driverId != null) 'driver_id': _driverId,
      if (_tripId != null) 'trip_id': _tripId,
      if (_rating != null) 'rating': _rating,
      'page': _page,
      'limit': _limit,
      'sort_by': _sortBy,
      'sort_order': _sortOrder,
    };
  }

  String? get driverId => _driverId;
  String? get tripId => _tripId;
  int? get rating => _rating;
  int get page => _page;
  int get limit => _limit;
  String get sortBy => _sortBy;
  String get sortOrder => _sortOrder;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static GetDriverReviewsParametersBuilder builder() => GetDriverReviewsParametersBuilder();
}

/// Builder for GetDriverReviewsParameters
class GetDriverReviewsParametersBuilder extends ParametersBuilder<GetDriverReviewsParameters> {
  String? _driverId;
  String? _tripId;
  int? _rating;
  int _page = 1;
  int _limit = 20;
  String _sortBy = 'created_at';
  String _sortOrder = 'desc';
  CancelToken? _cancelToken;

  /// Set the driver ID
  GetDriverReviewsParametersBuilder withDriverId(String driverId) {
    _driverId = driverId;
    return this;
  }

  /// Set the trip ID
  GetDriverReviewsParametersBuilder withTripId(String tripId) {
    _tripId = tripId;
    return this;
  }

  /// Set the rating filter
  GetDriverReviewsParametersBuilder withRating(int rating) {
    _rating = rating;
    return this;
  }

  /// Set the page number
  GetDriverReviewsParametersBuilder withPage(int page) {
    _page = page;
    return this;
  }

  /// Set the limit
  GetDriverReviewsParametersBuilder withLimit(int limit) {
    _limit = limit;
    return this;
  }

  /// Set the sort by field
  GetDriverReviewsParametersBuilder withSortBy(String sortBy) {
    _sortBy = sortBy;
    return this;
  }

  /// Set the sort order
  GetDriverReviewsParametersBuilder withSortOrder(String sortOrder) {
    _sortOrder = sortOrder;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  GetDriverReviewsParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetDriverReviewsParameters
  @override
  GetDriverReviewsParameters build() {
    return GetDriverReviewsParameters._(
      driverId: _driverId,
      tripId: _tripId,
      rating: _rating,
      page: _page,
      limit: _limit,
      sortBy: _sortBy,
      sortOrder: _sortOrder,
      cancelToken: _cancelToken,
    );
  }
}
