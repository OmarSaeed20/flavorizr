import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';

/// Send Magic Link API parameters with builder pattern
/// Used for sending magic link to email
class SendMagicLinkParameters extends Parameters {
  final String email;
  @override
  final CancelToken? cancelToken;

  const SendMagicLinkParameters({
    required this.email,
    this.cancelToken,
  });

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {'email': email};

  /// Create a builder for this parameters type
  SendMagicLinkParametersBuilder builder() => SendMagicLinkParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SendMagicLinkParameters &&
        other.email == email &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode => email.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'SendMagicLinkParameters(email: $email, cancelToken: $cancelToken)';
}

/// Builder for SendMagicLinkParameters
class SendMagicLinkParametersBuilder extends ParametersBuilder<SendMagicLinkParameters> {
  String? _email;
  CancelToken? _cancelToken;

  SendMagicLinkParametersBuilder();

  /// Set email address
  SendMagicLinkParametersBuilder withEmail(String email) {
    _email = email;
    return this;
  }

  /// Set cancel token
  @override
  SendMagicLinkParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the parameters object
  @override
  SendMagicLinkParameters build() {
    return SendMagicLinkParameters(
      email: _email!,
      cancelToken: _cancelToken,
    );
  }
}