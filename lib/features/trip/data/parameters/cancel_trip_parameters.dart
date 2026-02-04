// lib/features/trip/data/parameters/cancel_trip_parameters.dart
import 'package:dio/dio.dart';
import 'package:flavorizr/features/trip/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for cancelling a trip.
@immutable
class CancelTripParameters extends Parameters {
  const CancelTripParameters._({
    required this.orderId,
    required this.userId,
    this.cancelToken,
  });

  @override
  Map<String, dynamic> toJson() => {
    'order_id': orderId,
    'user_id': userId,
  };

  final String orderId;
  final String userId;

  @override
  final CancelToken? cancelToken;

  static CancelTripParametersBuilder builder() => CancelTripParametersBuilder();
}

/// Builder for CancelTripParameters.
class CancelTripParametersBuilder extends ParametersBuilder<CancelTripParameters> {
  String? _orderId;
  String? _userId;
  CancelToken? _cancelToken;

  CancelTripParametersBuilder withOrderId(String orderId) {
    _orderId = orderId;
    return this;
  }

  CancelTripParametersBuilder withUserId(String userId) {
    _userId = userId;
    return this;
  }

  @override
  CancelTripParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  CancelTripParameters build() {
    return CancelTripParameters._(
      orderId: _orderId!,
      userId: _userId!,
      cancelToken: _cancelToken,
    );
  }
}
