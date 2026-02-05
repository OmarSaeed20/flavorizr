import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';

/// Verify Phone API parameters with builder pattern
/// Used for verifying user phone number with verification code
/// Based on API_DOCUMENTATION.md
class VerifyPhoneParameters extends Parameters {
  final String phone;
  final String verificationCode;
  final String firebaseToken;
  @override
  final CancelToken? cancelToken;

  const VerifyPhoneParameters({
    required this.phone,
    required this.verificationCode,
    required this.firebaseToken,
    this.cancelToken,
  });

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {
    'phone': phone,
    'verification_code': verificationCode,
    'firebase_token': firebaseToken,
  };

  /// Create a builder for this parameters type
  VerifyPhoneParametersBuilder builder() => VerifyPhoneParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VerifyPhoneParameters &&
        other.phone == phone &&
        other.verificationCode == verificationCode &&
        other.firebaseToken == firebaseToken &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode =>
      phone.hashCode ^
      verificationCode.hashCode ^
      firebaseToken.hashCode ^
      cancelToken.hashCode;

  @override
  String toString() =>
      'VerifyPhoneParameters(phone: $phone, verificationCode: $verificationCode, firebaseToken: $firebaseToken, cancelToken: $cancelToken)';
}

/// Builder for VerifyPhoneParameters
class VerifyPhoneParametersBuilder
    extends ParametersBuilder<VerifyPhoneParameters> {
  String? _phone;
  String? _verificationCode;
  String? _firebaseToken;
  CancelToken? _cancelToken;

  VerifyPhoneParametersBuilder();

  /// Set phone number
  VerifyPhoneParametersBuilder withPhone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set verification code
  VerifyPhoneParametersBuilder withVerificationCode(String verificationCode) {
    _verificationCode = verificationCode;
    return this;
  }

  /// Set Firebase token for push notifications
  VerifyPhoneParametersBuilder withFirebaseToken(String firebaseToken) {
    _firebaseToken = firebaseToken;
    return this;
  }

  /// Set cancel token
  @override
  VerifyPhoneParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build VerifyPhoneParameters
  @override
  VerifyPhoneParameters build() {
    if (_phone == null || _phone!.isEmpty) {
      throw ArgumentError('Phone is required');
    }
    if (_verificationCode == null || _verificationCode!.isEmpty) {
      throw ArgumentError('Verification code is required');
    }
    if (_firebaseToken == null || _firebaseToken!.isEmpty) {
      throw ArgumentError('Firebase token is required');
    }
    return VerifyPhoneParameters(
      phone: _phone!,
      verificationCode: _verificationCode!,
      firebaseToken: _firebaseToken!,
      cancelToken: _cancelToken,
    );
  }
}
