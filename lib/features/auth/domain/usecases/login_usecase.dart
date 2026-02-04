// lib/features/auth/domain/usecases/login_usecase.dart
import 'package:flavorizr/core/network/exception/network_exceptions.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/auth/data/parameters/sign_in_with_email_parameters.dart';
import 'package:flavorizr/features/auth/domain/entities/auth_result.dart';
import 'package:flavorizr/features/auth/domain/repositories/auth_repository.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';

/// Use case for email/password login.
///
/// This use case:
/// 1. Validates email format
/// 2. Validates password is not empty
/// 3. Calls repository to authenticate
/// 4. Returns user and tokens on success
///
/// Usage:
/// ```dart
/// final result = await loginUseCase(
///   LoginParams(email: 'user@example.com', password: 'secret'),
/// );
/// if (result.isSuccess) {
///   navigateToHome(result.data!.user);
/// } else {
///   showError(result.error!.message);
/// }
/// ```
class LoginUseCase implements UseCase<AuthResult, LoginParams> {
  /// Creates a login use case with the given repository.
  LoginUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseResult<AuthResult> call(LoginParams params) async {
    // Validate email format
    if (!_isValidEmail(params.email)) {
      return const ApiResult.exception(
        ValidationException(
          message: 'Please enter a valid email address',
          errors: {
            'email': ['Invalid email format'],
          },
        ),
      );
    }

    // Validate password is not empty
    if (params.password.isEmpty) {
      return const ApiResult.exception(
        ValidationException(
          message: 'Password cannot be empty',
          errors: {
            'password': ['Password is required'],
          },
        ),
      );
    }

    // Attempt login
    final signInParams = SignInWithEmailParameters(
      email: params.email.trim().toLowerCase(),
      password: params.password,
    );
    final result = await _repository.signInWithEmail(signInParams);

    return result;
  }

  /// Validates email format using a simple regex.
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email.trim());
  }
}

/// Parameters for the login use case.
class LoginParams {
  /// Creates login parameters.
  const LoginParams({required this.email, required this.password});

  /// User's email address.
  final String email;

  /// User's password.
  final String password;
}
