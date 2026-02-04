import 'package:dio/dio.dart';
import 'package:flavorizr/features/auth/data/parameters/base_parameters.dart';

/// Register API parameters with builder pattern
/// Used for new user registration
/// Based on API_DOCUMENTATION.md
class RegisterParameters extends Parameters {
  final String companyType;
  final String name;
  final String? nickname;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String country;
  final String governorate;
  final String birthdate;
  final String gender;
  final String? deviceType;
  final String? deviceToken;
  final String? deviceId;
  @override
  final CancelToken? cancelToken;

  const RegisterParameters({
    required this.companyType,
    required this.name,
    this.nickname,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.country,
    required this.governorate,
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
    'password': password,
    'password_confirmation': passwordConfirmation,
    'country': country,
    'governorate': governorate,
    'birthdate': birthdate,
    'gender': gender,
    if (deviceType != null) 'device_type': deviceType,
    if (deviceToken != null) 'device_token': deviceToken,
    if (deviceId != null) 'device_id': deviceId,
  };

  /// Create a builder for this parameters type
  RegisterParametersBuilder builder() => RegisterParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RegisterParameters &&
        other.companyType == companyType &&
        other.name == name &&
        other.nickname == nickname &&
        other.phone == phone &&
        other.password == password &&
        other.passwordConfirmation == passwordConfirmation &&
        other.country == country &&
        other.governorate == governorate &&
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
      password.hashCode ^
      passwordConfirmation.hashCode ^
      country.hashCode ^
      governorate.hashCode ^
      birthdate.hashCode ^
      gender.hashCode ^
      deviceType.hashCode ^
      deviceToken.hashCode ^
      deviceId.hashCode ^
      cancelToken.hashCode;

  @override
  String toString() =>
      'RegisterParameters(companyType: $companyType, name: $name, nickname: $nickname, phone: $phone, password: ****, passwordConfirmation: ****, country: $country, governorate: $governorate, birthdate: $birthdate, gender: $gender, deviceType: $deviceType, deviceToken: $deviceToken, deviceId: $deviceId, cancelToken: $cancelToken)';
}

/// Builder for RegisterParameters
class RegisterParametersBuilder extends ParametersBuilder<RegisterParameters> {
  String? _companyType;
  String? _name;
  String? _nickname;
  String? _phone;
  String? _password;
  String? _passwordConfirmation;
  String? _country;
  String? _governorate;
  String? _birthdate;
  String? _gender;
  String? _deviceType;
  String? _deviceToken;
  String? _deviceId;
  CancelToken? _cancelToken;

  RegisterParametersBuilder();

  /// Set company type (customer, driver, or company)
  RegisterParametersBuilder withCompanyType(String companyType) {
    _companyType = companyType;
    return this;
  }

  /// Set user name
  RegisterParametersBuilder withName(String name) {
    _name = name;
    return this;
  }

  /// Set nickname (optional)
  RegisterParametersBuilder withNickname(String? nickname) {
    _nickname = nickname;
    return this;
  }

  /// Set phone number
  RegisterParametersBuilder withPhone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set password
  RegisterParametersBuilder withPassword(String password) {
    _password = password;
    return this;
  }

  /// Set password confirmation
  RegisterParametersBuilder withPasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    return this;
  }

  /// Set country
  RegisterParametersBuilder withCountry(String country) {
    _country = country;
    return this;
  }

  /// Set governorate
  RegisterParametersBuilder withGovernorate(String governorate) {
    _governorate = governorate;
    return this;
  }

  /// Set birthdate (format: YYYY-MM-DD)
  RegisterParametersBuilder withBirthdate(String birthdate) {
    _birthdate = birthdate;
    return this;
  }

  /// Set gender (male or female)
  RegisterParametersBuilder withGender(String gender) {
    _gender = gender;
    return this;
  }

  /// Set device type (optional)
  RegisterParametersBuilder withDeviceType(String? deviceType) {
    _deviceType = deviceType;
    return this;
  }

  /// Set device token (optional)
  RegisterParametersBuilder withDeviceToken(String? deviceToken) {
    _deviceToken = deviceToken;
    return this;
  }

  /// Set device ID (optional)
  RegisterParametersBuilder withDeviceId(String? deviceId) {
    _deviceId = deviceId;
    return this;
  }

  /// Set cancel token
  @override
  RegisterParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build RegisterParameters
  @override
  RegisterParameters build() {
    if (_companyType == null || _companyType!.isEmpty) {
      throw ArgumentError('Company type is required');
    }
    if (_name == null || _name!.isEmpty) {
      throw ArgumentError('Name is required');
    }
    if (_phone == null || _phone!.isEmpty) {
      throw ArgumentError('Phone is required');
    }
    if (_password == null || _password!.isEmpty) {
      throw ArgumentError('Password is required');
    }
    if (_passwordConfirmation == null || _passwordConfirmation!.isEmpty) {
      throw ArgumentError('Password confirmation is required');
    }
    if (_password != _passwordConfirmation) {
      throw ArgumentError('Passwords do not match');
    }
    if (_country == null || _country!.isEmpty) {
      throw ArgumentError('Country is required');
    }
    if (_governorate == null || _governorate!.isEmpty) {
      throw ArgumentError('Governorate is required');
    }
    if (_birthdate == null || _birthdate!.isEmpty) {
      throw ArgumentError('Birthdate is required');
    }
    if (_gender == null || _gender!.isEmpty) {
      throw ArgumentError('Gender is required');
    }
    return RegisterParameters(
      companyType: _companyType!,
      name: _name!,
      nickname: _nickname,
      phone: _phone!,
      password: _password!,
      passwordConfirmation: _passwordConfirmation!,
      country: _country!,
      governorate: _governorate!,
      birthdate: _birthdate!,
      gender: _gender!,
      deviceType: _deviceType,
      deviceToken: _deviceToken,
      deviceId: _deviceId,
      cancelToken: _cancelToken,
    );
  }
}
