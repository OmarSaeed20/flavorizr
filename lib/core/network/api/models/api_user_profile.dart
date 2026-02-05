import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_user_profile.freezed.dart';
part 'api_user_profile.g.dart';

/// API User Profile model representing user profile data from the backend
@freezed
abstract class ApiUserProfile with _$ApiUserProfile {
  const factory ApiUserProfile({
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
    double? rating,
    int? totalTrips,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ApiUserProfile;

  factory ApiUserProfile.fromJson(Map<String, dynamic> json) =>
      _$ApiUserProfileFromJson(json);
}

/// API Driver Profile model representing driver profile data from the backend
@freezed
abstract class ApiDriverProfile with _$ApiDriverProfile {
  const factory ApiDriverProfile({
    required int id,
    required String name,
    String? nickname,
    required String phone,
    String? email,
    String? avatar,
    String? country,
    String? governorate,
    String? birthdate,
    String? gender,
    bool? isVerified,
    bool? isActive,
    String? vehicleType,
    String? vehicleModel,
    String? vehiclePlateNumber,
    String? licenseNumber,
    double? rating,
    int? totalTrips,
    int? totalReviews,
    bool? isAvailable,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ApiDriverProfile;

  factory ApiDriverProfile.fromJson(Map<String, dynamic> json) =>
      _$ApiDriverProfileFromJson(json);
}
