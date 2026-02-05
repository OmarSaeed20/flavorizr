// lib/features/auth/domain/usecases/login_usecase.dart
import 'package:flavorizr/core/network/exception/network_exceptions.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/auth/data/parameters/sign_in_with_email_parameters.dart';
import 'package:flavorizr/features/user/auth/domain/entities/auth_result.dart';
import 'package:flavorizr/features/user/auth/domain/repositories/auth_repository.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';

/// Use case for phone/password login.
///
/// This use case:
/// 1. Validates phone number format
/// 2. Validates password is not empty
/// 3. Calls repository to authenticate
/// 4. Returns user and tokens on success
///
/// Usage:
/// ```dart
/// final result = await loginUseCase(
///   LoginParams(phone: '01001107528', phoneIsoCode: 'EG', password: 'secret'),
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
    // Validate phone number format
    if (!_isValidPhone(params.phone)) {
      return const ApiResult.exception(
        ValidationException(
          message: 'Please enter a valid phone number',
          errors: {
            'phone': ['Invalid phone number format'],
          },
        ),
      );
    }

    // Validate phone ISO code
    if (params.phoneIsoCode.isEmpty) {
      return const ApiResult.exception(
        ValidationException(
          message: 'Phone ISO code is required',
          errors: {
            'phoneIsoCode': ['Phone ISO code is required'],
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
      email: params.phone.trim(), // Using phone as email for compatibility
      password: params.password,
    );
    final result = await _repository.signInWithEmail(signInParams);

    return result;
  }

  /// Validates phone number format using a simple regex.
  bool _isValidPhone(String phone) {
    // Accept phone numbers with 8-15 digits, optionally with + prefix
    final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
    return phoneRegex.hasMatch(phone.trim());
  }
}

/// Parameters for the login use case.
class LoginParams {
  /// Creates login parameters.
  const LoginParams({
    required this.phone,
    required this.phoneIsoCode,
    required this.password,
  });

  /// User's phone number.
  final String phone;

  /// Phone ISO code (e.g., 'EG', 'US').
  final String phoneIsoCode;

  /// User's password.
  final String password;
}
