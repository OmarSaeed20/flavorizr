import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_user.freezed.dart';
part 'api_user.g.dart';

/// API User model
/// Represents user data from the API
/// Based on API_DOCUMENTATION.md
@freezed
abstract class ApiUser with _$ApiUser {
  const factory ApiUser({
    required int id,
    required String name,
    String? nickname,
    required String phone,
    String? email,
    String? country,
    String? governorate,
    String? birthdate,
    String? gender,
    String? avatar,
    String? deviceType,
    String? deviceToken,
    String? deviceId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ApiUser;
  const ApiUser._();

  /// Create ApiUser from JSON
  factory ApiUser.fromJson(Map<String, dynamic> json) =>
      _$ApiUserFromJson(json);
}
