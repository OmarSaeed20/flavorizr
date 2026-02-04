import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_user.freezed.dart';
part 'api_user.g.dart';

/// API User model representing user data from the backend
@freezed
abstract class ApiUser with _$ApiUser {
  const factory ApiUser({
    required int id,
    required String name,
    String? nickname,
    required String phone,
    String? email,
    String? avatar,
    required String companyType,
    String? country,
    String? governorate,
    String? birthdate,
    String? gender,
    bool? isVerified,
    bool? isActive,
    String? firebaseToken,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ApiUser;

  factory ApiUser.fromJson(Map<String, dynamic> json) =>
      _$ApiUserFromJson(json);
}

/// API Auth Response model representing authentication response
@freezed
abstract class ApiAuthResponse with _$ApiAuthResponse {
  const factory ApiAuthResponse({
    required ApiUser user,
    required String token,
    String? refreshToken,
    String? tokenType,
    int? expiresIn,
  }) = _ApiAuthResponse;

  factory ApiAuthResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiAuthResponseFromJson(json);
}
