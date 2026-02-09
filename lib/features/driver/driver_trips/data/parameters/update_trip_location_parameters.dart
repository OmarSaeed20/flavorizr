import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for updating trip location
@immutable
class UpdateTripLocationParameters extends Parameters {
  final String _tripId;
  final double _latitude;
  final double _longitude;
  final CancelToken? _cancelToken;

  const UpdateTripLocationParameters._({
    required String tripId,
    required double latitude,
    required double longitude,
    CancelToken? cancelToken,
  }) : _tripId = tripId,
       _latitude = latitude,
       _longitude = longitude,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {'tripId': _tripId, 'latitude': _latitude, 'longitude': _longitude};
  }

  String get tripId => _tripId;
  double get latitude => _latitude;
  double get longitude => _longitude;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static UpdateTripLocationParametersBuilder builder() => UpdateTripLocationParametersBuilder();
}

/// Builder for UpdateTripLocationParameters
class UpdateTripLocationParametersBuilder extends ParametersBuilder<UpdateTripLocationParameters> {
  String? _tripId;
  double? _latitude;
  double? _longitude;
  CancelToken? _cancelToken;

  /// Set the trip ID
  UpdateTripLocationParametersBuilder withTripId(String tripId) {
    _tripId = tripId;
    return this;
  }

  /// Set the latitude
  UpdateTripLocationParametersBuilder withLatitude(double latitude) {
    _latitude = latitude;
    return this;
  }

  /// Set the longitude
  UpdateTripLocationParametersBuilder withLongitude(double longitude) {
    _longitude = longitude;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  UpdateTripLocationParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the UpdateTripLocationParameters
  @override
  UpdateTripLocationParameters build() {
    if (_tripId == null) {
      throw ArgumentError('Trip ID is required');
    }
    if (_latitude == null) {
      throw ArgumentError('Latitude is required');
    }
    if (_longitude == null) {
      throw ArgumentError('Longitude is required');
    }
    return UpdateTripLocationParameters._(
      tripId: _tripId!,
      latitude: _latitude!,
      longitude: _longitude!,
      cancelToken: _cancelToken,
    );
  }
}
