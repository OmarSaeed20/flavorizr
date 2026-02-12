// lib/features/auth/domain/usecases/register_usecase.dart
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart' show ApiResult;
import 'package:fast_golden_taxi/features/user/auth/data/parameters/register_parameters.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_result.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/repositories/auth_repository.dart';
import 'package:fast_golden_taxi/shared/domain/usecases/usecase.dart';

/// Use case for user registration.
///
/// This use case:
/// 1. Validates phone number format
/// 2. Validates password strength
/// 3. Validates password confirmation
/// 4. Validates birthdate format (YYYY)
/// 5. Calls repository to create account
///
/// Password requirements:
/// - Minimum 8 characters
/// - At least one uppercase letter
/// - At least one lowercase letter
/// - At least one number
///
/// Birthdate format:
/// - Year only (YYYY), e.g., "1999"
/// - Must be between 1900 and current year
class RegisterUseCase implements UseCase<AuthResult, RegisterParameters> {
  RegisterUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseResult<AuthResult> call(RegisterParameters params) async {
    final errors = <String, List<String>>{};

    // Validate phone number format
    if (!_isValidPhone(params.phone)) {
      errors['phone'] = ['Please enter a valid phone number'];
    }

    // Validate phone ISO2 code
    if (params.phoneIso2Code.isEmpty) {
      errors['phoneIso2Code'] = ['Phone ISO2 code is required'];
    }

    // Validate password strength
    final passwordErrors = _validatePassword(params.password);
    if (passwordErrors.isNotEmpty) {
      errors['password'] = passwordErrors;
    }

    // Validate password confirmation
    if (params.password != params.passwordConfirmation) {
      errors['confirmPassword'] = ['Passwords do not match'];
    }

    // Validate name
    if (params.name.trim().isEmpty) {
      errors['name'] = ['Name is required'];
    }

    // Validate country ID
    if (params.countryId <= 0) {
      errors['countryId'] = ['Country ID must be greater than 0'];
    }

    // Validate governorate ID
    if (params.governorateId <= 0) {
      errors['governorateId'] = ['Governorate ID must be greater than 0'];
    }

    // Validate birthdate format (year only: YYYY)
    if (!_isValidBirthdate(params.birthdate)) {
      errors['birthdate'] = ['Birthdate must be a valid year (YYYY)'];
    }

    // Validate gender
    if (params.gender.toLowerCase() != 'male' && params.gender.toLowerCase() != 'female') {
      errors['gender'] = ['Gender must be either "male" or "female"'];
    }

    // Return validation failure if there are errors
    if (errors.isNotEmpty) {
      return ApiResult.exception(
        ValidationException(message: 'Please fix the errors below', errors: errors),
      );
    }

    // Attempt registration
    final registerParams = RegisterParameters(
      companyType: params.companyType,
      name: params.name.trim(),
      nickname: params.nickname,
      phone: params.phone.trim(),
      phoneIso2Code: params.phoneIso2Code.trim().toUpperCase(),
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
      countryId: params.countryId,
      governorateId: params.governorateId,
      birthdate: params.birthdate,
      gender: params.gender.toLowerCase(),
      deviceType: params.deviceType,
      deviceToken: params.deviceToken,
      deviceId: params.deviceId,
    );
    final result = await _repository.signUp(registerParams);

    return result;
  }

  /// Validates phone number format using a simple regex.
  bool _isValidPhone(String phone) {
    // Accept phone numbers with 8-15 digits, optionally with + prefix
    final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
    return phoneRegex.hasMatch(phone.trim());
  }

  /// Validates birthdate format (year only: YYYY).
  bool _isValidBirthdate(String birthdate) {
    final yearRegex = RegExp(r'^\d{4}$');
    if (!yearRegex.hasMatch(birthdate.trim())) {
      return false;
    }
    try {
      final year = int.parse(birthdate.trim());
      final currentYear = DateTime.now().year;
      if (year < 1900 || year > currentYear) {
        return false;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  List<String> _validatePassword(String password) {
    final errors = <String>[];

    if (password.length < 8) {
      errors.add('Password must be at least 8 characters');
    }
    if (!password.contains(RegExp('[A-Z]'))) {
      errors.add('Password must contain at least one uppercase letter');
    }
    if (!password.contains(RegExp('[a-z]'))) {
      errors.add('Password must contain at least one lowercase letter');
    }
    if (!password.contains(RegExp('[0-9]'))) {
      errors.add('Password must contain at least one number');
    }

    return errors;
  }
}
