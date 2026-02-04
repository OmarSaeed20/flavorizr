// lib/features/trip/data/parameters/get_trip_types_parameters.dart
import 'package:dio/dio.dart';
import 'package:flavorizr/features/trip/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting trip types by location.
@immutable
class GetTripTypesParameters extends Parameters {
  const GetTripTypesParameters._({
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
    this.cancelToken,
  });

  @override
  Map<String, dynamic> toJson() => {
    'pickup_latitude': pickupLatitude,
    'pickup_longitude': pickupLongitude,
    'destination_latitude': destinationLatitude,
    'destination_longitude': destinationLongitude,
  };

  final double pickupLatitude;
  final double pickupLongitude;
  final double destinationLatitude;
  final double destinationLongitude;

  @override
  final CancelToken? cancelToken;

  static GetTripTypesParametersBuilder builder() => GetTripTypesParametersBuilder();
}

/// Builder for GetTripTypesParameters.
class GetTripTypesParametersBuilder extends ParametersBuilder<GetTripTypesParameters> {
  double? _pickupLatitude;
  double? _pickupLongitude;
  double? _destinationLatitude;
  double? _destinationLongitude;
  CancelToken? _cancelToken;

  GetTripTypesParametersBuilder withPickupLatitude(double pickupLatitude) {
    _pickupLatitude = pickupLatitude;
    return this;
  }

  GetTripTypesParametersBuilder withPickupLongitude(double pickupLongitude) {
    _pickupLongitude = pickupLongitude;
    return this;
  }

  GetTripTypesParametersBuilder withDestinationLatitude(double destinationLatitude) {
    _destinationLatitude = destinationLatitude;
    return this;
  }

  GetTripTypesParametersBuilder withDestinationLongitude(double destinationLongitude) {
    _destinationLongitude = destinationLongitude;
    return this;
  }

  @override
  GetTripTypesParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  GetTripTypesParameters build() {
    return GetTripTypesParameters._(
      pickupLatitude: _pickupLatitude!,
      pickupLongitude: _pickupLongitude!,
      destinationLatitude: _destinationLatitude!,
      destinationLongitude: _destinationLongitude!,
      cancelToken: _cancelToken,
    );
  }
}
