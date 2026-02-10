// lib/features/company/company_profile/domain/usecases/get_company_profile_detail_usecase.dart
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_profile/domain/repositories/company_profile_repository.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';

/// Get Company Profile Detail Use Case
///
/// Retrieves detailed company profile information.
class GetCompanyProfileDetailUseCase {
  final CompanyProfileRepository _repository;

  GetCompanyProfileDetailUseCase(this._repository);

  Future<ApiResult<UserModel>> execute(void parameters) async {
    return _repository.getProfileDetail();
  }
}
