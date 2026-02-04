import 'package:dio/dio.dart';
import 'package:flavorizr/features/auth/data/parameters/base_parameters.dart';

/// Sign In With OTP API parameters with builder pattern
/// Used for OTP-based authentication
class SignInWithOtpParameters extends Parameters {
  final String verificationId;
  final String otpCode;
  @override
  final CancelToken? cancelToken;

  const SignInWithOtpParameters({
    required this.verificationId,
    required this.otpCode,
    this.cancelToken,
  });

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {
    'verification_id': verificationId,
    'otp_code': otpCode,
  };

  /// Create a builder for this parameters type
  SignInWithOtpParametersBuilder builder() => SignInWithOtpParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SignInWithOtpParameters &&
        other.verificationId == verificationId &&
        other.otpCode == otpCode &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode => verificationId.hashCode ^ otpCode.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'SignInWithOtpParameters(verificationId: $verificationId, otpCode: ****, cancelToken: $cancelToken)';
}

/// Builder for SignInWithOtpParameters
class SignInWithOtpParametersBuilder extends ParametersBuilder<SignInWithOtpParameters> {
  String? _verificationId;
  String? _otpCode;
  CancelToken? _cancelToken;

  SignInWithOtpParametersBuilder();

  /// Set verification ID
  SignInWithOtpParametersBuilder withVerificationId(String verificationId) {
    _verificationId = verificationId;
    return this;
  }

  /// Set OTP code
  SignInWithOtpParametersBuilder withOtpCode(String otpCode) {
    _otpCode = otpCode;
    return this;
  }

  /// Set cancel token
  @override
  SignInWithOtpParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the parameters object
  @override
  SignInWithOtpParameters build() {
    return SignInWithOtpParameters(
      verificationId: _verificationId!,
      otpCode: _otpCode!,
      cancelToken: _cancelToken,
    );
  }
}