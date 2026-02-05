import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for marking driver as arrived at pickup location.
@immutable
class ArrivedParameters extends Parameters {
  final String _tripId;
  final CancelToken? _cancelToken;

  const ArrivedParameters._({required String tripId, CancelToken? cancelToken})
    : _tripId = tripId,
      _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {'trip_id': _tripId};
  }

  String get tripId => _tripId;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static ArrivedParametersBuilder builder() => ArrivedParametersBuilder();
}

/// Builder for ArrivedParameters
class ArrivedParametersBuilder extends ParametersBuilder<ArrivedParameters> {
  String? _tripId;
  CancelToken? _cancelToken;

  /// Set the trip ID
  ArrivedParametersBuilder withTripId(String tripId) {
    _tripId = tripId;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  ArrivedParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the ArrivedParameters
  @override
  ArrivedParameters build() {
    if (_tripId == null) {
      throw ArgumentError('Trip ID is required');
    }
    return ArrivedParameters._(tripId: _tripId!, cancelToken: _cancelToken);
  }
}
