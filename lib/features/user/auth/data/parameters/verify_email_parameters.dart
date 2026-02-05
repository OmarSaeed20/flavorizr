import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';

/// Verify Email API parameters with builder pattern
/// Used for verifying email with token
class VerifyEmailParameters extends Parameters {
  final String token;
  @override
  final CancelToken? cancelToken;

  const VerifyEmailParameters({required this.token, this.cancelToken});

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {'token': token};

  /// Create a builder for this parameters type
  VerifyEmailParametersBuilder builder() => VerifyEmailParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VerifyEmailParameters &&
        other.token == token &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode => token.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'VerifyEmailParameters(token: ****, cancelToken: $cancelToken)';
}

/// Builder for VerifyEmailParameters
class VerifyEmailParametersBuilder
    extends ParametersBuilder<VerifyEmailParameters> {
  String? _token;
  CancelToken? _cancelToken;

  VerifyEmailParametersBuilder();

  /// Set verification token
  VerifyEmailParametersBuilder withToken(String token) {
    _token = token;
    return this;
  }

  /// Set cancel token
  @override
  VerifyEmailParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the parameters object
  @override
  VerifyEmailParameters build() {
    return VerifyEmailParameters(token: _token!, cancelToken: _cancelToken);
  }
}
