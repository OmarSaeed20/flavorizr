// lib/features/company/company_auth/domain/usecases/company_reset_password_usecase.dart
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_reset_password_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/repositories/company_auth_repository.dart';

/// Company Reset Password Use Case
///
/// Handles company password reset with verification code.
/// Validates input parameters before calling repository.
class CompanyResetPasswordUseCase {
  final CompanyAuthRepository _repository;

  CompanyResetPasswordUseCase(this._repository);

  Future<ApiResult<void>> execute(CompanyResetPasswordParameters parameters) async {
    // Validate phone number
    if (parameters.phone.isEmpty) {
      return ApiResult.failure(const ValidationException(message: 'Phone number is required'));
    }

    // Validate phone ISO code
    if (parameters.phoneIsoCode.isEmpty) {
      return ApiResult.failure(const ValidationException(message: 'Phone ISO code is required'));
    }

    // Validate confirmation code
    if (parameters.confirmationCode.isEmpty) {
      return ApiResult.failure(const ValidationException(message: 'Confirmation code is required'));
    }

    // Validate confirmation code length (typically 4-6 digits)
    if (parameters.confirmationCode.length < 4 || parameters.confirmationCode.length > 6) {
      return ApiResult.failure(const ValidationException(message: 'Invalid confirmation code'));
    }

    // Validate password
    if (parameters.password.isEmpty) {
      return ApiResult.failure(const ValidationException(message: 'Password is required'));
    }

    // Validate password length
    if (parameters.password.length < 6) {
      return ApiResult.failure(
        const ValidationException(message: 'Password must be at least 6 characters'),
      );
    }

    // Validate password confirmation
    if (parameters.passwordConfirmation.isEmpty) {
      return ApiResult.failure(
        const ValidationException(message: 'Password confirmation is required'),
      );
    }

    // Validate passwords match
    if (parameters.password != parameters.passwordConfirmation) {
      return ApiResult.failure(const ValidationException(message: 'Passwords do not match'));
    }

    // Call repository
    return _repository.resetPassword(parameters);
  }
}
