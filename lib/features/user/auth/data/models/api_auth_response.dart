import 'package:fast_golden_taxi/features/user/auth/data/models/api_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_auth_response.freezed.dart';
part 'api_auth_response.g.dart';

/// Token data model
@freezed
abstract class ApiTokenData with _$ApiTokenData {
  const factory ApiTokenData({required String token, required int expiration}) = _ApiTokenData;

  factory ApiTokenData.fromJson(Map<String, dynamic> json) => _$ApiTokenDataFromJson(json);
}

/// Token wrapper model
@freezed
abstract class ApiToken with _$ApiToken {
  const factory ApiToken({required ApiTokenData access, required ApiTokenData refresh}) = _ApiToken;

  factory ApiToken.fromJson(Map<String, dynamic> json) => _$ApiTokenFromJson(json);
}

/// Auth data model
@freezed
abstract class ApiAuthData with _$ApiAuthData {
  const factory ApiAuthData({required ApiUser user, required ApiToken token}) = _ApiAuthData;

  factory ApiAuthData.fromJson(Map<String, dynamic> json) => _$ApiAuthDataFromJson(json);
}

/// API Auth Response model
/// Represents authentication response from the API
/// Based on API_DOCUMENTATION.md
@freezed
abstract class ApiAuthResponse with _$ApiAuthResponse {
  const factory ApiAuthResponse({
    required String status,
    required String message,
    required ApiAuthData data,
  }) = _ApiAuthResponse;
  const ApiAuthResponse._();

  /// Create ApiAuthResponse from JSON
  factory ApiAuthResponse.fromJson(Map<String, dynamic> json) => _$ApiAuthResponseFromJson(json);
}
