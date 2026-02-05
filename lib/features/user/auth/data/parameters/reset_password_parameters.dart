import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';

/// Reset Password API parameters with builder pattern
/// Used for resetting user password
/// Based on API_DOCUMENTATION.md
class ResetPasswordParameters extends Parameters {
  final String phone;
  final String token;
  final String password;
  final String passwordConfirmation;
  @override
  final CancelToken? cancelToken;

  const ResetPasswordParameters({
    required this.phone,
    required this.token,
    required this.password,
    required this.passwordConfirmation,
    this.cancelToken,
  });

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {
    'phone': phone,
    'token': token,
    'password': password,
    'password_confirmation': passwordConfirmation,
  };

  /// Create a builder for this parameters type
  ResetPasswordParametersBuilder builder() => ResetPasswordParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResetPasswordParameters &&
        other.phone == phone &&
        other.token == token &&
        other.password == password &&
        other.passwordConfirmation == passwordConfirmation &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode =>
      phone.hashCode ^
      token.hashCode ^
      password.hashCode ^
      passwordConfirmation.hashCode ^
      cancelToken.hashCode;

  @override
  String toString() =>
      'ResetPasswordParameters(phone: $phone, token: $token, password: ****, passwordConfirmation: ****, cancelToken: $cancelToken)';
}

/// Builder for ResetPasswordParameters
class ResetPasswordParametersBuilder
    extends ParametersBuilder<ResetPasswordParameters> {
  String? _phone;
  String? _token;
  String? _password;
  String? _passwordConfirmation;
  CancelToken? _cancelToken;

  ResetPasswordParametersBuilder();

  /// Set phone number
  ResetPasswordParametersBuilder withPhone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set reset token
  ResetPasswordParametersBuilder withToken(String token) {
    _token = token;
    return this;
  }

  /// Set new password
  ResetPasswordParametersBuilder withPassword(String password) {
    _password = password;
    return this;
  }

  /// Set password confirmation
  ResetPasswordParametersBuilder withPasswordConfirmation(
    String passwordConfirmation,
  ) {
    _passwordConfirmation = passwordConfirmation;
    return this;
  }

  /// Set cancel token
  @override
  ResetPasswordParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build ResetPasswordParameters
  @override
  ResetPasswordParameters build() {
    if (_phone == null || _phone!.isEmpty) {
      throw ArgumentError('Phone is required');
    }
    if (_token == null || _token!.isEmpty) {
      throw ArgumentError('Reset token is required');
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
    return ResetPasswordParameters(
      phone: _phone!,
      token: _token!,
      password: _password!,
      passwordConfirmation: _passwordConfirmation!,
      cancelToken: _cancelToken,
    );
  }
}
