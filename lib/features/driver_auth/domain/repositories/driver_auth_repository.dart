import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver_auth/domain/entities/driver.dart';
import 'package:flavorizr/features/driver_auth/domain/entities/driver_credentials.dart';

/// Repository interface for driver authentication operations.
abstract class DriverAuthRepository {
  /// Logs in a driver with phone and password.
  Future<ApiResult<DriverCredentials>> login({
    required String phone,
    required String password,
  });

  /// Logs out the current driver.
  Future<ApiResult<void>> logout();

  /// Registers a new driver.
  Future<ApiResult<DriverCredentials>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    String? profileImage,
  });

  /// Verifies driver phone number with OTP.
  Future<ApiResult<DriverCredentials>> verifyPhone({
    required String phone,
    required String otp,
  });

  /// Resets driver password.
  Future<ApiResult<void>> resetPassword({
    required String phone,
    required String newPassword,
    required String otp,
  });

  /// Refreshes the access token.
  Future<ApiResult<DriverCredentials>> refreshToken({
    required String refreshToken,
  });
}