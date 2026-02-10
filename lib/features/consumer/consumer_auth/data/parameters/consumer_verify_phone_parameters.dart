// lib/features/consumer/consumer_auth/data/parameters/consumer_verify_phone_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Consumer Verify Phone API parameters
///
/// Used for verifying consumer phone number with OTP code.
/// Based on API_DOCUMENTATION.md
class ConsumerVerifyPhoneParameters extends Parameters {
  final String phone;
  final String phoneIsoCode;
  final String code;
  @override
  final CancelToken? cancelToken;

  const ConsumerVerifyPhoneParameters({
    required this.phone,
    required this.phoneIsoCode,
    required this.code,
    this.cancelToken,
  });

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {'phone': phone, 'phone_iso_code': phoneIsoCode, 'code': code};

  /// Create a builder for this parameters type
  ConsumerVerifyPhoneParametersBuilder builder() => ConsumerVerifyPhoneParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConsumerVerifyPhoneParameters &&
        other.phone == phone &&
        other.phoneIsoCode == phoneIsoCode &&
        other.code == code &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode => phone.hashCode ^ phoneIsoCode.hashCode ^ code.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'ConsumerVerifyPhoneParameters(phone: $phone, phoneIsoCode: $phoneIsoCode, code: ****, cancelToken: $cancelToken)';
}

/// Builder for ConsumerVerifyPhoneParameters
class ConsumerVerifyPhoneParametersBuilder
    extends ParametersBuilder<ConsumerVerifyPhoneParameters> {
  String? _phone;
  String? _phoneIsoCode;
  String? _code;
  CancelToken? _cancelToken;

  /// Set the phone number
  ConsumerVerifyPhoneParametersBuilder phone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the phone ISO code (e.g., 'EG', 'US')
  ConsumerVerifyPhoneParametersBuilder phoneIsoCode(String phoneIsoCode) {
    _phoneIsoCode = phoneIsoCode;
    return this;
  }

  /// Set the verification code
  ConsumerVerifyPhoneParametersBuilder code(String code) {
    _code = code;
    return this;
  }

  /// Set the cancel token for request cancellation
  ConsumerVerifyPhoneParametersBuilder cancelToken(CancelToken cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ParametersBuilder<ConsumerVerifyPhoneParameters> withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ConsumerVerifyPhoneParameters build() {
    return ConsumerVerifyPhoneParameters(
      phone: _phone!,
      phoneIsoCode: _phoneIsoCode!,
      code: _code!,
      cancelToken: _cancelToken,
    );
  }
}
