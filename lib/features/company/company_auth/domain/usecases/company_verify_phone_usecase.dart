// lib/features/company/company_auth/domain/usecases/company_verify_phone_usecase.dart
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_verify_phone_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/repositories/company_auth_repository.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_tokens.dart';

/// Company Verify Phone Use Case
///
/// Handles company phone verification with confirmation code.
/// Validates input parameters before calling repository.
class CompanyVerifyPhoneUseCase {
  final CompanyAuthRepository _repository;

  CompanyVerifyPhoneUseCase(this._repository);

  Future<ApiResult<AuthTokens>> execute(CompanyVerifyPhoneParameters parameters) async {
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

    // Call repository
    return _repository.verifyPhone(parameters);
  }
}
