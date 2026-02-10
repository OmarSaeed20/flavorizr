// lib/features/company/company_profile/domain/usecases/delete_company_profile_image_usecase.dart
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_profile/domain/repositories/company_profile_repository.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';

/// Delete Company Profile Image Use Case
///
/// Deletes company profile image.
class DeleteCompanyProfileImageUseCase {
  final CompanyProfileRepository _repository;

  DeleteCompanyProfileImageUseCase(this._repository);

  Future<ApiResult<UserModel>> execute(void parameters) async {
    return _repository.deleteProfileImage();
  }
}
