import 'package:fast_golden_taxi/features/user/auth/data/models/api_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_auth_response.freezed.dart';
part 'api_auth_response.g.dart';

/// API Auth Response model
/// Represents authentication response from the API
/// Based on API_DOCUMENTATION.md
@freezed
abstract class ApiAuthResponse with _$ApiAuthResponse {
  const factory ApiAuthResponse({
    required bool success,
    required String message,
    ApiUser? user,
    String? token,
    String? refreshToken,
    @JsonKey(name: 'token_type') String? tokenType,
    @JsonKey(name: 'expires_in') int? expiresIn,
    @JsonKey(name: 'access_token') String? accessToken,
  }) = _ApiAuthResponse;
  const ApiAuthResponse._();

  /// Create ApiAuthResponse from JSON
  factory ApiAuthResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiAuthResponseFromJson(json);
}
