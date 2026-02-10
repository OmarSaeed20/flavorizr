// lib/features/company/company_auth/domain/usecases/company_logout_usecase.dart
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_logout_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/repositories/company_auth_repository.dart';

/// Company Logout Use Case
///
/// Handles company logout.
/// Clears local auth data and invalidates tokens.
class CompanyLogoutUseCase {
  final CompanyAuthRepository _repository;

  CompanyLogoutUseCase(this._repository);

  Future<ApiResult<void>> execute(CompanyLogoutParameters parameters) async {
    // Call repository
    return _repository.logout(parameters);
  }
}
