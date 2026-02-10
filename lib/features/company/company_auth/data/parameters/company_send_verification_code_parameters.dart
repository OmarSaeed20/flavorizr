// lib/features/company/company_auth/data/parameters/company_send_verification_code_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Company Send Verification Code API parameters
///
/// Used to send verification code to company phone number.
/// Based on API_DOCUMENTATION.md
class CompanySendVerificationCodeParameters extends Parameters {
  final String phone;
  final String phoneIsoCode;
  @override
  final CancelToken? cancelToken;

  const CompanySendVerificationCodeParameters({
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
  CompanySendVerificationCodeParametersBuilder builder() =>
      CompanySendVerificationCodeParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CompanySendVerificationCodeParameters &&
        other.phone == phone &&
        other.phoneIsoCode == phoneIsoCode &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode =>
      phone.hashCode ^ phoneIsoCode.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'CompanySendVerificationCodeParameters(phone: $phone, phoneIsoCode: $phoneIsoCode, cancelToken: $cancelToken)';
}

/// Builder for CompanySendVerificationCodeParameters
class CompanySendVerificationCodeParametersBuilder
    extends ParametersBuilder<CompanySendVerificationCodeParameters> {
  String? _phone;
  String? _phoneIsoCode;
  CancelToken? _cancelToken;

  /// Set the phone number
  CompanySendVerificationCodeParametersBuilder phone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the phone ISO code (e.g., 'EG', 'US')
  CompanySendVerificationCodeParametersBuilder phoneIsoCode(
    String phoneIsoCode,
  ) {
    _phoneIsoCode = phoneIsoCode;
    return this;
  }

  /// Set the cancel token for request cancellation
  CompanySendVerificationCodeParametersBuilder cancelToken(
    CancelToken cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ParametersBuilder<CompanySendVerificationCodeParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  CompanySendVerificationCodeParameters build() {
    return CompanySendVerificationCodeParameters(
      phone: _phone!,
      phoneIsoCode: _phoneIsoCode!,
      cancelToken: _cancelToken,
    );
  }
}
