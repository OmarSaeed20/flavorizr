import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting driver reviews
@immutable
class GetDriverReviewsParams extends Parameters {
  final String _driverId;
  final int _page;
  final int _limit;
  final int? _minRating;
  final int? _maxRating;
  final bool? _withResponse;
  final bool? _pendingResponse;
  final CancelToken? _cancelToken;

  const GetDriverReviewsParams._({
    required String driverId,
    required int page,
    required int limit,
    int? minRating,
    int? maxRating,
    bool? withResponse,
    bool? pendingResponse,
    CancelToken? cancelToken,
  }) : _driverId = driverId,
       _page = page,
       _limit = limit,
       _minRating = minRating,
       _maxRating = maxRating,
       _withResponse = withResponse,
       _pendingResponse = pendingResponse,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {
      'driverId': _driverId,
      'page': _page,
      'limit': _limit,
      if (_minRating != null) 'minRating': _minRating,
      if (_maxRating != null) 'maxRating': _maxRating,
      if (_withResponse != null) 'withResponse': _withResponse,
      if (_pendingResponse != null) 'pendingResponse': _pendingResponse,
    };
  }

  @override
  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{
      'driverId': _driverId,
      'page': _page,
      'limit': _limit,
    };

    if (_minRating != null) {
      params['minRating'] = _minRating;
    }

    if (_maxRating != null) {
      params['maxRating'] = _maxRating;
    }

    if (_withResponse != null) {
      params['withResponse'] = _withResponse;
    }

    if (_pendingResponse != null) {
      params['pendingResponse'] = _pendingResponse;
    }

    return params;
  }

  String get driverId => _driverId;
  int get page => _page;
  int get limit => _limit;
  int? get minRating => _minRating;
  int? get maxRating => _maxRating;
  bool? get withResponse => _withResponse;
  bool? get pendingResponse => _pendingResponse;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static GetDriverReviewsParamsBuilder builder() =>
      GetDriverReviewsParamsBuilder();
}

/// Builder for GetDriverReviewsParams
class GetDriverReviewsParamsBuilder
    extends ParametersBuilder<GetDriverReviewsParams> {
  String? _driverId;
  int? _page;
  int? _limit;
  int? _minRating;
  int? _maxRating;
  bool? _withResponse;
  bool? _pendingResponse;
  CancelToken? _cancelToken;

  /// Set the driver ID
  GetDriverReviewsParamsBuilder withDriverId(String driverId) {
    _driverId = driverId;
    return this;
  }

  /// Set the page number
  GetDriverReviewsParamsBuilder withPage(int page) {
    _page = page;
    return this;
  }

  /// Set the limit
  GetDriverReviewsParamsBuilder withLimit(int limit) {
    _limit = limit;
    return this;
  }

  /// Set the minimum rating filter
  GetDriverReviewsParamsBuilder withMinRating(int minRating) {
    _minRating = minRating;
    return this;
  }

  /// Set the maximum rating filter
  GetDriverReviewsParamsBuilder withMaxRating(int maxRating) {
    _maxRating = maxRating;
    return this;
  }

  /// Set whether to include responses
  GetDriverReviewsParamsBuilder withWithResponse(bool withResponse) {
    _withResponse = withResponse;
    return this;
  }

  /// Set whether to filter for pending responses
  GetDriverReviewsParamsBuilder withPendingResponse(bool pendingResponse) {
    _pendingResponse = pendingResponse;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  GetDriverReviewsParamsBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetDriverReviewsParams
  @override
  GetDriverReviewsParams build() {
    if (_driverId == null) {
      throw ArgumentError('Driver ID is required');
    }
    if (_page == null) {
      throw ArgumentError('Page is required');
    }
    if (_limit == null) {
      throw ArgumentError('Limit is required');
    }
    return GetDriverReviewsParams._(
      driverId: _driverId!,
      page: _page!,
      limit: _limit!,
      minRating: _minRating,
      maxRating: _maxRating,
      withResponse: _withResponse,
      pendingResponse: _pendingResponse,
      cancelToken: _cancelToken,
    );
  }
}
