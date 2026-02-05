import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for verifying driver phone number.
///
/// Based on the FAST App API documentation for POST /driver/auth/user-verify
@immutable
class VerifyDriverPhoneParameters extends Parameters {
  final String _phone;
  final String _code;
  final String _firebaseToken;
  final CancelToken? _cancelToken;

  const VerifyDriverPhoneParameters._({
    required String phone,
    required String code,
    required String firebaseToken,
    CancelToken? cancelToken,
  }) : _phone = phone,
       _code = code,
       _firebaseToken = firebaseToken,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {'phone': _phone, 'code': _code, 'firebase_token': _firebaseToken};
  }

  String get phone => _phone;
  String get code => _code;
  String get firebaseToken => _firebaseToken;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static VerifyDriverPhoneParametersBuilder builder() =>
      VerifyDriverPhoneParametersBuilder();
}

/// Builder for VerifyDriverPhoneParameters
class VerifyDriverPhoneParametersBuilder
    extends ParametersBuilder<VerifyDriverPhoneParameters> {
  String? _phone;
  String? _code;
  String? _firebaseToken;
  CancelToken? _cancelToken;

  /// Set the phone number
  VerifyDriverPhoneParametersBuilder withPhone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the verification code
  VerifyDriverPhoneParametersBuilder withCode(String code) {
    _code = code;
    return this;
  }

  /// Set the Firebase token
  VerifyDriverPhoneParametersBuilder withFirebaseToken(String firebaseToken) {
    _firebaseToken = firebaseToken;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  VerifyDriverPhoneParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the VerifyDriverPhoneParameters
  @override
  VerifyDriverPhoneParameters build() {
    if (_phone == null) {
      throw ArgumentError('Phone is required');
    }
    if (_code == null) {
      throw ArgumentError('Code is required');
    }
    if (_firebaseToken == null) {
      throw ArgumentError('Firebase token is required');
    }
    return VerifyDriverPhoneParameters._(
      phone: _phone!,
      code: _code!,
      firebaseToken: _firebaseToken!,
      cancelToken: _cancelToken,
    );
  }
}
