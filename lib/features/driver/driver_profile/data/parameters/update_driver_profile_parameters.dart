/// Parameters for updating driver profile.
class UpdateDriverProfileParameters {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? profileImage;
  final String? bio;
  final String? address;
  final String? city;
  final String? country;
  final DateTime? dateOfBirth;
  final String? gender;

  UpdateDriverProfileParameters({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.profileImage,
    this.bio,
    this.address,
    this.city,
    this.country,
    this.dateOfBirth,
    this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (profileImage != null) 'profile_image': profileImage,
      if (bio != null) 'bio': bio,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth!.toIso8601String(),
      if (gender != null) 'gender': gender,
    };
  }
}