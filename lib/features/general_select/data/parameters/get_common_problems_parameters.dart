import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting common problems.
///
/// Based on FAST App API documentation for GET /select/common-problem
@immutable
class GetCommonProblemsParameters extends Parameters {
  final CancelToken? _cancelToken;

  const GetCommonProblemsParameters._({CancelToken? cancelToken})
    : _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static GetCommonProblemsParametersBuilder builder() =>
      GetCommonProblemsParametersBuilder();
}

/// Builder for GetCommonProblemsParameters
class GetCommonProblemsParametersBuilder
    extends ParametersBuilder<GetCommonProblemsParameters> {
  CancelToken? _cancelToken;

  /// Set the cancel token for request cancellation
  @override
  GetCommonProblemsParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetCommonProblemsParameters
  @override
  GetCommonProblemsParameters build() {
    return GetCommonProblemsParameters._(cancelToken: _cancelToken);
  }
}
