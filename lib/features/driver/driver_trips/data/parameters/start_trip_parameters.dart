import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for starting a trip.
@immutable
class StartTripParameters extends Parameters {
  final String _tripId;
  final CancelToken? _cancelToken;

  const StartTripParameters._({
    required String tripId,
    CancelToken? cancelToken,
  }) : _tripId = tripId,
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
  static StartTripParametersBuilder builder() => StartTripParametersBuilder();
}

/// Builder for StartTripParameters
class StartTripParametersBuilder
    extends ParametersBuilder<StartTripParameters> {
  String? _tripId;
  CancelToken? _cancelToken;

  /// Set the trip ID
  StartTripParametersBuilder withTripId(String tripId) {
    _tripId = tripId;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  StartTripParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the StartTripParameters
  @override
  StartTripParameters build() {
    if (_tripId == null) {
      throw ArgumentError('Trip ID is required');
    }
    return StartTripParameters._(tripId: _tripId!, cancelToken: _cancelToken);
  }
}
