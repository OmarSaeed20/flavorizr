// lib/features/consumer/consumer_auth/data/parameters/consumer_reset_password_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Consumer Reset Password API parameters
///
/// Used for resetting password with verification code.
/// Based on API_DOCUMENTATION.md
class ConsumerResetPasswordParameters extends Parameters {
  final String phone;
  final String phoneIsoCode;
  final String code;
  final String password;
  final String passwordConfirmation;
  @override
  final CancelToken? cancelToken;

  const ConsumerResetPasswordParameters({
    required this.phone,
    required this.phoneIsoCode,
    required this.code,
    required this.password,
    required this.passwordConfirmation,
    this.cancelToken,
  });

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {
    'phone': phone,
    'phone_iso_code': phoneIsoCode,
    'code': code,
    'password': password,
    'password_confirmation': passwordConfirmation,
  };

  /// Create a builder for this parameters type
  ConsumerResetPasswordParametersBuilder builder() =>
      ConsumerResetPasswordParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConsumerResetPasswordParameters &&
        other.phone == phone &&
        other.phoneIsoCode == phoneIsoCode &&
        other.code == code &&
        other.password == password &&
        other.passwordConfirmation == passwordConfirmation &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode =>
      phone.hashCode ^
      phoneIsoCode.hashCode ^
      code.hashCode ^
      password.hashCode ^
      passwordConfirmation.hashCode ^
      cancelToken.hashCode;

  @override
  String toString() =>
      'ConsumerResetPasswordParameters(phone: $phone, phoneIsoCode: $phoneIsoCode, code: ****, password: ****, passwordConfirmation: ****, cancelToken: $cancelToken)';
}

/// Builder for ConsumerResetPasswordParameters
class ConsumerResetPasswordParametersBuilder
    extends ParametersBuilder<ConsumerResetPasswordParameters> {
  String? _phone;
  String? _phoneIsoCode;
  String? _code;
  String? _password;
  String? _passwordConfirmation;
  CancelToken? _cancelToken;

  /// Set the phone number
  ConsumerResetPasswordParametersBuilder phone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the phone ISO code (e.g., 'EG', 'US')
  ConsumerResetPasswordParametersBuilder phoneIsoCode(String phoneIsoCode) {
    _phoneIsoCode = phoneIsoCode;
    return this;
  }

  /// Set the verification code
  ConsumerResetPasswordParametersBuilder code(String code) {
    _code = code;
    return this;
  }

  /// Set the new password
  ConsumerResetPasswordParametersBuilder password(String password) {
    _password = password;
    return this;
  }

  /// Set the password confirmation
  ConsumerResetPasswordParametersBuilder passwordConfirmation(
    String passwordConfirmation,
  ) {
    _passwordConfirmation = passwordConfirmation;
    return this;
  }

  /// Set the cancel token for request cancellation
  ConsumerResetPasswordParametersBuilder cancelToken(CancelToken cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ParametersBuilder<ConsumerResetPasswordParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ConsumerResetPasswordParameters build() {
    return ConsumerResetPasswordParameters(
      phone: _phone!,
      phoneIsoCode: _phoneIsoCode!,
      code: _code!,
      password: _password!,
      passwordConfirmation: _passwordConfirmation!,
      cancelToken: _cancelToken,
    );
  }
}
