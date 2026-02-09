import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for resetting driver password.
///
/// Based on the FAST App API documentation for POST /driver/auth/reset-password
@immutable
class ResetDriverPasswordParameters extends Parameters {
  final String _code;
  final String _phone;
  final String _password;
  final String _passwordConfirmation;
  final CancelToken? _cancelToken;

  const ResetDriverPasswordParameters._({
    required String code,
    required String phone,
    required String password,
    required String passwordConfirmation,
    CancelToken? cancelToken,
  }) : _code = code,
       _phone = phone,
       _password = password,
       _passwordConfirmation = passwordConfirmation,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {
      'code': _code,
      'phone': _phone,
      'password': _password,
      'password_confirmation': _passwordConfirmation,
    };
  }

  String get code => _code;
  String get phone => _phone;
  String get password => _password;
  String get passwordConfirmation => _passwordConfirmation;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static ResetDriverPasswordParametersBuilder builder() => ResetDriverPasswordParametersBuilder();
}

/// Builder for ResetDriverPasswordParameters
class ResetDriverPasswordParametersBuilder
    extends ParametersBuilder<ResetDriverPasswordParameters> {
  String? _code;
  String? _phone;
  String? _password;
  String? _passwordConfirmation;
  CancelToken? _cancelToken;

  /// Set the verification code
  ResetDriverPasswordParametersBuilder withCode(String code) {
    _code = code;
    return this;
  }

  /// Set the phone number
  ResetDriverPasswordParametersBuilder withPhone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the new password
  ResetDriverPasswordParametersBuilder withPassword(String password) {
    _password = password;
    return this;
  }

  /// Set the password confirmation
  ResetDriverPasswordParametersBuilder withPasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  ResetDriverPasswordParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the ResetDriverPasswordParameters
  @override
  ResetDriverPasswordParameters build() {
    if (_code == null) {
      throw ArgumentError('Code is required');
    }
    if (_phone == null) {
      throw ArgumentError('Phone is required');
    }
    if (_password == null) {
      throw ArgumentError('Password is required');
    }
    if (_passwordConfirmation == null) {
      throw ArgumentError('Password confirmation is required');
    }
    return ResetDriverPasswordParameters._(
      code: _code!,
      phone: _phone!,
      password: _password!,
      passwordConfirmation: _passwordConfirmation!,
      cancelToken: _cancelToken,
    );
  }
}
