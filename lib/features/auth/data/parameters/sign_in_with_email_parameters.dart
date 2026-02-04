import 'package:dio/dio.dart';
import 'package:flavorizr/features/auth/data/parameters/base_parameters.dart';

/// Sign In With Email API parameters with builder pattern
/// Used for email and password authentication
class SignInWithEmailParameters extends Parameters {
  final String email;
  final String password;
  @override
  final CancelToken? cancelToken;

  const SignInWithEmailParameters({
    required this.email,
    required this.password,
    this.cancelToken,
  });

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };

  /// Create a builder for this parameters type
  SignInWithEmailParametersBuilder builder() => SignInWithEmailParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SignInWithEmailParameters &&
        other.email == email &&
        other.password == password &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'SignInWithEmailParameters(email: $email, password: ****, cancelToken: $cancelToken)';
}

/// Builder for SignInWithEmailParameters
class SignInWithEmailParametersBuilder extends ParametersBuilder<SignInWithEmailParameters> {
  String? _email;
  String? _password;
  CancelToken? _cancelToken;

  SignInWithEmailParametersBuilder();

  /// Set email address
  SignInWithEmailParametersBuilder withEmail(String email) {
    _email = email;
    return this;
  }

  /// Set password
  SignInWithEmailParametersBuilder withPassword(String password) {
    _password = password;
    return this;
  }

  /// Set cancel token
  @override
  SignInWithEmailParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the parameters object
  @override
  SignInWithEmailParameters build() {
    return SignInWithEmailParameters(
      email: _email!,
      password: _password!,
      cancelToken: _cancelToken,
    );
  }
}