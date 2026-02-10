// lib/features/consumer/consumer_auth/data/parameters/consumer_logout_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Consumer Logout API parameters
///
/// Used for logging out consumer and invalidating tokens.
/// Based on API_DOCUMENTATION.md
class ConsumerLogoutParameters extends Parameters {
  final String? deviceToken;
  @override
  final CancelToken? cancelToken;

  const ConsumerLogoutParameters({this.deviceToken, this.cancelToken});

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {if (deviceToken != null) 'device_token': deviceToken};

  /// Create a builder for this parameters type
  ConsumerLogoutParametersBuilder builder() => ConsumerLogoutParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConsumerLogoutParameters &&
        other.deviceToken == deviceToken &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode => deviceToken.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'ConsumerLogoutParameters(deviceToken: $deviceToken, cancelToken: $cancelToken)';
}

/// Builder for ConsumerLogoutParameters
class ConsumerLogoutParametersBuilder extends ParametersBuilder<ConsumerLogoutParameters> {
  String? _deviceToken;
  CancelToken? _cancelToken;

  /// Set the device token to remove
  ConsumerLogoutParametersBuilder deviceToken(String deviceToken) {
    _deviceToken = deviceToken;
    return this;
  }

  /// Set the cancel token for request cancellation
  ConsumerLogoutParametersBuilder cancelToken(CancelToken cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ParametersBuilder<ConsumerLogoutParameters> withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ConsumerLogoutParameters build() {
    return ConsumerLogoutParameters(deviceToken: _deviceToken, cancelToken: _cancelToken);
  }
}
