import 'package:dio/dio.dart';
import 'package:flavorizr/features/auth/data/parameters/base_parameters.dart';

/// Send Password Reset Email API parameters with builder pattern
/// Used for requesting password reset via email
class SendPasswordResetEmailParameters extends Parameters {
  final String email;
  @override
  final CancelToken? cancelToken;

  const SendPasswordResetEmailParameters({
    required this.email,
    this.cancelToken,
  });

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {'email': email};

  /// Create a builder for this parameters type
  SendPasswordResetEmailParametersBuilder builder() =>
      SendPasswordResetEmailParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SendPasswordResetEmailParameters &&
        other.email == email &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode => email.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'SendPasswordResetEmailParameters(email: $email, cancelToken: $cancelToken)';
}

/// Builder for SendPasswordResetEmailParameters
class SendPasswordResetEmailParametersBuilder
    extends ParametersBuilder<SendPasswordResetEmailParameters> {
  String? _email;
  CancelToken? _cancelToken;

  SendPasswordResetEmailParametersBuilder();

  /// Set email address
  SendPasswordResetEmailParametersBuilder withEmail(String email) {
    _email = email;
    return this;
  }

  /// Set cancel token
  @override
  SendPasswordResetEmailParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the parameters object
  @override
  SendPasswordResetEmailParameters build() {
    return SendPasswordResetEmailParameters(
      email: _email!,
      cancelToken: _cancelToken,
    );
  }
}