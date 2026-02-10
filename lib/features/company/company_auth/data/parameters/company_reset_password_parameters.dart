// lib/features/company/company_auth/data/parameters/company_reset_password_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Company Reset Password API parameters
///
/// Used to reset company password with verification code.
/// Based on API_DOCUMENTATION.md
class CompanyResetPasswordParameters extends Parameters {
  final String phone;
  final String phoneIsoCode;
  final String confirmationCode;
  final String password;
  final String passwordConfirmation;
  @override
  final CancelToken? cancelToken;

  const CompanyResetPasswordParameters({
    required this.phone,
    required this.phoneIsoCode,
    required this.confirmationCode,
    required this.password,
    required this.passwordConfirmation,
    this.cancelToken,
  });

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {
    'phone': phone,
    'phone_iso_code': phoneIsoCode,
    'confirmation_code': confirmationCode,
    'password': password,
    'password_confirmation': passwordConfirmation,
  };

  /// Create a builder for this parameters type
  CompanyResetPasswordParametersBuilder builder() => CompanyResetPasswordParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CompanyResetPasswordParameters &&
        other.phone == phone &&
        other.phoneIsoCode == phoneIsoCode &&
        other.confirmationCode == confirmationCode &&
        other.password == password &&
        other.passwordConfirmation == passwordConfirmation &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode =>
      phone.hashCode ^
      phoneIsoCode.hashCode ^
      confirmationCode.hashCode ^
      password.hashCode ^
      passwordConfirmation.hashCode ^
      cancelToken.hashCode;

  @override
  String toString() =>
      'CompanyResetPasswordParameters(phone: $phone, phoneIsoCode: $phoneIsoCode, confirmationCode: $confirmationCode, password: ****, passwordConfirmation: ****, cancelToken: $cancelToken)';
}

/// Builder for CompanyResetPasswordParameters
class CompanyResetPasswordParametersBuilder
    extends ParametersBuilder<CompanyResetPasswordParameters> {
  String? _phone;
  String? _phoneIsoCode;
  String? _confirmationCode;
  String? _password;
  String? _passwordConfirmation;
  CancelToken? _cancelToken;

  /// Set the phone number
  CompanyResetPasswordParametersBuilder phone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the phone ISO code (e.g., 'EG', 'US')
  CompanyResetPasswordParametersBuilder phoneIsoCode(String phoneIsoCode) {
    _phoneIsoCode = phoneIsoCode;
    return this;
  }

  /// Set the confirmation code
  CompanyResetPasswordParametersBuilder confirmationCode(String confirmationCode) {
    _confirmationCode = confirmationCode;
    return this;
  }

  /// Set the new password
  CompanyResetPasswordParametersBuilder password(String password) {
    _password = password;
    return this;
  }

  /// Set the password confirmation
  CompanyResetPasswordParametersBuilder passwordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    return this;
  }

  /// Set the cancel token for request cancellation
  CompanyResetPasswordParametersBuilder cancelToken(CancelToken cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ParametersBuilder<CompanyResetPasswordParameters> withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  CompanyResetPasswordParameters build() {
    return CompanyResetPasswordParameters(
      phone: _phone!,
      phoneIsoCode: _phoneIsoCode!,
      confirmationCode: _confirmationCode!,
      password: _password!,
      passwordConfirmation: _passwordConfirmation!,
      cancelToken: _cancelToken,
    );
  }
}
