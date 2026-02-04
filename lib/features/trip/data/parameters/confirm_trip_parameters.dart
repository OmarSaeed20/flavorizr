// lib/features/trip/data/parameters/confirm_trip_parameters.dart
import 'package:dio/dio.dart';
import 'package:flavorizr/features/trip/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for confirming a trip.
@immutable
class ConfirmTripParameters extends Parameters {
  const ConfirmTripParameters._({
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

  static ConfirmTripParametersBuilder builder() => ConfirmTripParametersBuilder();
}

/// Builder for ConfirmTripParameters.
class ConfirmTripParametersBuilder extends ParametersBuilder<ConfirmTripParameters> {
  String? _orderId;
  String? _userId;
  CancelToken? _cancelToken;

  ConfirmTripParametersBuilder withOrderId(String orderId) {
    _orderId = orderId;
    return this;
  }

  ConfirmTripParametersBuilder withUserId(String userId) {
    _userId = userId;
    return this;
  }

  @override
  ConfirmTripParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ConfirmTripParameters build() {
    return ConfirmTripParameters._(
      orderId: _orderId!,
      userId: _userId!,
      cancelToken: _cancelToken,
    );
  }
}
