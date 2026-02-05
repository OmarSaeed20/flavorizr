// lib/features/auth/domain/usecases/password_reset_usecase.dart
import 'package:flavorizr/core/network/exception/network_exceptions.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart' show ApiResult;
import 'package:flavorizr/features/user/auth/data/parameters/change_password_parameters.dart';
import 'package:flavorizr/features/user/auth/data/parameters/reset_password_parameters.dart';
import 'package:flavorizr/features/user/auth/data/parameters/send_password_reset_email_parameters.dart';
import 'package:flavorizr/features/user/auth/domain/repositories/auth_repository.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';

/// Use case for requesting a password reset code.
class ForgotPasswordUseCase implements UseCase<void, ForgotPasswordParams> {
  ForgotPasswordUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseResult<void> call(ForgotPasswordParams params) async {
    // Validate phone number format
    if (!_isValidPhone(params.phone)) {
      return const ApiResult.exception(
        ValidationException(message: 'Please enter a valid phone number'),
      );
    }

    final sendParams = SendPasswordResetEmailParameters(
      email: params.phone.trim(),
    ); // Using phone as email for compatibility
    return _repository.sendPasswordResetEmail(sendParams);
  }

  /// Validates phone number format using a simple regex.
  bool _isValidPhone(String phone) {
    // Accept phone numbers with 8-15 digits, optionally with + prefix
    final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
    return phoneRegex.hasMatch(phone.trim());
  }
}

/// Parameters for the forgot password use case.
class ForgotPasswordParams {
  const ForgotPasswordParams({required this.phone});
  final String phone;
}

/// Use case for resetting password with a token.
class ResetPasswordUseCase implements UseCase<void, ResetPasswordParams> {
  ResetPasswordUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseResult<void> call(ResetPasswordParams params) async {
    // Validate new password
    final passwordErrors = _validatePassword(params.newPassword);
    if (passwordErrors.isNotEmpty) {
      return ApiResult.exception(
        ValidationException(
          message: 'Please fix the password errors',
          errors: {'password': passwordErrors},
        ),
      );
    }

    // Validate password confirmation
    if (params.newPassword != params.confirmPassword) {
      return const ApiResult.exception(
        ValidationException(message: 'Passwords do not match'),
      );
    }

    final resetParams = ResetPasswordParameters(
      phone: params.phone ?? '',
      token: params.token,
      password: params.newPassword,
      passwordConfirmation: params.confirmPassword,
    );
    return _repository.resetPassword(resetParams);
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

/// Parameters for the reset password use case.
class ResetPasswordParams {
  const ResetPasswordParams({
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
    this.phone,
  });
  final String token;
  final String newPassword;
  final String confirmPassword;
  final String? phone;
}

/// Use case for changing the current user's password.
class ChangePasswordUseCase implements UseCase<void, ChangePasswordParams> {
  ChangePasswordUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseResult<void> call(ChangePasswordParams params) async {
    // Validate current password is not empty
    if (params.currentPassword.isEmpty) {
      return const ApiResult.exception(
        ValidationException(message: 'Current password is required'),
      );
    }

    // Validate new password
    final passwordErrors = _validatePassword(params.newPassword);
    if (passwordErrors.isNotEmpty) {
      return ApiResult.exception(
        ValidationException(
          message: 'Please fix the password errors',
          errors: {'newPassword': passwordErrors},
        ),
      );
    }

    // Check new password is different
    if (params.currentPassword == params.newPassword) {
      return const ApiResult.exception(
        ValidationException(
          message: 'New password must be different from current password',
        ),
      );
    }

    final changeParams = ChangePasswordParameters(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
    return _repository.changePassword(changeParams);
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

/// Parameters for the change password use case.
class ChangePasswordParams {
  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });
  final String currentPassword;
  final String newPassword;
}
