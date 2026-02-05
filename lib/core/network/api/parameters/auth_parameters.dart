import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for user login
@immutable
class LoginParameters extends Parameters {
  final String _phone;
  final String _password;
  final String? _firebaseToken;
  final CancelToken? _cancelToken;

  const LoginParameters._({
    required String phone,
    required String password,
    String? firebaseToken,
    CancelToken? cancelToken,
  }) : _phone = phone,
       _password = password,
       _firebaseToken = firebaseToken,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'phone': _phone, 'password': _password};
    if (_firebaseToken != null) {
      json['firebase_token'] = _firebaseToken;
    }
    return json;
  }

  String get phone => _phone;
  String get password => _password;
  String? get firebaseToken => _firebaseToken;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static LoginParametersBuilder builder() => LoginParametersBuilder();
}

/// Builder for LoginParameters
class LoginParametersBuilder extends ParametersBuilder<LoginParameters> {
  String? _phone;
  String? _password;
  String? _firebaseToken;
  CancelToken? _cancelToken;

  /// Set the phone number
  LoginParametersBuilder withPhone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the password
  LoginParametersBuilder withPassword(String password) {
    _password = password;
    return this;
  }

  /// Set the Firebase token (optional)
  LoginParametersBuilder withFirebaseToken(String firebaseToken) {
    _firebaseToken = firebaseToken;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  LoginParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the LoginParameters
  @override
  LoginParameters build() {
    assert(_phone != null && _phone!.isNotEmpty, 'Phone is required');
    assert(_password != null && _password!.isNotEmpty, 'Password is required');

    return LoginParameters._(
      phone: _phone!,
      password: _password!,
      firebaseToken: _firebaseToken,
      cancelToken: _cancelToken,
    );
  }
}

/// Parameters for user registration
@immutable
class RegisterParameters extends Parameters {
  final String _companyType;
  final String _name;
  final String? _nickname;
  final String _phone;
  final String _password;
  final String _passwordConfirmation;
  final String _country;
  final String _governorate;
  final String _birthdate;
  final String _gender;
  final CancelToken? _cancelToken;

  const RegisterParameters._({
    required String companyType,
    required String name,
    String? nickname,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String country,
    required String governorate,
    required String birthdate,
    required String gender,
    CancelToken? cancelToken,
  }) : _companyType = companyType,
       _name = name,
       _nickname = nickname,
       _phone = phone,
       _password = password,
       _passwordConfirmation = passwordConfirmation,
       _country = country,
       _governorate = governorate,
       _birthdate = birthdate,
       _gender = gender,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'company_type': _companyType,
      'name': _name,
      'phone': _phone,
      'password': _password,
      'password_confirmation': _passwordConfirmation,
      'country': _country,
      'governorate': _governorate,
      'birthdate': _birthdate,
      'gender': _gender,
    };
    if (_nickname != null) {
      json['nickname'] = _nickname;
    }
    return json;
  }

  String get companyType => _companyType;
  String get name => _name;
  String? get nickname => _nickname;
  String get phone => _phone;
  String get password => _password;
  String get passwordConfirmation => _passwordConfirmation;
  String get country => _country;
  String get governorate => _governorate;
  String get birthdate => _birthdate;
  String get gender => _gender;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static RegisterParametersBuilder builder() => RegisterParametersBuilder();
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
  CancelToken? _cancelToken;

  /// Set the company type (customer, driver, or company)
  RegisterParametersBuilder withCompanyType(String companyType) {
    _companyType = companyType;
    return this;
  }

  /// Set the user's full name
  RegisterParametersBuilder withName(String name) {
    _name = name;
    return this;
  }

  /// Set the user's nickname (optional)
  RegisterParametersBuilder withNickname(String nickname) {
    _nickname = nickname;
    return this;
  }

  /// Set the phone number
  RegisterParametersBuilder withPhone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the password
  RegisterParametersBuilder withPassword(String password) {
    _password = password;
    return this;
  }

  /// Set the password confirmation
  RegisterParametersBuilder withPasswordConfirmation(
    String passwordConfirmation,
  ) {
    _passwordConfirmation = passwordConfirmation;
    return this;
  }

  /// Set the country
  RegisterParametersBuilder withCountry(String country) {
    _country = country;
    return this;
  }

  /// Set the governorate or state
  RegisterParametersBuilder withGovernorate(String governorate) {
    _governorate = governorate;
    return this;
  }

  /// Set the birthdate (format: YYYY-MM-DD)
  RegisterParametersBuilder withBirthdate(String birthdate) {
    _birthdate = birthdate;
    return this;
  }

  /// Set the gender (male or female)
  RegisterParametersBuilder withGender(String gender) {
    _gender = gender;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  RegisterParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the RegisterParameters
  @override
  RegisterParameters build() {
    assert(
      _companyType != null && _companyType!.isNotEmpty,
      'Company type is required',
    );
    assert(_name != null && _name!.isNotEmpty, 'Name is required');
    assert(_phone != null && _phone!.isNotEmpty, 'Phone is required');
    assert(_password != null && _password!.isNotEmpty, 'Password is required');
    assert(
      _passwordConfirmation != null && _passwordConfirmation!.isNotEmpty,
      'Password confirmation is required',
    );
    assert(_country != null && _country!.isNotEmpty, 'Country is required');
    assert(
      _governorate != null && _governorate!.isNotEmpty,
      'Governorate is required',
    );
    assert(
      _birthdate != null && _birthdate!.isNotEmpty,
      'Birthdate is required',
    );
    assert(_gender != null && _gender!.isNotEmpty, 'Gender is required');

    return RegisterParameters._(
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
      cancelToken: _cancelToken,
    );
  }
}

/// Parameters for user logout
@immutable
class LogoutParameters extends Parameters {
  final CancelToken? _cancelToken;

  const LogoutParameters._({CancelToken? cancelToken})
    : _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => const {};

  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static LogoutParametersBuilder builder() => LogoutParametersBuilder();
}

/// Builder for LogoutParameters
class LogoutParametersBuilder extends ParametersBuilder<LogoutParameters> {
  CancelToken? _cancelToken;

  /// Set the cancel token for request cancellation
  @override
  LogoutParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the LogoutParameters
  @override
  LogoutParameters build() {
    return LogoutParameters._(cancelToken: _cancelToken);
  }
}

/// Parameters for user verification
@immutable
class VerifyUserParameters extends Parameters {
  final String _code;
  final CancelToken? _cancelToken;

  const VerifyUserParameters._({required String code, CancelToken? cancelToken})
    : _code = code,
      _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {'code': _code};
  }

  String get code => _code;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static VerifyUserParametersBuilder builder() => VerifyUserParametersBuilder();
}

/// Builder for VerifyUserParameters
class VerifyUserParametersBuilder
    extends ParametersBuilder<VerifyUserParameters> {
  String? _code;
  CancelToken? _cancelToken;

  /// Set the verification code
  VerifyUserParametersBuilder withCode(String code) {
    _code = code;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  VerifyUserParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the VerifyUserParameters
  @override
  VerifyUserParameters build() {
    assert(_code != null && _code!.isNotEmpty, 'Verification code is required');

    return VerifyUserParameters._(code: _code!, cancelToken: _cancelToken);
  }
}

/// Parameters for resetting password
@immutable
class ResetPasswordParameters extends Parameters {
  final String _phone;
  final String _code;
  final String _password;
  final String _passwordConfirmation;
  final CancelToken? _cancelToken;

  const ResetPasswordParameters._({
    required String phone,
    required String code,
    required String password,
    required String passwordConfirmation,
    CancelToken? cancelToken,
  }) : _phone = phone,
       _code = code,
       _password = password,
       _passwordConfirmation = passwordConfirmation,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {
      'phone': _phone,
      'code': _code,
      'password': _password,
      'password_confirmation': _passwordConfirmation,
    };
  }

  String get phone => _phone;
  String get code => _code;
  String get password => _password;
  String get passwordConfirmation => _passwordConfirmation;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static ResetPasswordParametersBuilder builder() =>
      ResetPasswordParametersBuilder();
}

/// Builder for ResetPasswordParameters
class ResetPasswordParametersBuilder
    extends ParametersBuilder<ResetPasswordParameters> {
  String? _phone;
  String? _code;
  String? _password;
  String? _passwordConfirmation;
  CancelToken? _cancelToken;

  /// Set the phone number
  ResetPasswordParametersBuilder withPhone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the verification code
  ResetPasswordParametersBuilder withCode(String code) {
    _code = code;
    return this;
  }

  /// Set the new password
  ResetPasswordParametersBuilder withPassword(String password) {
    _password = password;
    return this;
  }

  /// Set the password confirmation
  ResetPasswordParametersBuilder withPasswordConfirmation(
    String passwordConfirmation,
  ) {
    _passwordConfirmation = passwordConfirmation;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  ResetPasswordParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the ResetPasswordParameters
  @override
  ResetPasswordParameters build() {
    assert(_phone != null && _phone!.isNotEmpty, 'Phone is required');
    assert(_code != null && _code!.isNotEmpty, 'Code is required');
    assert(_password != null && _password!.isNotEmpty, 'Password is required');
    assert(
      _passwordConfirmation != null && _passwordConfirmation!.isNotEmpty,
      'Password confirmation is required',
    );

    return ResetPasswordParameters._(
      phone: _phone!,
      code: _code!,
      password: _password!,
      passwordConfirmation: _passwordConfirmation!,
      cancelToken: _cancelToken,
    );
  }
}

/// Parameters for forgetting password
@immutable
class ForgetPasswordParameters extends Parameters {
  final String _phone;
  final CancelToken? _cancelToken;

  const ForgetPasswordParameters._({
    required String phone,
    CancelToken? cancelToken,
  }) : _phone = phone,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {'phone': _phone};
  }

  String get phone => _phone;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static ForgetPasswordParametersBuilder builder() =>
      ForgetPasswordParametersBuilder();
}

/// Builder for ForgetPasswordParameters
class ForgetPasswordParametersBuilder
    extends ParametersBuilder<ForgetPasswordParameters> {
  String? _phone;
  CancelToken? _cancelToken;

  /// Set the phone number
  ForgetPasswordParametersBuilder withPhone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  ForgetPasswordParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the ForgetPasswordParameters
  @override
  ForgetPasswordParameters build() {
    assert(_phone != null && _phone!.isNotEmpty, 'Phone is required');

    return ForgetPasswordParameters._(
      phone: _phone!,
      cancelToken: _cancelToken,
    );
  }
}

/// Parameters for confirmation code
@immutable
class ConfirmationCodeParameters extends Parameters {
  final String _phone;
  final CancelToken? _cancelToken;

  const ConfirmationCodeParameters._({
    required String phone,
    CancelToken? cancelToken,
  }) : _phone = phone,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {'phone': _phone};
  }

  String get phone => _phone;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static ConfirmationCodeParametersBuilder builder() =>
      ConfirmationCodeParametersBuilder();
}

/// Builder for ConfirmationCodeParameters
class ConfirmationCodeParametersBuilder
    extends ParametersBuilder<ConfirmationCodeParameters> {
  String? _phone;
  CancelToken? _cancelToken;

  /// Set the phone number
  ConfirmationCodeParametersBuilder withPhone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  ConfirmationCodeParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the ConfirmationCodeParameters
  @override
  ConfirmationCodeParameters build() {
    assert(_phone != null && _phone!.isNotEmpty, 'Phone is required');

    return ConfirmationCodeParameters._(
      phone: _phone!,
      cancelToken: _cancelToken,
    );
  }
}
