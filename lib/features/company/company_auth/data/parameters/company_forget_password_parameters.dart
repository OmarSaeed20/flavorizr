// lib/features/company/company_auth/data/parameters/company_forget_password_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Company Forget Password API parameters
///
/// Used to initiate password reset for company account.
/// Based on API_DOCUMENTATION.md
class CompanyForgetPasswordParameters extends Parameters {
  final String phone;
  final String phoneIsoCode;
  @override
  final CancelToken? cancelToken;

  const CompanyForgetPasswordParameters({
    required this.phone,
    required this.phoneIsoCode,
    this.cancelToken,
  });

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {
    'phone': phone,
    'phone_iso_code': phoneIsoCode,
  };

  /// Create a builder for this parameters type
  CompanyForgetPasswordParametersBuilder builder() =>
      CompanyForgetPasswordParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CompanyForgetPasswordParameters &&
        other.phone == phone &&
        other.phoneIsoCode == phoneIsoCode &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode =>
      phone.hashCode ^ phoneIsoCode.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'CompanyForgetPasswordParameters(phone: $phone, phoneIsoCode: $phoneIsoCode, cancelToken: $cancelToken)';
}

/// Builder for CompanyForgetPasswordParameters
class CompanyForgetPasswordParametersBuilder
    extends ParametersBuilder<CompanyForgetPasswordParameters> {
  String? _phone;
  String? _phoneIsoCode;
  CancelToken? _cancelToken;

  /// Set the phone number
  CompanyForgetPasswordParametersBuilder phone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the phone ISO code (e.g., 'EG', 'US')
  CompanyForgetPasswordParametersBuilder phoneIsoCode(String phoneIsoCode) {
    _phoneIsoCode = phoneIsoCode;
    return this;
  }

  /// Set the cancel token for request cancellation
  CompanyForgetPasswordParametersBuilder cancelToken(CancelToken cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ParametersBuilder<CompanyForgetPasswordParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  CompanyForgetPasswordParameters build() {
    return CompanyForgetPasswordParameters(
      phone: _phone!,
      phoneIsoCode: _phoneIsoCode!,
      cancelToken: _cancelToken,
    );
  }
}
