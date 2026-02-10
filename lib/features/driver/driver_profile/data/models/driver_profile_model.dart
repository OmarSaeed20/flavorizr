import 'package:fast_golden_taxi/features/driver/driver_profile/domain/entities/driver_profile.dart';

/// Model for DriverProfile entity.
///
/// Based on the FAST App API documentation for driver profile data structure
class DriverProfileModel extends DriverProfile {
  DriverProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.phoneIso2Code,
    super.image,
    required super.countryId,
    required super.governorateId,
    required super.cityId,
    required super.birthdate,
    required super.gender,
    super.nationalId,
    super.nationalIdImage,
    super.drivingLicenseImage,
    super.vehicleLicenseImage,
    super.vehicleImage,
    super.vehicleTypeId,
    super.vehiclePlateNumber,
    required super.isVerified,
    required super.isActive,
    required super.rating,
    required super.totalTrips,
    required super.totalEarnings,
    required super.createdAt,
    super.updatedAt,
  });

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) {
    return DriverProfileModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      phoneIso2Code: json['phone_iso2_code'] as String?,
      image: json['image'] as String?,
      countryId: json['country_id'] as int? ?? 0,
      governorateId: json['governorate_id'] as int? ?? 0,
      cityId: json['city_id'] as int? ?? 0,
      birthdate: json['birthdate'] as String? ?? '',
      gender: json['gender'] as String? ?? 'male',
      nationalId: json['national_id'] as String?,
      nationalIdImage: json['national_id_image'] as String?,
      drivingLicenseImage: json['driving_license_image'] as String?,
      vehicleLicenseImage: json['vehicle_license_image'] as String?,
      vehicleImage: json['vehicle_image'] as String?,
      vehicleTypeId: json['vehicle_type_id'] as int?,
      vehiclePlateNumber: json['vehicle_plate_number'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalTrips: json['total_trips'] as int? ?? 0,
      totalEarnings: (json['total_earnings'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      if (phoneIso2Code != null) 'phone_iso2_code': phoneIso2Code,
      if (image != null) 'image': image,
      'country_id': countryId,
      'governorate_id': governorateId,
      'city_id': cityId,
      'birthdate': birthdate,
      'gender': gender,
      if (nationalId != null) 'national_id': nationalId,
      if (nationalIdImage != null) 'national_id_image': nationalIdImage,
      if (drivingLicenseImage != null)
        'driving_license_image': drivingLicenseImage,
      if (vehicleLicenseImage != null)
        'vehicle_license_image': vehicleLicenseImage,
      if (vehicleImage != null) 'vehicle_image': vehicleImage,
      if (vehicleTypeId != null) 'vehicle_type_id': vehicleTypeId,
      if (vehiclePlateNumber != null)
        'vehicle_plate_number': vehiclePlateNumber,
      'is_verified': isVerified,
      'is_active': isActive,
      'rating': rating,
      'total_trips': totalTrips,
      'total_earnings': totalEarnings,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  DriverProfile toEntity() {
    return DriverProfile(
      id: id,
      name: name,
      email: email,
      phone: phone,
      phoneIso2Code: phoneIso2Code,
      image: image,
      countryId: countryId,
      governorateId: governorateId,
      cityId: cityId,
      birthdate: birthdate,
      gender: gender,
      nationalId: nationalId,
      nationalIdImage: nationalIdImage,
      drivingLicenseImage: drivingLicenseImage,
      vehicleLicenseImage: vehicleLicenseImage,
      vehicleImage: vehicleImage,
      vehicleTypeId: vehicleTypeId,
      vehiclePlateNumber: vehiclePlateNumber,
      isVerified: isVerified,
      isActive: isActive,
      rating: rating,
      totalTrips: totalTrips,
      totalEarnings: totalEarnings,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
