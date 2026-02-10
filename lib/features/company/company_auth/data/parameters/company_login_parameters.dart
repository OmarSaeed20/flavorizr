// lib/features/company/company_auth/data/parameters/company_login_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Company Login API parameters
///
/// Used for company authentication with phone and password.
/// Companies are fleet management accounts.
/// Based on API_DOCUMENTATION.md
class CompanyLoginParameters extends Parameters {
  final String phone;
  final String phoneIsoCode;
  final String password;
  final String firebaseToken;
  final String? deviceType;
  final String? deviceToken;
  final String? deviceId;
  @override
  final CancelToken? cancelToken;

  const CompanyLoginParameters({
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
  CompanyLoginParametersBuilder builder() => CompanyLoginParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CompanyLoginParameters &&
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
      'CompanyLoginParameters(phone: $phone, phoneIsoCode: $phoneIsoCode, password: ****, firebaseToken: $firebaseToken, deviceType: $deviceType, deviceToken: $deviceToken, deviceId: $deviceId, cancelToken: $cancelToken)';
}

/// Builder for CompanyLoginParameters
class CompanyLoginParametersBuilder
    extends ParametersBuilder<CompanyLoginParameters> {
  String? _phone;
  String? _phoneIsoCode;
  String? _password;
  String? _firebaseToken;
  String? _deviceType;
  String? _deviceToken;
  String? _deviceId;
  CancelToken? _cancelToken;

  /// Set the phone number
  CompanyLoginParametersBuilder phone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the phone ISO code (e.g., 'EG', 'US')
  CompanyLoginParametersBuilder phoneIsoCode(String phoneIsoCode) {
    _phoneIsoCode = phoneIsoCode;
    return this;
  }

  /// Set the password
  CompanyLoginParametersBuilder password(String password) {
    _password = password;
    return this;
  }

  /// Set the Firebase token
  CompanyLoginParametersBuilder firebaseToken(String firebaseToken) {
    _firebaseToken = firebaseToken;
    return this;
  }

  /// Set the device type (e.g., 'ios', 'android')
  CompanyLoginParametersBuilder deviceType(String deviceType) {
    _deviceType = deviceType;
    return this;
  }

  /// Set the device token for push notifications
  CompanyLoginParametersBuilder deviceToken(String deviceToken) {
    _deviceToken = deviceToken;
    return this;
  }

  /// Set the device ID
  CompanyLoginParametersBuilder deviceId(String deviceId) {
    _deviceId = deviceId;
    return this;
  }

  /// Set the cancel token for request cancellation
  CompanyLoginParametersBuilder cancelToken(CancelToken cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ParametersBuilder<CompanyLoginParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  CompanyLoginParameters build() {
    return CompanyLoginParameters(
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
