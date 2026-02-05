import 'package:flavorizr/features/driver/driver_profile/domain/entities/driver_profile.dart';

/// Model for DriverProfile entity.
class DriverProfileModel extends DriverProfile {
  DriverProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
    super.profileImage,
    super.bio,
    super.address,
    super.city,
    super.country,
    super.dateOfBirth,
    super.gender,
    required super.isVerified,
    required super.rating,
    required super.totalTrips,
    required super.createdAt,
    super.updatedAt,
  });

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) {
    return DriverProfileModel(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profileImage: json['profile_image'] as String?,
      bio: json['bio'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      gender: json['gender'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalTrips: json['total_trips'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
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
      'bio': bio,
      'address': address,
      'city': city,
      'country': country,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'is_verified': isVerified,
      'rating': rating,
      'total_trips': totalTrips,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  DriverProfile toEntity() {
    return DriverProfile(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      profileImage: profileImage,
      bio: bio,
      address: address,
      city: city,
      country: country,
      dateOfBirth: dateOfBirth,
      gender: gender,
      isVerified: isVerified,
      rating: rating,
      totalTrips: totalTrips,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}