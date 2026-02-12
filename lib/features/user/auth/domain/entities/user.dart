// lib/features/auth/domain/entities/user.dart
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/user_role.dart';

/// Governorate entity
class Governorate {
  const Governorate({required this.id, required this.name});

  final int id;
  final String name;

  Governorate copyWith({int? id, String? name}) {
    return Governorate(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Governorate && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Governorate(id: $id, name: $name)';
}

/// Represents an authenticated user in the domain layer.
///
/// This entity contains all user-related information that the app
/// needs to function. Sensitive data like tokens are NOT stored here.
///
/// Properties are immutable to ensure data consistency across the app.
class User {
  /// Creates a new [User] instance.
  const User({
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

  /// Creates a user from a map.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      emailVerified: map['emailVerified'] as bool? ?? false,
      phoneVerified: map['phoneVerified'] as bool? ?? false,
      isActive: map['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(map['createdAt'] as String),
      lastLoginAt: map['lastLoginAt'] != null ? DateTime.parse(map['lastLoginAt'] as String) : null,
      role: UserRole.fromString(map['role'] as String) ?? UserRole.user,
      metadata: Map<String, dynamic>.from(map['metadata'] as Map? ?? {}),
      // New fields
      nickname: map['nickname'] as String?,
      governorate: map['governorate'] != null
          ? Governorate(
              id: map['governorate']['id'] as int,
              name: map['governorate']['name'] as String,
            )
          : null,
      birthdate: map['birthdate'] as int?,
      gender: map['gender'] as String?,
      isBanned: map['isBanned'] as bool? ?? false,
      avatar: map['avatar'] as String?,
      referralCode: map['referralCode'] as String?,
      referredBy: map['referredBy'] as String?,
      referralPoints: map['referralPoints'] as int?,
    );
  }

  /// Unique identifier for the user.
  final String id;

  /// User's email address.
  final String email;

  /// User's display name.
  final String? displayName;

  /// URL to user's profile photo.
  final String? photoUrl;

  /// User's phone number in E.164 format.
  final String? phoneNumber;

  /// Whether the user's email has been verified.
  final bool emailVerified;

  /// Whether the user's phone number has been verified.
  final bool phoneVerified;

  /// Whether the user's account is active.
  final bool isActive;

  /// When the user account was created.
  final DateTime createdAt;

  /// When the user last logged in.
  final DateTime? lastLoginAt;

  /// List of roles assigned to the user.
  final UserRole role;

  /// Additional metadata about the user.
  final Map<String, dynamic> metadata;

  // New fields from API
  /// User's nickname
  final String? nickname;

  /// User's governorate
  final Governorate? governorate;

  /// User's birth year
  final int? birthdate;

  /// User's gender (male/female)
  final String? gender;

  /// Whether the user is banned
  final bool isBanned;

  /// User's avatar URL
  final String? avatar;

  /// User's referral code
  final String? referralCode;

  /// User who referred this user
  final String? referredBy;

  /// User's referral points
  final int? referralPoints;

  /// Returns true if the user has admin privileges.
  bool get isAdmin => role == UserRole.company;

  /// Returns true if the user has a verified account.
  bool get isVerified => emailVerified || phoneVerified;

  /// Returns the user's initials for avatar fallback.
  /// Uses display name or email if display name is not set.
  String get initials {
    final name = displayName ?? email.split('@').first;
    if (name.isEmpty) return '?';

    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  /// Creates a copy of this user with the given fields replaced.
  User copyWith({
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
    // New fields
    String? nickname,
    Governorate? governorate,
    int? birthdate,
    String? gender,
    bool? isBanned,
    String? avatar,
    String? referralCode,
    String? referredBy,
    int? referralPoints,
  }) {
    return User(
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
      // New fields
      nickname: nickname ?? this.nickname,
      governorate: governorate ?? this.governorate,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      isBanned: isBanned ?? this.isBanned,
      avatar: avatar ?? this.avatar,
      referralCode: referralCode ?? this.referralCode,
      referredBy: referredBy ?? this.referredBy,
      referralPoints: referralPoints ?? this.referralPoints,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, email: $email, displayName: $displayName)';
  }

  /// Converts the user to a map for serialization.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'role': role.value,
      'metadata': metadata,
      // New fields
      'nickname': nickname,
      'governorate': governorate != null
          ? {'id': governorate!.id, 'name': governorate!.name}
          : null,
      'birthdate': birthdate,
      'gender': gender,
      'isBanned': isBanned,
      'avatar': avatar,
      'referralCode': referralCode,
      'referredBy': referredBy,
      'referralPoints': referralPoints,
    };
  }

  UserModel toModel() {
    return UserModel.fromJson(toMap());
  }
}
