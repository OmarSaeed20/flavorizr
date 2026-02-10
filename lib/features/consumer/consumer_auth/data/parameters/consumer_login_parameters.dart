// lib/features/consumer/consumer_auth/data/parameters/consumer_login_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Consumer Login API parameters
///
/// Used for consumer authentication with phone and password.
/// Consumers are regular users booking rides.
/// Based on API_DOCUMENTATION.md
class ConsumerLoginParameters extends Parameters {
  final String phone;
  final String phoneIsoCode;
  final String password;
  final String firebaseToken;
  final String? deviceType;
  final String? deviceToken;
  final String? deviceId;
  @override
  final CancelToken? cancelToken;

  const ConsumerLoginParameters({
    required this.phone,
    required this.phoneIsoCode,
    required this.password,
    required this.firebaseToken,
    this.deviceType,
    this.deviceToken,
    this.deviceId,
    this.cancelToken,
  });

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {
    'phone': phone,
    'phone_iso_code': phoneIsoCode,
    'password': password,
    'firebase_token': firebaseToken,
    if (deviceType != null) 'device_type': deviceType,
    if (deviceToken != null) 'device_token': deviceToken,
    if (deviceId != null) 'device_id': deviceId,
  };

  /// Create a builder for this parameters type
  ConsumerLoginParametersBuilder builder() => ConsumerLoginParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConsumerLoginParameters &&
        other.phone == phone &&
        other.phoneIsoCode == phoneIsoCode &&
        other.password == password &&
        other.firebaseToken == firebaseToken &&
        other.deviceType == deviceType &&
        other.deviceToken == deviceToken &&
        other.deviceId == deviceId &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode =>
      phone.hashCode ^
      phoneIsoCode.hashCode ^
      password.hashCode ^
      firebaseToken.hashCode ^
      deviceType.hashCode ^
      deviceToken.hashCode ^
      deviceId.hashCode ^
      cancelToken.hashCode;

  @override
  String toString() =>
      'ConsumerLoginParameters(phone: $phone, phoneIsoCode: $phoneIsoCode, password: ****, firebaseToken: $firebaseToken, deviceType: $deviceType, deviceToken: $deviceToken, deviceId: $deviceId, cancelToken: $cancelToken)';
}

/// Builder for ConsumerLoginParameters
class ConsumerLoginParametersBuilder
    extends ParametersBuilder<ConsumerLoginParameters> {
  String? _phone;
  String? _phoneIsoCode;
  String? _password;
  String? _firebaseToken;
  String? _deviceType;
  String? _deviceToken;
  String? _deviceId;
  CancelToken? _cancelToken;

  /// Set the phone number
  ConsumerLoginParametersBuilder phone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the phone ISO code (e.g., 'EG', 'US')
  ConsumerLoginParametersBuilder phoneIsoCode(String phoneIsoCode) {
    _phoneIsoCode = phoneIsoCode;
    return this;
  }

  /// Set the password
  ConsumerLoginParametersBuilder password(String password) {
    _password = password;
    return this;
  }

  /// Set the Firebase token
  ConsumerLoginParametersBuilder firebaseToken(String firebaseToken) {
    _firebaseToken = firebaseToken;
    return this;
  }

  /// Set the device type (e.g., 'ios', 'android')
  ConsumerLoginParametersBuilder deviceType(String deviceType) {
    _deviceType = deviceType;
    return this;
  }

  /// Set the device token for push notifications
  ConsumerLoginParametersBuilder deviceToken(String deviceToken) {
    _deviceToken = deviceToken;
    return this;
  }

  /// Set the device ID
  ConsumerLoginParametersBuilder deviceId(String deviceId) {
    _deviceId = deviceId;
    return this;
  }

  /// Set the cancel token for request cancellation
  ConsumerLoginParametersBuilder cancelToken(CancelToken cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ParametersBuilder<ConsumerLoginParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ConsumerLoginParameters build() {
    return ConsumerLoginParameters(
      phone: _phone!,
      phoneIsoCode: _phoneIsoCode!,
      password: _password!,
      firebaseToken: _firebaseToken!,
      deviceType: _deviceType,
      deviceToken: _deviceToken,
      deviceId: _deviceId,
      cancelToken: _cancelToken,
    );
  }
}
