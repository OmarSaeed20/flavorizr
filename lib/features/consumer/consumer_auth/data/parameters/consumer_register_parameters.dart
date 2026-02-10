// lib/features/consumer/consumer_auth/data/parameters/consumer_register_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Consumer Register API parameters
///
/// Used for new consumer registration.
/// Consumers are regular users booking rides with company_type: "customer".
/// Based on API_DOCUMENTATION.md
class ConsumerRegisterParameters extends Parameters {
  final String companyType;
  final String name;
  final String? nickname;
  final String phone;
  final String phoneIso2Code;
  final String password;
  final String passwordConfirmation;
  final int countryId;
  final int governorateId;
  final String birthdate;
  final String gender;
  final String? deviceType;
  final String? deviceToken;
  final String? deviceId;
  @override
  final CancelToken? cancelToken;

  const ConsumerRegisterParameters({
    required this.companyType,
    required this.name,
    this.nickname,
    required this.phone,
    required this.phoneIso2Code,
    required this.password,
    required this.passwordConfirmation,
    required this.countryId,
    required this.governorateId,
    required this.birthdate,
    required this.gender,
    this.deviceType,
    this.deviceToken,
    this.deviceId,
    this.cancelToken,
  });

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {
    'company_type': companyType,
    'name': name,
    if (nickname != null) 'nickname': nickname,
    'phone': phone,
    'phone_iso2_code': phoneIso2Code,
    'password': password,
    'password_confirmation': passwordConfirmation,
    'country_id': countryId,
    'governorate_id': governorateId,
    'birthdate': birthdate,
    'gender': gender,
    if (deviceType != null) 'device_type': deviceType,
    if (deviceToken != null) 'device_token': deviceToken,
    if (deviceId != null) 'device_id': deviceId,
  };

  /// Create a builder for this parameters type
  ConsumerRegisterParametersBuilder builder() => ConsumerRegisterParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConsumerRegisterParameters &&
        other.companyType == companyType &&
        other.name == name &&
        other.nickname == nickname &&
        other.phone == phone &&
        other.phoneIso2Code == phoneIso2Code &&
        other.password == password &&
        other.passwordConfirmation == passwordConfirmation &&
        other.countryId == countryId &&
        other.governorateId == governorateId &&
        other.birthdate == birthdate &&
        other.gender == gender &&
        other.deviceType == deviceType &&
        other.deviceToken == deviceToken &&
        other.deviceId == deviceId &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode =>
      companyType.hashCode ^
      name.hashCode ^
      nickname.hashCode ^
      phone.hashCode ^
      phoneIso2Code.hashCode ^
      password.hashCode ^
      passwordConfirmation.hashCode ^
      countryId.hashCode ^
      governorateId.hashCode ^
      birthdate.hashCode ^
      gender.hashCode ^
      deviceType.hashCode ^
      deviceToken.hashCode ^
      deviceId.hashCode ^
      cancelToken.hashCode;

  @override
  String toString() =>
      'ConsumerRegisterParameters(companyType: $companyType, name: $name, nickname: $nickname, phone: $phone, phoneIso2Code: $phoneIso2Code, password: ****, countryId: $countryId, governorateId: $governorateId, birthdate: $birthdate, gender: $gender, deviceType: $deviceType, deviceToken: $deviceToken, deviceId: $deviceId, cancelToken: $cancelToken)';
}

/// Builder for ConsumerRegisterParameters
class ConsumerRegisterParametersBuilder extends ParametersBuilder<ConsumerRegisterParameters> {
  String? _companyType;
  String? _name;
  String? _nickname;
  String? _phone;
  String? _phoneIso2Code;
  String? _password;
  String? _passwordConfirmation;
  int? _countryId;
  int? _governorateId;
  String? _birthdate;
  String? _gender;
  String? _deviceType;
  String? _deviceToken;
  String? _deviceId;
  CancelToken? _cancelToken;

  /// Set the company type (should be "customer" for consumers)
  ConsumerRegisterParametersBuilder companyType(String companyType) {
    _companyType = companyType;
    return this;
  }

  /// Set the user's full name
  ConsumerRegisterParametersBuilder name(String name) {
    _name = name;
    return this;
  }

  /// Set the user's nickname (optional)
  ConsumerRegisterParametersBuilder nickname(String nickname) {
    _nickname = nickname;
    return this;
  }

  /// Set the phone number
  ConsumerRegisterParametersBuilder phone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the phone ISO2 code (e.g., 'EG', 'US')
  ConsumerRegisterParametersBuilder phoneIso2Code(String phoneIso2Code) {
    _phoneIso2Code = phoneIso2Code;
    return this;
  }

  /// Set the password
  ConsumerRegisterParametersBuilder password(String password) {
    _password = password;
    return this;
  }

  /// Set the password confirmation
  ConsumerRegisterParametersBuilder passwordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    return this;
  }

  /// Set the country ID
  ConsumerRegisterParametersBuilder countryId(int countryId) {
    _countryId = countryId;
    return this;
  }

  /// Set the governorate ID
  ConsumerRegisterParametersBuilder governorateId(int governorateId) {
    _governorateId = governorateId;
    return this;
  }

  /// Set the birthdate (YYYY-MM-DD format)
  ConsumerRegisterParametersBuilder birthdate(String birthdate) {
    _birthdate = birthdate;
    return this;
  }

  /// Set the gender ('male' or 'female')
  ConsumerRegisterParametersBuilder gender(String gender) {
    _gender = gender;
    return this;
  }

  /// Set the device type (e.g., 'ios', 'android')
  ConsumerRegisterParametersBuilder deviceType(String deviceType) {
    _deviceType = deviceType;
    return this;
  }

  /// Set the device token for push notifications
  ConsumerRegisterParametersBuilder deviceToken(String deviceToken) {
    _deviceToken = deviceToken;
    return this;
  }

  /// Set the device ID
  ConsumerRegisterParametersBuilder deviceId(String deviceId) {
    _deviceId = deviceId;
    return this;
  }

  /// Set the cancel token for request cancellation
  ConsumerRegisterParametersBuilder cancelToken(CancelToken cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ParametersBuilder<ConsumerRegisterParameters> withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ConsumerRegisterParameters build() {
    return ConsumerRegisterParameters(
      companyType: _companyType!,
      name: _name!,
      nickname: _nickname,
      phone: _phone!,
      phoneIso2Code: _phoneIso2Code!,
      password: _password!,
      passwordConfirmation: _passwordConfirmation!,
      countryId: _countryId!,
      governorateId: _governorateId!,
      birthdate: _birthdate!,
      gender: _gender!,
      deviceType: _deviceType,
      deviceToken: _deviceToken,
      deviceId: _deviceId,
      cancelToken: _cancelToken,
    );
  }
}
