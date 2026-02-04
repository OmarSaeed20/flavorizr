/// Driver profile entity.
class DriverProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? profileImage;
  final String? bio;
  final String? address;
  final String? city;
  final String? country;
  final DateTime? dateOfBirth;
  final String? gender;
  final bool isVerified;
  final double rating;
  final int totalTrips;
  final DateTime createdAt;
  final DateTime? updatedAt;

  DriverProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.profileImage,
    this.bio,
    this.address,
    this.city,
    this.country,
    this.dateOfBirth,
    this.gender,
    required this.isVerified,
    required this.rating,
    required this.totalTrips,
    required this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName';
}