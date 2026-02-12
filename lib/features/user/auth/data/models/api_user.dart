import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_user.freezed.dart';
part 'api_user.g.dart';

/// Governorate model
@freezed
abstract class ApiGovernorate with _$ApiGovernorate {
  const factory ApiGovernorate({required int id, required String name}) = _ApiGovernorate;

  factory ApiGovernorate.fromJson(Map<String, dynamic> json) => _$ApiGovernorateFromJson(json);
}

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
    ApiGovernorate? governorate,
    int? birthdate,
    String? gender,
    @JsonKey(name: 'phone_verified') bool? phoneVerified,
    @JsonKey(name: 'is_banned') bool? isBanned,
    String? avatar,
    String? referralCode,
    @JsonKey(name: 'referred_by') String? referredBy,
    @JsonKey(name: 'referral_points') int? referralPoints,
    String? email,
    String? country,
    String? deviceType,
    String? deviceToken,
    String? deviceId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ApiUser;
  const ApiUser._();

  /// Create ApiUser from JSON
  factory ApiUser.fromJson(Map<String, dynamic> json) => _$ApiUserFromJson(json);
}
