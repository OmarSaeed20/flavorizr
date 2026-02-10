import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Sign In With Magic Link API parameters with builder pattern
/// Used for passwordless authentication via magic link
class SignInWithMagicLinkParameters extends Parameters {
  final String token;
  @override
  final CancelToken? cancelToken;

  const SignInWithMagicLinkParameters({required this.token, this.cancelToken});

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {'token': token};

  /// Create a builder for this parameters type
  SignInWithMagicLinkParametersBuilder builder() =>
      SignInWithMagicLinkParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SignInWithMagicLinkParameters &&
        other.token == token &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode => token.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'SignInWithMagicLinkParameters(token: ****, cancelToken: $cancelToken)';
}

/// Builder for SignInWithMagicLinkParameters
class SignInWithMagicLinkParametersBuilder
    extends ParametersBuilder<SignInWithMagicLinkParameters> {
  String? _token;
  CancelToken? _cancelToken;

  SignInWithMagicLinkParametersBuilder();

  /// Set magic link token
  SignInWithMagicLinkParametersBuilder withToken(String token) {
    _token = token;
    return this;
  }

  /// Set cancel token
  @override
  SignInWithMagicLinkParametersBuilder withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the parameters object
  @override
  SignInWithMagicLinkParameters build() {
    return SignInWithMagicLinkParameters(
      token: _token!,
      cancelToken: _cancelToken,
    );
  }
}
