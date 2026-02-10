import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting vehicle types.
///
/// Based on FAST App API documentation for GET /select/vehicle-type
@immutable
class GetVehicleTypesParameters extends Parameters {
  final CancelToken? _cancelToken;

  const GetVehicleTypesParameters._({CancelToken? cancelToken})
    : _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static GetVehicleTypesParametersBuilder builder() =>
      GetVehicleTypesParametersBuilder();
}

/// Builder for GetVehicleTypesParameters
class GetVehicleTypesParametersBuilder
    extends ParametersBuilder<GetVehicleTypesParameters> {
  CancelToken? _cancelToken;

  /// Set the cancel token for request cancellation
  @override
  GetVehicleTypesParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetVehicleTypesParameters
  @override
  GetVehicleTypesParameters build() {
    return GetVehicleTypesParameters._(cancelToken: _cancelToken);
  }
}
