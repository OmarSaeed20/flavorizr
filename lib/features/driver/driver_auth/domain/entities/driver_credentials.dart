import 'package:fast_golden_taxi/features/driver/driver_auth/domain/entities/driver.dart';

/// Driver credentials entity for authentication.
class DriverCredentials {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final Driver driver;

  DriverCredentials({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.driver,
  });

  bool get isExpired {
    return DateTime.now()
        .add(Duration(seconds: expiresIn))
        .isBefore(DateTime.now());
  }
}
