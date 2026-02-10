// lib/features/consumer/consumer_auth/data/parameters/consumer_send_verification_code_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Consumer Send Verification Code API parameters
///
/// Used for sending OTP code to consumer's phone.
/// Based on API_DOCUMENTATION.md
class ConsumerSendVerificationCodeParameters extends Parameters {
  final String phone;
  final String phoneIsoCode;
  @override
  final CancelToken? cancelToken;

  const ConsumerSendVerificationCodeParameters({
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
  ConsumerSendVerificationCodeParametersBuilder builder() =>
      ConsumerSendVerificationCodeParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConsumerSendVerificationCodeParameters &&
        other.phone == phone &&
        other.phoneIsoCode == phoneIsoCode &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode =>
      phone.hashCode ^ phoneIsoCode.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'ConsumerSendVerificationCodeParameters(phone: $phone, phoneIsoCode: $phoneIsoCode, cancelToken: $cancelToken)';
}

/// Builder for ConsumerSendVerificationCodeParameters
class ConsumerSendVerificationCodeParametersBuilder
    extends ParametersBuilder<ConsumerSendVerificationCodeParameters> {
  String? _phone;
  String? _phoneIsoCode;
  CancelToken? _cancelToken;

  /// Set the phone number
  ConsumerSendVerificationCodeParametersBuilder phone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the phone ISO code (e.g., 'EG', 'US')
  ConsumerSendVerificationCodeParametersBuilder phoneIsoCode(
    String phoneIsoCode,
  ) {
    _phoneIsoCode = phoneIsoCode;
    return this;
  }

  /// Set the cancel token for request cancellation
  ConsumerSendVerificationCodeParametersBuilder cancelToken(
    CancelToken cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ParametersBuilder<ConsumerSendVerificationCodeParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ConsumerSendVerificationCodeParameters build() {
    return ConsumerSendVerificationCodeParameters(
      phone: _phone!,
      phoneIsoCode: _phoneIsoCode!,
      cancelToken: _cancelToken,
    );
  }
}
