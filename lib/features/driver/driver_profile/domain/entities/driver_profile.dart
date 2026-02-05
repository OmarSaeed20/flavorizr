/// Driver profile entity.
///
/// Based on the FAST App API documentation for driver profile data structure
class DriverProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? phoneIso2Code;
  final String? image;
  final int countryId;
  final int governorateId;
  final int cityId;
  final String birthdate;
  final String gender;
  final String? nationalId;
  final String? nationalIdImage;
  final String? drivingLicenseImage;
  final String? vehicleLicenseImage;
  final String? vehicleImage;
  final int? vehicleTypeId;
  final String? vehiclePlateNumber;
  final bool isVerified;
  final bool isActive;
  final double rating;
  final int totalTrips;
  final double totalEarnings;
  final DateTime createdAt;
  final DateTime? updatedAt;

  DriverProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.phoneIso2Code,
    this.image,
    required this.countryId,
    required this.governorateId,
    required this.cityId,
    required this.birthdate,
    required this.gender,
    this.nationalId,
    this.nationalIdImage,
    this.drivingLicenseImage,
    this.vehicleLicenseImage,
    this.vehicleImage,
    this.vehicleTypeId,
    this.vehiclePlateNumber,
    required this.isVerified,
    required this.isActive,
    required this.rating,
    required this.totalTrips,
    required this.totalEarnings,
    required this.createdAt,
    this.updatedAt,
  });

  String get fullName => name;
}
