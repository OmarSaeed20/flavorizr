import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting about us information.
///
/// Based on FAST App API documentation for GET /setting/about_us
@immutable
class GetAboutUsParameters extends Parameters {
  final CancelToken? _cancelToken;

  const GetAboutUsParameters._({CancelToken? cancelToken})
    : _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static GetAboutUsParametersBuilder builder() => GetAboutUsParametersBuilder();
}

/// Builder for GetAboutUsParameters
class GetAboutUsParametersBuilder
    extends ParametersBuilder<GetAboutUsParameters> {
  CancelToken? _cancelToken;

  /// Set the cancel token for request cancellation
  @override
  GetAboutUsParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetAboutUsParameters
  @override
  GetAboutUsParameters build() {
    return GetAboutUsParameters._(cancelToken: _cancelToken);
  }
}
