import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Login API parameters with builder pattern
/// Used for user authentication
/// Based on API_DOCUMENTATION.md
class LoginParameters extends Parameters {
  final String phone;
  final String phoneIsoCode;
  final String password;
  final String firebaseToken;
  final String? deviceType;
  final String? deviceToken;
  final String? deviceId;
  @override
  final CancelToken? cancelToken;

  const LoginParameters({
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
  LoginParametersBuilder builder() => LoginParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginParameters &&
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
      'LoginParameters(phone: $phone, phoneIsoCode: $phoneIsoCode, password: ****, firebaseToken: $firebaseToken, deviceType: $deviceType, deviceToken: $deviceToken, deviceId: $deviceId, cancelToken: $cancelToken)';
}

/// Builder for LoginParameters
class LoginParametersBuilder extends ParametersBuilder<LoginParameters> {
  String? _phone;
  String? _phoneIsoCode;
  String? _password;
  String? _firebaseToken;
  String? _deviceType;
  String? _deviceToken;
  String? _deviceId;
  CancelToken? _cancelToken;

  LoginParametersBuilder();

  /// Set phone number
  LoginParametersBuilder withPhone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set phone ISO code (e.g., 'EG', 'US')
  LoginParametersBuilder withPhoneIsoCode(String phoneIsoCode) {
    _phoneIsoCode = phoneIsoCode;
    return this;
  }

  /// Set password
  LoginParametersBuilder withPassword(String password) {
    _password = password;
    return this;
  }

  /// Set Firebase token for push notifications
  LoginParametersBuilder withFirebaseToken(String firebaseToken) {
    _firebaseToken = firebaseToken;
    return this;
  }

  /// Set device type (e.g., 'ios', 'android')
  LoginParametersBuilder withDeviceType(String? deviceType) {
    _deviceType = deviceType;
    return this;
  }

  /// Set device token for push notifications
  LoginParametersBuilder withDeviceToken(String? deviceToken) {
    _deviceToken = deviceToken;
    return this;
  }

  /// Set device ID
  LoginParametersBuilder withDeviceId(String? deviceId) {
    _deviceId = deviceId;
    return this;
  }

  /// Set cancel token for request cancellation
  @override
  LoginParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build LoginParameters
  @override
  LoginParameters build() {
    if (_phone == null || _phone!.isEmpty) {
      throw ArgumentError('Phone is required');
    }
    if (_phoneIsoCode == null || _phoneIsoCode!.isEmpty) {
      throw ArgumentError('Phone ISO code is required');
    }
    if (_password == null || _password!.isEmpty) {
      throw ArgumentError('Password is required');
    }
    if (_firebaseToken == null || _firebaseToken!.isEmpty) {
      throw ArgumentError('Firebase token is required');
    }
    return LoginParameters(
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
