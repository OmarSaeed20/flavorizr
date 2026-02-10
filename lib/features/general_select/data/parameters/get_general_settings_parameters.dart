import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting general app settings.
///
/// Based on FAST App API documentation for GET /setting/general
@immutable
class GetGeneralSettingsParameters extends Parameters {
  final CancelToken? _cancelToken;

  const GetGeneralSettingsParameters._({CancelToken? cancelToken})
    : _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static GetGeneralSettingsParametersBuilder builder() =>
      GetGeneralSettingsParametersBuilder();
}

/// Builder for GetGeneralSettingsParameters
class GetGeneralSettingsParametersBuilder
    extends ParametersBuilder<GetGeneralSettingsParameters> {
  CancelToken? _cancelToken;

  /// Set the cancel token for request cancellation
  @override
  GetGeneralSettingsParametersBuilder withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetGeneralSettingsParameters
  @override
  GetGeneralSettingsParameters build() {
    return GetGeneralSettingsParameters._(cancelToken: _cancelToken);
  }
}
