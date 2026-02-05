import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting app policies.
///
/// Based on FAST App API documentation for GET /setting/policies
@immutable
class GetPoliciesParameters extends Parameters {
  final String? _type;
  final CancelToken? _cancelToken;

  const GetPoliciesParameters._({String? type, CancelToken? cancelToken})
    : _type = type,
      _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (_type != null) {
      json['type'] = _type;
    }
    return json;
  }

  String? get type => _type;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static GetPoliciesParametersBuilder builder() =>
      GetPoliciesParametersBuilder();
}

/// Builder for GetPoliciesParameters
class GetPoliciesParametersBuilder
    extends ParametersBuilder<GetPoliciesParameters> {
  String? _type;
  CancelToken? _cancelToken;

  /// Set the policy type filter (optional)
  GetPoliciesParametersBuilder withType(String type) {
    _type = type;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  GetPoliciesParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetPoliciesParameters
  @override
  GetPoliciesParameters build() {
    return GetPoliciesParameters._(type: _type, cancelToken: _cancelToken);
  }
}
