// lib/features/auth/domain/usecases/register_usecase.dart
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart'
    show ApiResult;
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
/// 4. Calls repository to create account
///
/// Password requirements:
/// - Minimum 8 characters
/// - At least one uppercase letter
/// - At least one lowercase letter
/// - At least one number
class RegisterUseCase implements UseCase<AuthResult, RegisterParams> {
  RegisterUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseResult<AuthResult> call(RegisterParams params) async {
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
    if (params.password != params.confirmPassword) {
      errors['confirmPassword'] = ['Passwords do not match'];
    }

    // Validate display name if provided
    if (params.displayName != null && params.displayName!.trim().isEmpty) {
      errors['displayName'] = ['Display name cannot be empty'];
    }

    // Validate country ID
    if (params.countryId <= 0) {
      errors['countryId'] = ['Country ID must be greater than 0'];
    }

    // Validate governorate ID
    if (params.governorateId <= 0) {
      errors['governorateId'] = ['Governorate ID must be greater than 0'];
    }

    // Validate birthdate format
    if (!_isValidBirthdate(params.birthdate)) {
      errors['birthdate'] = ['Birthdate must be in YYYY-MM-DD format'];
    }

    // Validate gender
    if (params.gender.toLowerCase() != 'male' &&
        params.gender.toLowerCase() != 'female') {
      errors['gender'] = ['Gender must be either "male" or "female"'];
    }

    // Return validation failure if there are errors
    if (errors.isNotEmpty) {
      return ApiResult.exception(
        ValidationException(
          message: 'Please fix the errors below',
          errors: errors,
        ),
      );
    }

    // Attempt registration
    final registerParams = RegisterParameters(
      companyType: params.companyType,
      name: params.displayName?.trim() ?? params.name,
      nickname: params.nickname,
      phone: params.phone.trim(),
      phoneIso2Code: params.phoneIso2Code.trim().toUpperCase(),
      password: params.password,
      passwordConfirmation: params.confirmPassword,
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

  /// Validates birthdate format (YYYY-MM-DD).
  bool _isValidBirthdate(String birthdate) {
    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(birthdate.trim())) {
      return false;
    }
    try {
      final parts = birthdate.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);
      if (year < 1900 || year > DateTime.now().year) {
        return false;
      }
      if (month < 1 || month > 12) {
        return false;
      }
      if (day < 1 || day > 31) {
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

/// Parameters for the registration use case.
class RegisterParams {
  const RegisterParams({
    required this.phone,
    required this.phoneIso2Code,
    required this.password,
    required this.confirmPassword,
    this.displayName,
    this.name = '',
    this.nickname,
    this.companyType = 'customer',
    this.countryId = 1,
    this.governorateId = 1,
    this.birthdate = '2000-01-01',
    this.gender = 'male',
    this.deviceType = 'mobile',
    this.deviceToken,
    this.deviceId,
  });

  final String phone;
  final String phoneIso2Code;
  final String password;
  final String confirmPassword;
  final String? displayName;
  final String name;
  final String? nickname;
  final String companyType;
  final int countryId;
  final int governorateId;
  final String birthdate;
  final String gender;
  final String deviceType;
  final String? deviceToken;
  final String? deviceId;
}
