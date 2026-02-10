// lib/features/company/company_auth/domain/usecases/company_login_usecase.dart
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_login_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/repositories/company_auth_repository.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_tokens.dart';

/// Company Login Use Case
///
/// Handles company login with phone and password.
/// Validates input parameters before calling repository.
class CompanyLoginUseCase {
  final CompanyAuthRepository _repository;

  CompanyLoginUseCase(this._repository);

  Future<ApiResult<AuthTokens>> execute(
    CompanyLoginParameters parameters,
  ) async {
    // Validate phone number
    if (parameters.phone.isEmpty) {
      return ApiResult.failure(
        const ValidationException(message: 'Phone number is required'),
      );
    }

    // Validate phone ISO code
    if (parameters.phoneIsoCode.isEmpty) {
      return ApiResult.failure(
        const ValidationException(message: 'Phone ISO code is required'),
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

    // Validate Firebase token
    if (parameters.firebaseToken.isEmpty) {
      return ApiResult.failure(
        const ValidationException(message: 'Firebase token is required'),
      );
    }

    // Call repository
    return _repository.login(parameters);
  }
}
