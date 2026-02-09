// lib/features/trip/data/parameters/get_captain_trip_detail_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting captain's trip details.
@immutable
class GetCaptainTripDetailParameters extends Parameters {
  const GetCaptainTripDetailParameters._({required this.tripId, this.cancelToken});

  @override
  Map<String, dynamic> toJson() => {'trip_id': tripId};

  final int tripId;

  @override
  final CancelToken? cancelToken;

  static GetCaptainTripDetailParametersBuilder builder() => GetCaptainTripDetailParametersBuilder();
}

/// Builder for GetCaptainTripDetailParameters.
class GetCaptainTripDetailParametersBuilder
    extends ParametersBuilder<GetCaptainTripDetailParameters> {
  int? _tripId;
  CancelToken? _cancelToken;

  GetCaptainTripDetailParametersBuilder withTripId(int tripId) {
    _tripId = tripId;
    return this;
  }

  @override
  GetCaptainTripDetailParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  GetCaptainTripDetailParameters build() {
    return GetCaptainTripDetailParameters._(tripId: _tripId!, cancelToken: _cancelToken);
  }
}
