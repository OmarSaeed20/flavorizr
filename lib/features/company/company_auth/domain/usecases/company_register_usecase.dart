// lib/features/company/company_auth/domain/usecases/company_register_usecase.dart
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_register_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/repositories/company_auth_repository.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_tokens.dart';

/// Company Register Use Case
///
/// Handles new company registration.
/// Validates input parameters before calling repository.
class CompanyRegisterUseCase {
  final CompanyAuthRepository _repository;

  CompanyRegisterUseCase(this._repository);

  Future<ApiResult<AuthTokens>> execute(
    CompanyRegisterParameters parameters,
  ) async {
    // Validate company type
    if (parameters.companyType.isEmpty) {
      return ApiResult.failure(
        const ValidationException(message: 'Company type is required'),
      );
    }

    // Validate company type is "company"
    if (parameters.companyType != 'company') {
      return ApiResult.failure(
        const ValidationException(message: 'Invalid company type'),
      );
    }

    // Validate name
    if (parameters.name.isEmpty) {
      return ApiResult.failure(
        const ValidationException(message: 'Company name is required'),
      );
    }

    // Validate phone number
    if (parameters.phone.isEmpty) {
      return ApiResult.failure(
        const ValidationException(message: 'Phone number is required'),
      );
    }

    // Validate phone ISO2 code
    if (parameters.phoneIso2Code.isEmpty) {
      return ApiResult.failure(
        const ValidationException(message: 'Phone ISO2 code is required'),
      );
    }

    // Validate password
    if (parameters.password.isEmpty) {
      return ApiResult.failure(
        const ValidationException(message: 'Password is required'),
      );
    }

    // Validate password length
    if (parameters.password.length < 6) {
      return ApiResult.failure(
        const ValidationException(
          message: 'Password must be at least 6 characters',
        ),
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
      return ApiResult.failure(
        const ValidationException(message: 'Passwords do not match'),
      );
    }

    // Validate country ID
    if (parameters.countryId <= 0) {
      return ApiResult.failure(
        const ValidationException(message: 'Invalid country ID'),
      );
    }

    // Validate governorate ID
    if (parameters.governorateId <= 0) {
      return ApiResult.failure(
        const ValidationException(message: 'Invalid governorate ID'),
      );
    }

    // Validate birthdate
    if (parameters.birthdate.isEmpty) {
      return ApiResult.failure(
        const ValidationException(message: 'Birthdate is required'),
      );
    }

    // Validate birthdate format (YYYY-MM-DD)
    final birthdateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!birthdateRegex.hasMatch(parameters.birthdate)) {
      return ApiResult.failure(
        const ValidationException(
          message: 'Invalid birthdate format. Use YYYY-MM-DD',
        ),
      );
    }

    // Validate gender
    if (parameters.gender.isEmpty) {
      return ApiResult.failure(
        const ValidationException(message: 'Gender is required'),
      );
    }

    // Validate gender value
    if (parameters.gender != 'male' && parameters.gender != 'female') {
      return ApiResult.failure(
        const ValidationException(message: 'Invalid gender value'),
      );
    }

    // Call repository
    return _repository.register(parameters);
  }
}
