import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Refresh Token API parameters with builder pattern
/// Used for refreshing authentication tokens
class RefreshTokenParameters extends Parameters {
  final String refreshToken;
  @override
  final CancelToken? cancelToken;

  const RefreshTokenParameters({required this.refreshToken, this.cancelToken});

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {'refresh_token': refreshToken};

  /// Create a builder for this parameters type
  RefreshTokenParametersBuilder builder() => RefreshTokenParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RefreshTokenParameters &&
        other.refreshToken == refreshToken &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode => refreshToken.hashCode ^ cancelToken.hashCode;

  @override
  String toString() => 'RefreshTokenParameters(refreshToken: ****, cancelToken: $cancelToken)';
}

/// Builder for RefreshTokenParameters
class RefreshTokenParametersBuilder extends ParametersBuilder<RefreshTokenParameters> {
  String? _refreshToken;
  CancelToken? _cancelToken;

  RefreshTokenParametersBuilder();

  /// Set refresh token
  RefreshTokenParametersBuilder withRefreshToken(String refreshToken) {
    _refreshToken = refreshToken;
    return this;
  }

  /// Set cancel token
  @override
  RefreshTokenParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build RefreshTokenParameters
  @override
  RefreshTokenParameters build() {
    if (_refreshToken == null || _refreshToken!.isEmpty) {
      throw ArgumentError('Refresh token is required');
    }
    return RefreshTokenParameters(refreshToken: _refreshToken!, cancelToken: _cancelToken);
  }
}
