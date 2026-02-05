import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';

/// Logout API parameters with builder pattern
/// Used for user logout
class LogoutParameters extends Parameters {
  final String deviceType;
  final String? deviceToken;
  final String? deviceId;
  @override
  final CancelToken? cancelToken;

  const LogoutParameters({
    required this.deviceType,
    this.deviceToken,
    this.deviceId,
    this.cancelToken,
  });

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {
    'device_type': deviceType,
    if (deviceToken != null) 'device_token': deviceToken,
    if (deviceId != null) 'device_id': deviceId,
  };

  /// Create a builder for this parameters type
  LogoutParametersBuilder builder() => LogoutParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LogoutParameters &&
        other.deviceType == deviceType &&
        other.deviceToken == deviceToken &&
        other.deviceId == deviceId &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode =>
      deviceType.hashCode ^
      deviceToken.hashCode ^
      deviceId.hashCode ^
      cancelToken.hashCode;

  @override
  String toString() =>
      'LogoutParameters(deviceType: $deviceType, deviceToken: $deviceToken, deviceId: $deviceId, cancelToken: $cancelToken)';
}

/// Builder for LogoutParameters
class LogoutParametersBuilder extends ParametersBuilder<LogoutParameters> {
  String? _deviceType;
  String? _deviceToken;
  String? _deviceId;
  CancelToken? _cancelToken;

  LogoutParametersBuilder();

  /// Set device type
  LogoutParametersBuilder withDeviceType(String deviceType) {
    _deviceType = deviceType;
    return this;
  }

  /// Set device token
  LogoutParametersBuilder withDeviceToken(String? deviceToken) {
    _deviceToken = deviceToken;
    return this;
  }

  /// Set device ID
  LogoutParametersBuilder withDeviceId(String? deviceId) {
    _deviceId = deviceId;
    return this;
  }

  /// Set cancel token
  @override
  LogoutParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build LogoutParameters
  @override
  LogoutParameters build() {
    if (_deviceType == null || _deviceType!.isEmpty) {
      throw ArgumentError('Device type is required');
    }
    return LogoutParameters(
      deviceType: _deviceType!,
      deviceToken: _deviceToken,
      deviceId: _deviceId,
      cancelToken: _cancelToken,
    );
  }
}
