// lib/features/auth/domain/usecases/register_usecase.dart
import 'package:flavorizr/core/network/exception/network_exceptions.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart' show ApiResult;
import 'package:flavorizr/features/auth/data/parameters/register_parameters.dart';
import 'package:flavorizr/features/auth/domain/entities/auth_result.dart';
import 'package:flavorizr/features/auth/domain/repositories/auth_repository.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';

/// Use case for user registration.
///
/// This use case:
/// 1. Validates email format
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

    // Validate email format
    if (!_isValidEmail(params.email)) {
      errors['email'] = ['Please enter a valid email address'];
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

    // Return validation failure if there are errors
    if (errors.isNotEmpty) {
      return ApiResult.exception(
        ValidationException(message: 'Please fix the errors below', errors: errors),
      );
    }

    // Attempt registration
    final registerParams = RegisterParameters(
      companyType: params.companyType,
      name: params.displayName?.trim() ?? params.name,
      nickname: params.nickname,
      phone: params.email.trim().toLowerCase(), // Using email as phone for now
      password: params.password,
      passwordConfirmation: params.confirmPassword,
      country: params.country,
      governorate: params.governorate,
      birthdate: params.birthdate,
      gender: params.gender,
      deviceType: params.deviceType,
      deviceToken: params.deviceToken,
      deviceId: params.deviceId,
    );
    final result = await _repository.signUp(registerParams);

    return result;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email.trim());
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
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.displayName,
    this.name = '',
    this.nickname,
    this.companyType = 'customer',
    this.country = 'Unknown',
    this.governorate = 'Unknown',
    this.birthdate = '2000',
    this.gender = 'male',
    this.deviceType = 'mobile',
    this.deviceToken,
    this.deviceId,
  });

  final String email;
  final String password;
  final String confirmPassword;
  final String? displayName;
  final String name;
  final String? nickname;
  final String companyType;
  final String country;
  final String governorate;
  final String birthdate;
  final String gender;
  final String deviceType;
  final String? deviceToken;
  final String? deviceId;
}
