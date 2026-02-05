import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for completing a trip.
@immutable
class CompleteTripParameters extends Parameters {
  final String _tripId;
  final CancelToken? _cancelToken;

  const CompleteTripParameters._({required String tripId, CancelToken? cancelToken})
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
  static CompleteTripParametersBuilder builder() => CompleteTripParametersBuilder();
}

/// Builder for CompleteTripParameters
class CompleteTripParametersBuilder extends ParametersBuilder<CompleteTripParameters> {
  String? _tripId;
  CancelToken? _cancelToken;

  /// Set the trip ID
  CompleteTripParametersBuilder withTripId(String tripId) {
    _tripId = tripId;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  CompleteTripParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the CompleteTripParameters
  @override
  CompleteTripParameters build() {
    if (_tripId == null) {
      throw ArgumentError('Trip ID is required');
    }
    return CompleteTripParameters._(tripId: _tripId!, cancelToken: _cancelToken);
  }
}
