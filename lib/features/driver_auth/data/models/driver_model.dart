import 'package:flavorizr/features/driver_auth/domain/entities/driver.dart';

/// Model for Driver entity.
class DriverModel extends Driver {
  DriverModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
    super.profileImage,
    required super.isVerified,
    required super.isActive,
    required super.createdAt,
    super.lastLoginAt,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profileImage: json['profile_image'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'profile_image': profileImage,
      'is_verified': isVerified,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }

  Driver toEntity() {
    return Driver(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      profileImage: profileImage,
      isVerified: isVerified,
      isActive: isActive,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
    );
  }
}