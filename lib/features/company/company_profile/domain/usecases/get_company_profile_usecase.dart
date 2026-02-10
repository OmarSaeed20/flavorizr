// lib/features/company/company_profile/domain/usecases/get_company_profile_usecase.dart
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_profile/domain/repositories/company_profile_repository.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';

/// Get Company Profile Use Case
///
/// Retrieves company profile information.
class GetCompanyProfileUseCase {
  final CompanyProfileRepository _repository;

  GetCompanyProfileUseCase(this._repository);

  Future<ApiResult<UserModel>> execute(void parameters) async {
    return _repository.getProfile();
  }
}
