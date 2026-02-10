import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Save Biometric Credentials API parameters with builder pattern
/// Used for saving credentials for biometric authentication
class SaveBiometricCredentialsParameters extends Parameters {
  final String email;
  final String password;
  @override
  final CancelToken? cancelToken;

  const SaveBiometricCredentialsParameters({
    required this.email,
    required this.password,
    this.cancelToken,
  });

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {'email': email, 'password': password};

  /// Create a builder for this parameters type
  SaveBiometricCredentialsParametersBuilder builder() =>
      SaveBiometricCredentialsParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SaveBiometricCredentialsParameters &&
        other.email == email &&
        other.password == password &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'SaveBiometricCredentialsParameters(email: $email, password: ****, cancelToken: $cancelToken)';
}

/// Builder for SaveBiometricCredentialsParameters
class SaveBiometricCredentialsParametersBuilder
    extends ParametersBuilder<SaveBiometricCredentialsParameters> {
  String? _email;
  String? _password;
  CancelToken? _cancelToken;

  SaveBiometricCredentialsParametersBuilder();

  /// Set email address
  SaveBiometricCredentialsParametersBuilder withEmail(String email) {
    _email = email;
    return this;
  }

  /// Set password
  SaveBiometricCredentialsParametersBuilder withPassword(String password) {
    _password = password;
    return this;
  }

  /// Set cancel token
  @override
  SaveBiometricCredentialsParametersBuilder withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the parameters object
  @override
  SaveBiometricCredentialsParameters build() {
    return SaveBiometricCredentialsParameters(
      email: _email!,
      password: _password!,
      cancelToken: _cancelToken,
    );
  }
}
