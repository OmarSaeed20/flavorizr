import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting driver trips
@immutable
class GetDriverTripsParameters extends Parameters {
  final int _page;
  final int _limit;
  final String? _status;
  final String? _startDate;
  final String? _endDate;
  final CancelToken? _cancelToken;

  const GetDriverTripsParameters._({
    int page = 1,
    int limit = 10,
    String? status,
    String? startDate,
    String? endDate,
    CancelToken? cancelToken,
  }) : _page = page,
       _limit = limit,
       _status = status,
       _startDate = startDate,
       _endDate = endDate,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {
      'page': _page,
      'limit': _limit,
      if (_status != null) 'status': _status,
      if (_startDate != null) 'startDate': _startDate,
      if (_endDate != null) 'endDate': _endDate,
    };
  }

  int get page => _page;
  int get limit => _limit;
  String? get status => _status;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
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
  String? _startDate;
  String? _endDate;
  CancelToken? _cancelToken;

  /// Set the page number
  GetDriverTripsParametersBuilder withPage(int page) {
    _page = page;
    return this;
  }

  /// Set the limit
  GetDriverTripsParametersBuilder withLimit(int limit) {
    _limit = limit;
    return this;
  }

  /// Set the status
  GetDriverTripsParametersBuilder withStatus(String status) {
    _status = status;
    return this;
  }

  /// Set the start date
  GetDriverTripsParametersBuilder withStartDate(String startDate) {
    _startDate = startDate;
    return this;
  }

  /// Set the end date
  GetDriverTripsParametersBuilder withEndDate(String endDate) {
    _endDate = endDate;
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
      startDate: _startDate,
      endDate: _endDate,
      cancelToken: _cancelToken,
    );
  }
}
