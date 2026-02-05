import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';

/// Send OTP API parameters with builder pattern
/// Used for sending OTP to phone number
class SendOtpParameters extends Parameters {
  final String phoneNumber;
  @override
  final CancelToken? cancelToken;

  const SendOtpParameters({
    required this.phoneNumber,
    this.cancelToken,
  });

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {'phone_number': phoneNumber};

  /// Create a builder for this parameters type
  SendOtpParametersBuilder builder() => SendOtpParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SendOtpParameters &&
        other.phoneNumber == phoneNumber &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode => phoneNumber.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'SendOtpParameters(phoneNumber: $phoneNumber, cancelToken: $cancelToken)';
}

/// Builder for SendOtpParameters
class SendOtpParametersBuilder extends ParametersBuilder<SendOtpParameters> {
  String? _phoneNumber;
  CancelToken? _cancelToken;

  SendOtpParametersBuilder();

  /// Set phone number
  SendOtpParametersBuilder withPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
    return this;
  }

  /// Set cancel token
  @override
  SendOtpParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the parameters object
  @override
  SendOtpParameters build() {
    return SendOtpParameters(
      phoneNumber: _phoneNumber!,
      cancelToken: _cancelToken,
    );
  }
}