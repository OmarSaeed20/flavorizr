// lib/features/auth/data/models/user_model.dart
import 'package:flavorizr/features/auth/domain/entities/user.dart';

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
    this.roles = const ['user'],
    this.metadata = const {},
  });

  /// Creates a model from JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? json['uid'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String? ?? json['displayName'] as String?,
      photoUrl: json['photo_url'] as String? ?? json['photoUrl'] as String?,
      phoneNumber: json['phone_number'] as String? ?? json['phoneNumber'] as String?,
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
      roles: List<String>.from(json['roles'] as List? ?? ['user']),
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
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
    roles: entity.roles,
    metadata: entity.metadata,
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
  final List<String> roles;
  final Map<String, dynamic> metadata;

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
      'roles': roles,
      'metadata': metadata,
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
    roles: roles,
    metadata: metadata,
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
    List<String>? roles,
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
      roles: roles ?? this.roles,
      metadata: metadata ?? this.metadata,
    );
  }
}
