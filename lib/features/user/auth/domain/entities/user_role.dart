import 'package:flutter/material.dart';

enum UserRole {
  user,
  driver,
  company;

  /// Creates a [UserRole] from a string value.
  ///
  /// Returns null if the string does not match any role.
  static UserRole? fromString(String role) => switch (role.toLowerCase()) {
    'user' => UserRole.user,
    'driver' => UserRole.driver,
    'company' => UserRole.company,
    _ => null,
  };

  String get label => switch (this) {
    UserRole.user => 'User',
    UserRole.driver => 'Driver',
    UserRole.company => 'Company',
  };

  String get assetPath => switch (this) {
    UserRole.user => 'assets/icons/role_user.png',
    UserRole.driver => 'assets/icons/role_driver.png',
    UserRole.company => 'assets/icons/role_company.png',
  };

  IconData get fallbackIcon => switch (this) {
    UserRole.user => Icons.person_outline,
    UserRole.driver => Icons.drive_eta_outlined,
    UserRole.company => Icons.business_outlined,
  };

  String get value => label.toLowerCase();
}
