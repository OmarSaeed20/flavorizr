// lib/features/auth/domain/usecases/password_reset_usecase.dart
import 'package:flavorizr/core/network/exception/network_exceptions.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart' show ApiResult;
import 'package:flavorizr/features/auth/data/parameters/change_password_parameters.dart';
import 'package:flavorizr/features/auth/data/parameters/reset_password_parameters.dart';
import 'package:flavorizr/features/auth/data/parameters/send_password_reset_email_parameters.dart';
import 'package:flavorizr/features/auth/domain/repositories/auth_repository.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';

/// Use case for requesting a password reset email.
class ForgotPasswordUseCase implements UseCase<void, ForgotPasswordParams> {
  ForgotPasswordUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseResult<void> call(ForgotPasswordParams params) async {
    // Validate email format
    if (!_isValidEmail(params.email)) {
      return const ApiResult.exception(
        ValidationException(message: 'Please enter a valid email address'),
      );
    }

    final sendParams = SendPasswordResetEmailParameters(email: params.email.trim().toLowerCase());
    return _repository.sendPasswordResetEmail(sendParams);
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email.trim());
  }
}

/// Parameters for the forgot password use case.
class ForgotPasswordParams {
  const ForgotPasswordParams({required this.email});
  final String email;
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
      return const ApiResult.exception(ValidationException(message: 'Passwords do not match'));
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
        ValidationException(message: 'New password must be different from current password'),
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
  const ChangePasswordParams({required this.currentPassword, required this.newPassword});
  final String currentPassword;
  final String newPassword;
}
