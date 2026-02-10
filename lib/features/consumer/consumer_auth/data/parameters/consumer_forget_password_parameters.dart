// lib/features/consumer/consumer_auth/data/parameters/consumer_forget_password_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Consumer Forget Password API parameters
///
/// Used for requesting password reset code.
/// Based on API_DOCUMENTATION.md
class ConsumerForgetPasswordParameters extends Parameters {
  final String phone;
  final String phoneIsoCode;
  @override
  final CancelToken? cancelToken;

  const ConsumerForgetPasswordParameters({
    required this.phone,
    required this.phoneIsoCode,
    this.cancelToken,
  });

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {'phone': phone, 'phone_iso_code': phoneIsoCode};

  /// Create a builder for this parameters type
  ConsumerForgetPasswordParametersBuilder builder() => ConsumerForgetPasswordParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConsumerForgetPasswordParameters &&
        other.phone == phone &&
        other.phoneIsoCode == phoneIsoCode &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode => phone.hashCode ^ phoneIsoCode.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'ConsumerForgetPasswordParameters(phone: $phone, phoneIsoCode: $phoneIsoCode, cancelToken: $cancelToken)';
}

/// Builder for ConsumerForgetPasswordParameters
class ConsumerForgetPasswordParametersBuilder
    extends ParametersBuilder<ConsumerForgetPasswordParameters> {
  String? _phone;
  String? _phoneIsoCode;
  CancelToken? _cancelToken;

  /// Set the phone number
  ConsumerForgetPasswordParametersBuilder phone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the phone ISO code (e.g., 'EG', 'US')
  ConsumerForgetPasswordParametersBuilder phoneIsoCode(String phoneIsoCode) {
    _phoneIsoCode = phoneIsoCode;
    return this;
  }

  /// Set the cancel token for request cancellation
  ConsumerForgetPasswordParametersBuilder cancelToken(CancelToken cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ParametersBuilder<ConsumerForgetPasswordParameters> withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ConsumerForgetPasswordParameters build() {
    return ConsumerForgetPasswordParameters(
      phone: _phone!,
      phoneIsoCode: _phoneIsoCode!,
      cancelToken: _cancelToken,
    );
  }
}
