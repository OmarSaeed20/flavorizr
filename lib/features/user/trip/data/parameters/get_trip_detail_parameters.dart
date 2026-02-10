// lib/features/trip/data/parameters/get_trip_detail_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting trip details.
@immutable
class GetTripDetailParameters extends Parameters {
  const GetTripDetailParameters._({required this.tripId, this.cancelToken});

  @override
  Map<String, dynamic> toJson() => {'trip_id': tripId};

  final int tripId;

  @override
  final CancelToken? cancelToken;

  static GetTripDetailParametersBuilder builder() =>
      GetTripDetailParametersBuilder();
}

/// Builder for GetTripDetailParameters.
class GetTripDetailParametersBuilder
    extends ParametersBuilder<GetTripDetailParameters> {
  int? _tripId;
  CancelToken? _cancelToken;

  GetTripDetailParametersBuilder withTripId(int tripId) {
    _tripId = tripId;
    return this;
  }

  @override
  GetTripDetailParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  GetTripDetailParameters build() {
    return GetTripDetailParameters._(
      tripId: _tripId!,
      cancelToken: _cancelToken,
    );
  }
}
