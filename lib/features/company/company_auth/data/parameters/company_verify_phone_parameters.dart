// lib/features/company/company_auth/data/parameters/company_verify_phone_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Company Verify Phone API parameters
///
/// Used to verify company phone number with confirmation code.
/// Based on API_DOCUMENTATION.md
class CompanyVerifyPhoneParameters extends Parameters {
  final String phone;
  final String phoneIsoCode;
  final String confirmationCode;
  @override
  final CancelToken? cancelToken;

  const CompanyVerifyPhoneParameters({
    required this.phone,
    required this.phoneIsoCode,
    required this.confirmationCode,
    this.cancelToken,
  });

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {
    'phone': phone,
    'phone_iso_code': phoneIsoCode,
    'confirmation_code': confirmationCode,
  };

  /// Create a builder for this parameters type
  CompanyVerifyPhoneParametersBuilder builder() =>
      CompanyVerifyPhoneParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CompanyVerifyPhoneParameters &&
        other.phone == phone &&
        other.phoneIsoCode == phoneIsoCode &&
        other.confirmationCode == confirmationCode &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode =>
      phone.hashCode ^
      phoneIsoCode.hashCode ^
      confirmationCode.hashCode ^
      cancelToken.hashCode;

  @override
  String toString() =>
      'CompanyVerifyPhoneParameters(phone: $phone, phoneIsoCode: $phoneIsoCode, confirmationCode: $confirmationCode, cancelToken: $cancelToken)';
}

/// Builder for CompanyVerifyPhoneParameters
class CompanyVerifyPhoneParametersBuilder
    extends ParametersBuilder<CompanyVerifyPhoneParameters> {
  String? _phone;
  String? _phoneIsoCode;
  String? _confirmationCode;
  CancelToken? _cancelToken;

  /// Set the phone number
  CompanyVerifyPhoneParametersBuilder phone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the phone ISO code (e.g., 'EG', 'US')
  CompanyVerifyPhoneParametersBuilder phoneIsoCode(String phoneIsoCode) {
    _phoneIsoCode = phoneIsoCode;
    return this;
  }

  /// Set the confirmation code
  CompanyVerifyPhoneParametersBuilder confirmationCode(
    String confirmationCode,
  ) {
    _confirmationCode = confirmationCode;
    return this;
  }

  /// Set the cancel token for request cancellation
  CompanyVerifyPhoneParametersBuilder cancelToken(CancelToken cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ParametersBuilder<CompanyVerifyPhoneParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  CompanyVerifyPhoneParameters build() {
    return CompanyVerifyPhoneParameters(
      phone: _phone!,
      phoneIsoCode: _phoneIsoCode!,
      confirmationCode: _confirmationCode!,
      cancelToken: _cancelToken,
    );
  }
}
