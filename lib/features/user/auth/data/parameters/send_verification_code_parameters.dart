import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Send Verification Code API parameters with builder pattern
/// Used for sending verification code to user's phone number
/// Based on API_DOCUMENTATION.md
class SendVerificationCodeParameters extends Parameters {
  final String phone;
  @override
  final CancelToken? cancelToken;

  const SendVerificationCodeParameters({required this.phone, this.cancelToken});

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {'phone': phone};

  /// Create a builder for this parameters type
  SendVerificationCodeParametersBuilder builder() => SendVerificationCodeParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SendVerificationCodeParameters &&
        other.phone == phone &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode => phone.hashCode ^ cancelToken.hashCode;

  @override
  String toString() => 'SendVerificationCodeParameters(phone: $phone, cancelToken: $cancelToken)';
}

/// Builder for SendVerificationCodeParameters
class SendVerificationCodeParametersBuilder
    extends ParametersBuilder<SendVerificationCodeParameters> {
  String? _phone;
  CancelToken? _cancelToken;

  SendVerificationCodeParametersBuilder();

  /// Set phone number
  SendVerificationCodeParametersBuilder withPhone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set cancel token
  @override
  SendVerificationCodeParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build SendVerificationCodeParameters
  @override
  SendVerificationCodeParameters build() {
    if (_phone == null || _phone!.isEmpty) {
      throw ArgumentError('Phone is required');
    }
    return SendVerificationCodeParameters(phone: _phone!, cancelToken: _cancelToken);
  }
}
