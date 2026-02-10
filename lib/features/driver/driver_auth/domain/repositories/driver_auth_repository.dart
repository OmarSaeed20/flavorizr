import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/domain/entities/driver_credentials.dart';

/// Repository interface for driver authentication operations.
///
/// Based on the FAST App API documentation.
abstract class DriverAuthRepository {
  /// Logs in a driver with phone and password.
  /// Endpoint: POST /driver/auth/login
  Future<ApiResult<DriverCredentials>> login({required String phone, required String password});

  /// Registers a new driver.
  /// Endpoint: POST /driver/auth/register
  Future<ApiResult<DriverCredentials>> register({
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String name,
    required String email,
    required int countryId,
    required int governorateId,
    required int cityId,
    required String birthdate,
    required String gender,
    required String nationalId,
    required String nationalIdImage,
    required String drivingLicenseImage,
    required String vehicleLicenseImage,
    required String vehicleImage,
    required int vehicleTypeId,
    required String vehiclePlateNumber,
  });

  /// Verifies driver phone number with verification code.
  /// Endpoint: POST /driver/auth/user-verify
  Future<ApiResult<DriverCredentials>> verifyPhone({
    required String phone,
    required String code,
    required String firebaseToken,
  });

  /// Requests password reset for driver.
  /// Endpoint: POST /driver/auth/forget-password
  Future<ApiResult<void>> forgetPassword({required String phone});

  /// Resets driver password using verification code.
  /// Endpoint: POST /driver/auth/reset-password
  Future<ApiResult<void>> resetPassword({
    required String code,
    required String phone,
    required String password,
    required String passwordConfirmation,
  });

  /// Logs out the current driver.
  /// Endpoint: POST /driver/auth/logout
  Future<ApiResult<void>> logout();

  /// Refreshes the driver authentication token.
  /// Endpoint: POST /driver/auth/refresh
  Future<ApiResult<DriverCredentials>> refreshToken();
}
