import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting driver's schedule trip requests.
@immutable
class GetScheduleRequestsParameters extends Parameters {
  final String? _date;
  final String? _status;
  final CancelToken? _cancelToken;

  const GetScheduleRequestsParameters._({String? date, String? status, CancelToken? cancelToken})
    : _date = date,
      _status = status,
      _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {if (_date != null) 'date': _date, if (_status != null) 'status': _status};
  }

  String? get date => _date;
  String? get status => _status;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static GetScheduleRequestsParametersBuilder builder() => GetScheduleRequestsParametersBuilder();
}

/// Builder for GetScheduleRequestsParameters
class GetScheduleRequestsParametersBuilder
    extends ParametersBuilder<GetScheduleRequestsParameters> {
  String? _date;
  String? _status;
  CancelToken? _cancelToken;

  /// Set the date
  GetScheduleRequestsParametersBuilder withDate(String date) {
    _date = date;
    return this;
  }

  /// Set the status
  GetScheduleRequestsParametersBuilder withStatus(String status) {
    _status = status;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  GetScheduleRequestsParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetScheduleRequestsParameters
  @override
  GetScheduleRequestsParameters build() {
    return GetScheduleRequestsParameters._(date: _date, status: _status, cancelToken: _cancelToken);
  }
}
