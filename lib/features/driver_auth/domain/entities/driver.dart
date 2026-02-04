/// Driver entity representing a driver in the system.
class Driver {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? profileImage;
  final bool isVerified;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  Driver({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.isVerified,
    required this.isActive,
    required this.createdAt,
    this.lastLoginAt,
  });

  String get fullName => '$firstName $lastName';
}