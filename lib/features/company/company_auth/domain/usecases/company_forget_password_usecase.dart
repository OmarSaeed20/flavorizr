// lib/features/company/company_auth/domain/usecases/company_forget_password_usecase.dart
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_forget_password_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/repositories/company_auth_repository.dart';

/// Company Forget Password Use Case
///
/// Handles company password reset initiation.
/// Validates input parameters before calling repository.
class CompanyForgetPasswordUseCase {
  final CompanyAuthRepository _repository;

  CompanyForgetPasswordUseCase(this._repository);

  Future<ApiResult<void>> execute(
    CompanyForgetPasswordParameters parameters,
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
    return _repository.forgetPassword(parameters);
  }
}
