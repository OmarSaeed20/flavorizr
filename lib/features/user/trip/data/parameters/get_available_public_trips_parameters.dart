// lib/features/trip/data/parameters/get_available_public_trips_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting available public trips.
@immutable
class GetAvailablePublicTripsParameters extends Parameters {
  const GetAvailablePublicTripsParameters._({
    required this.orderId,
    required this.userId,
    this.cancelToken,
  });

  @override
  Map<String, dynamic> toJson() => {'order_id': orderId, 'user_id': userId};

  final String orderId;
  final String userId;

  @override
  final CancelToken? cancelToken;

  static GetAvailablePublicTripsParametersBuilder builder() =>
      GetAvailablePublicTripsParametersBuilder();
}

/// Builder for GetAvailablePublicTripsParameters.
class GetAvailablePublicTripsParametersBuilder
    extends ParametersBuilder<GetAvailablePublicTripsParameters> {
  String? _orderId;
  String? _userId;
  CancelToken? _cancelToken;

  GetAvailablePublicTripsParametersBuilder withOrderId(String orderId) {
    _orderId = orderId;
    return this;
  }

  GetAvailablePublicTripsParametersBuilder withUserId(String userId) {
    _userId = userId;
    return this;
  }

  @override
  GetAvailablePublicTripsParametersBuilder withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  GetAvailablePublicTripsParameters build() {
    return GetAvailablePublicTripsParameters._(
      orderId: _orderId!,
      userId: _userId!,
      cancelToken: _cancelToken,
    );
  }
}
