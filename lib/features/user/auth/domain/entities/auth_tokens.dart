// lib/features/auth/domain/entities/auth_tokens.dart
/// Holds authentication tokens for API access.
///
/// Access tokens are short-lived and used for API requests.
/// Refresh tokens are long-lived and used to obtain new access tokens.
///
/// **Security Note:** These tokens should be stored securely
/// using flutter_secure_storage, not in plain SharedPreferences.
class AuthTokens {
  /// Creates a new [AuthTokens] instance.
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresAt,
    this.refreshTokenExpiresAt,
    this.tokenType = 'Bearer',
  });

  /// Creates tokens from a map.
  factory AuthTokens.fromMap(Map<String, dynamic> map) {
    return AuthTokens(
      accessToken: map['accessToken'] as String,
      refreshToken: map['refreshToken'] as String,
      accessTokenExpiresAt: DateTime.parse(
        map['accessTokenExpiresAt'] as String,
      ),
      refreshTokenExpiresAt: map['refreshTokenExpiresAt'] != null
          ? DateTime.parse(map['refreshTokenExpiresAt'] as String)
          : null,
      tokenType: map['tokenType'] as String? ?? 'Bearer',
    );
  }

  /// Creates tokens from a JSON API response.
  factory AuthTokens.fromApiResponse(Map<String, dynamic> json) {
    final expiresIn = json['expires_in'] as int? ?? 3600;
    final refreshExpiresIn = json['refresh_expires_in'] as int?;

    return AuthTokens(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      accessTokenExpiresAt: DateTime.now().add(Duration(seconds: expiresIn)),
      refreshTokenExpiresAt: refreshExpiresIn != null
          ? DateTime.now().add(Duration(seconds: refreshExpiresIn))
          : null,
      tokenType: json['token_type'] as String? ?? 'Bearer',
    );
  }

  /// JWT access token for API authentication.
  final String accessToken;

  /// Refresh token for obtaining new access tokens.
  final String refreshToken;

  /// When the access token expires.
  final DateTime accessTokenExpiresAt;

  /// When the refresh token expires (optional).
  final DateTime? refreshTokenExpiresAt;

  /// Token type (usually "Bearer").
  final String tokenType;

  /// Returns true if the access token has expired.
  bool get isAccessTokenExpired => DateTime.now().isAfter(accessTokenExpiresAt);

  /// Returns true if the refresh token has expired.
  bool get isRefreshTokenExpired =>
      refreshTokenExpiresAt != null &&
      DateTime.now().isAfter(refreshTokenExpiresAt!);

  /// Returns true if both tokens are expired (needs re-login).
  bool get isFullyExpired => isAccessTokenExpired && isRefreshTokenExpired;

  /// Returns true if the access token will expire soon (within 5 minutes).
  /// Used to proactively refresh tokens.
  bool get shouldRefresh {
    final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
    return fiveMinutesFromNow.isAfter(accessTokenExpiresAt);
  }

  /// Returns the authorization header value.
  String get authorizationHeader => '$tokenType $accessToken';

  /// Creates a copy of this tokens with the given fields replaced.
  AuthTokens copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? accessTokenExpiresAt,
    DateTime? refreshTokenExpiresAt,
    String? tokenType,
  }) {
    return AuthTokens(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      accessTokenExpiresAt: accessTokenExpiresAt ?? this.accessTokenExpiresAt,
      refreshTokenExpiresAt:
          refreshTokenExpiresAt ?? this.refreshTokenExpiresAt,
      tokenType: tokenType ?? this.tokenType,
    );
  }

  /// Converts the tokens to a map for serialization.
  Map<String, dynamic> toMap() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'accessTokenExpiresAt': accessTokenExpiresAt.toIso8601String(),
      'refreshTokenExpiresAt': refreshTokenExpiresAt?.toIso8601String(),
      'tokenType': tokenType,
    };
  }

  @override
  String toString() {
    return 'AuthTokens(tokenType: $tokenType, expiresAt: $accessTokenExpiresAt)';
  }
}
