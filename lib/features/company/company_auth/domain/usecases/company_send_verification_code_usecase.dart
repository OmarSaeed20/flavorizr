// lib/features/company/company_auth/domain/usecases/company_send_verification_code_usecase.dart
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_send_verification_code_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/repositories/company_auth_repository.dart';

/// Company Send Verification Code Use Case
///
/// Handles sending verification code to company phone.
/// Validates input parameters before calling repository.
class CompanySendVerificationCodeUseCase {
  final CompanyAuthRepository _repository;

  CompanySendVerificationCodeUseCase(this._repository);

  Future<ApiResult<void>> execute(
    CompanySendVerificationCodeParameters parameters,
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

    // Call repository
    return _repository.sendVerificationCode(parameters);
  }
}
