// lib/features/company/company_auth/data/parameters/company_register_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Company Register API parameters
///
/// Used for new company registration.
/// Companies are fleet management accounts with company_type: "company".
/// Based on API_DOCUMENTATION.md
class CompanyRegisterParameters extends Parameters {
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

  const CompanyRegisterParameters({
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
  CompanyRegisterParametersBuilder builder() => CompanyRegisterParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CompanyRegisterParameters &&
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
      'CompanyRegisterParameters(companyType: $companyType, name: $name, nickname: $nickname, phone: $phone, phoneIso2Code: $phoneIso2Code, password: ****, countryId: $countryId, governorateId: $governorateId, birthdate: $birthdate, gender: $gender, deviceType: $deviceType, deviceToken: $deviceToken, deviceId: $deviceId, cancelToken: $cancelToken)';
}

/// Builder for CompanyRegisterParameters
class CompanyRegisterParametersBuilder extends ParametersBuilder<CompanyRegisterParameters> {
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

  /// Set the company type (should be "company" for companies)
  CompanyRegisterParametersBuilder companyType(String companyType) {
    _companyType = companyType;
    return this;
  }

  /// Set the company's full name
  CompanyRegisterParametersBuilder name(String name) {
    _name = name;
    return this;
  }

  /// Set the company's nickname (optional)
  CompanyRegisterParametersBuilder nickname(String nickname) {
    _nickname = nickname;
    return this;
  }

  /// Set the phone number
  CompanyRegisterParametersBuilder phone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the phone ISO2 code (e.g., 'EG', 'US')
  CompanyRegisterParametersBuilder phoneIso2Code(String phoneIso2Code) {
    _phoneIso2Code = phoneIso2Code;
    return this;
  }

  /// Set the password
  CompanyRegisterParametersBuilder password(String password) {
    _password = password;
    return this;
  }

  /// Set the password confirmation
  CompanyRegisterParametersBuilder passwordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    return this;
  }

  /// Set the country ID
  CompanyRegisterParametersBuilder countryId(int countryId) {
    _countryId = countryId;
    return this;
  }

  /// Set the governorate ID
  CompanyRegisterParametersBuilder governorateId(int governorateId) {
    _governorateId = governorateId;
    return this;
  }

  /// Set the birthdate (YYYY-MM-DD format)
  CompanyRegisterParametersBuilder birthdate(String birthdate) {
    _birthdate = birthdate;
    return this;
  }

  /// Set the gender ('male' or 'female')
  CompanyRegisterParametersBuilder gender(String gender) {
    _gender = gender;
    return this;
  }

  /// Set the device type (e.g., 'ios', 'android')
  CompanyRegisterParametersBuilder deviceType(String deviceType) {
    _deviceType = deviceType;
    return this;
  }

  /// Set the device token for push notifications
  CompanyRegisterParametersBuilder deviceToken(String deviceToken) {
    _deviceToken = deviceToken;
    return this;
  }

  /// Set the device ID
  CompanyRegisterParametersBuilder deviceId(String deviceId) {
    _deviceId = deviceId;
    return this;
  }

  /// Set the cancel token for request cancellation
  CompanyRegisterParametersBuilder cancelToken(CancelToken cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ParametersBuilder<CompanyRegisterParameters> withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  CompanyRegisterParameters build() {
    return CompanyRegisterParameters(
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
