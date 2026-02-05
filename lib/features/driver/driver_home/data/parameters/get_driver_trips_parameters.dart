import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting driver trips.
@immutable
class GetDriverTripsParameters extends Parameters {
  final int _page;
  final int _limit;
  final String? _status;
  final CancelToken? _cancelToken;

  const GetDriverTripsParameters._({
    int page = 1,
    int limit = 10,
    String? status,
    CancelToken? cancelToken,
  }) : _page = page,
       _limit = limit,
       _status = status,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'page': _page, 'limit': _limit};
    if (_status != null) {
      json['status'] = _status;
    }
    return json;
  }

  int get page => _page;
  int get limit => _limit;
  String? get status => _status;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static GetDriverTripsParametersBuilder builder() =>
      GetDriverTripsParametersBuilder();
}

/// Builder for GetDriverTripsParameters
class GetDriverTripsParametersBuilder
    extends ParametersBuilder<GetDriverTripsParameters> {
  int _page = 1;
  int _limit = 10;
  String? _status;
  CancelToken? _cancelToken;

  /// Set the page number
  GetDriverTripsParametersBuilder withPage(int page) {
    _page = page;
    return this;
  }

  /// Set the limit per page
  GetDriverTripsParametersBuilder withLimit(int limit) {
    _limit = limit;
    return this;
  }

  /// Set the status filter
  GetDriverTripsParametersBuilder withStatus(String status) {
    _status = status;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  GetDriverTripsParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetDriverTripsParameters
  @override
  GetDriverTripsParameters build() {
    return GetDriverTripsParameters._(
      page: _page,
      limit: _limit,
      status: _status,
      cancelToken: _cancelToken,
    );
  }
}
