/// Parameters for driver registration.
class DriverRegisterParameters {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String? profileImage;

  DriverRegisterParameters({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    this.profileImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'password': password,
      if (profileImage != null) 'profile_image': profileImage,
    };
  }
}