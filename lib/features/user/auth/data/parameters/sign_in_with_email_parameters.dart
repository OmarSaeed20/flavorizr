import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Sign In With Email API parameters with builder pattern
/// Used for phone and password authentication
class SignInWithPhoneParameters extends Parameters {
  final String phone;
  final String password;
  @override
  final CancelToken? cancelToken;

  const SignInWithPhoneParameters({required this.phone, required this.password, this.cancelToken});

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {'phone': phone, 'password': password};
  /// Create a builder for this parameters type
  SignInWithPhoneParametersBuilder builder() => SignInWithPhoneParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SignInWithPhoneParameters &&
        other.phone == phone &&
        other.password == password &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode => phone.hashCode ^ password.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'SignInWithPhoneParameters(phone: $phone, password: ****, cancelToken: $cancelToken)';
}

/// Builder for SignInWithPhoneParameters
class SignInWithPhoneParametersBuilder extends ParametersBuilder<SignInWithPhoneParameters> {
  String? _phone;
  String? _password;
  CancelToken? _cancelToken;

  SignInWithPhoneParametersBuilder();

  /// Set phone address
  SignInWithPhoneParametersBuilder withPhone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set password
  SignInWithPhoneParametersBuilder withPassword(String password) {
    _password = password;
    return this;
  }

  /// Set cancel token
  @override
  SignInWithPhoneParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the parameters object
  @override
  SignInWithPhoneParameters build() {
    return SignInWithPhoneParameters(
      phone: _phone!,
      password: _password!,
      cancelToken: _cancelToken,
    );
  }
}
