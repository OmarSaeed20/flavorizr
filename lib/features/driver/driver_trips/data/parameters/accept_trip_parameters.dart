import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for accepting a trip.
@immutable
class AcceptTripParameters extends Parameters {
  final String _tripId;
  final CancelToken? _cancelToken;

  const AcceptTripParameters._({required String tripId, CancelToken? cancelToken})
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
  static AcceptTripParametersBuilder builder() => AcceptTripParametersBuilder();
}

/// Builder for AcceptTripParameters
class AcceptTripParametersBuilder extends ParametersBuilder<AcceptTripParameters> {
  String? _tripId;
  CancelToken? _cancelToken;

  /// Set the trip ID
  AcceptTripParametersBuilder withTripId(String tripId) {
    _tripId = tripId;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  AcceptTripParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the AcceptTripParameters
  @override
  AcceptTripParameters build() {
    if (_tripId == null) {
      throw ArgumentError('Trip ID is required');
    }
    return AcceptTripParameters._(tripId: _tripId!, cancelToken: _cancelToken);
  }
}
