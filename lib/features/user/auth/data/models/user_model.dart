// lib/features/auth/data/models/user_model.dart
import 'package:fast_golden_taxi/features/user/auth/domain/entities/user.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/user_role.dart';

/// Data model for User, used for JSON serialization.
///
/// This model handles the conversion between API JSON
/// and the domain User entity.
class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.createdAt,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.emailVerified = false,
    this.phoneVerified = false,
    this.isActive = true,
    this.lastLoginAt,
    this.role = UserRole.user,
    this.metadata = const {},
    // New fields from API
    this.nickname,
    this.governorate,
    this.birthdate,
    this.gender,
    this.isBanned = false,
    this.avatar,
    this.referralCode,
    this.referredBy,
    this.referralPoints,
  });

  /// Creates a model from JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? json['uid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      displayName:
          json['display_name'] as String? ??
          json['displayName'] as String? ??
          json['name'] as String?,
      photoUrl:
          json['photo_url'] as String? ?? json['photoUrl'] as String? ?? json['avatar'] as String?,
      phoneNumber:
          json['phone_number'] as String? ??
          json['phoneNumber'] as String? ??
          json['phone'] as String?,
      emailVerified: json['email_verified'] as bool? ?? json['emailVerified'] as bool? ?? false,
      phoneVerified: json['phone_verified'] as bool? ?? json['phoneVerified'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      role: UserRole.fromString(json['role'] as String) ?? UserRole.user,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
      // New fields
      nickname: json['nickname'] as String?,
      governorate: json['governorate'] != null
          ? Governorate(
              id: json['governorate']['id'] as int,
              name: json['governorate']['name'] as String,
            )
          : null,
      birthdate: json['birthdate'] as int?,
      gender: json['gender'] as String?,
      isBanned: json['is_banned'] as bool? ?? json['isBanned'] as bool? ?? false,
      avatar: json['avatar'] as String?,
      referralCode: json['referral_code'] as String? ?? json['referralCode'] as String?,
      referredBy: json['referred_by'] as String? ?? json['referredBy'] as String?,
      referralPoints: json['referral_points'] as int? ?? json['referralPoints'] as int?,
    );
  }

  /// Creates a model from a domain entity.
  factory UserModel.fromEntity(User entity) => UserModel(
    id: entity.id,
    email: entity.email,
    displayName: entity.displayName,
    photoUrl: entity.photoUrl,
    phoneNumber: entity.phoneNumber,
    emailVerified: entity.emailVerified,
    phoneVerified: entity.phoneVerified,
    isActive: entity.isActive,
    createdAt: entity.createdAt,
    lastLoginAt: entity.lastLoginAt,
    role: entity.role,
    metadata: entity.metadata,
    // New fields
    nickname: entity.nickname,
    governorate: entity.governorate,
    birthdate: entity.birthdate,
    gender: entity.gender,
    isBanned: entity.isBanned,
    avatar: entity.avatar,
    referralCode: entity.referralCode,
    referredBy: entity.referredBy,
    referralPoints: entity.referralPoints,
  );

  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final bool emailVerified;
  final bool phoneVerified;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final UserRole role;
  final Map<String, dynamic> metadata;

  // New fields from API
  final String? nickname;
  final Governorate? governorate;
  final int? birthdate;
  final String? gender;
  final bool isBanned;
  final String? avatar;
  final String? referralCode;
  final String? referredBy;
  final int? referralPoints;

  // Additional properties for compatibility with API responses
  String? get name => displayName;
  String? get address => metadata['address'] as String?;
  String? get bio => metadata['bio'] as String?;
  String? get image => photoUrl;

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'phone_number': phoneNumber,
      'email_verified': emailVerified,
      'phone_verified': phoneVerified,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'role': role.value,
      'metadata': metadata,
      // New fields
      'nickname': nickname,
      'governorate': governorate != null
          ? {'id': governorate!.id, 'name': governorate!.name}
          : null,
      'birthdate': birthdate,
      'gender': gender,
      'is_banned': isBanned,
      'avatar': avatar,
      'referral_code': referralCode,
      'referred_by': referredBy,
      'referral_points': referralPoints,
    };
  }

  /// Converts this model to a domain entity.
  User toEntity() => User(
    id: id,
    email: email,
    displayName: displayName,
    photoUrl: photoUrl,
    phoneNumber: phoneNumber,
    emailVerified: emailVerified,
    phoneVerified: phoneVerified,
    isActive: isActive,
    createdAt: createdAt,
    lastLoginAt: lastLoginAt,
    role: role,
    metadata: metadata,
    // New fields
    nickname: nickname,
    governorate: governorate,
    birthdate: birthdate,
    gender: gender,
    isBanned: isBanned,
    avatar: avatar,
    referralCode: referralCode,
    referredBy: referredBy,
    referralPoints: referralPoints,
  );

  /// Creates a copy with modified fields.
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    bool? emailVerified,
    bool? phoneVerified,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    UserRole? role,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      role: role ?? this.role,
      metadata: metadata ?? this.metadata,
    );
  }
}
