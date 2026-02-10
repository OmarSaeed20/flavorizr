// lib/features/company/company_profile/domain/usecases/update_company_profile_info_usecase.dart
import 'package:fast_golden_taxi/core/network/exception/api_error.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_profile/data/parameters/update_company_profile_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_profile/domain/repositories/company_profile_repository.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';

/// Update Company Profile Info Use Case
///
/// Updates company profile information.
/// Validates input parameters before calling repository.
class UpdateCompanyProfileInfoUseCase {
  final CompanyProfileRepository _repository;

  UpdateCompanyProfileInfoUseCase(this._repository);

  Future<ApiResult<UserModel>> execute(
    UpdateCompanyProfileParameters parameters,
  ) async {
    // Validate name if provided
    if (parameters.name != null && parameters.name!.isEmpty) {
      return ApiResult.failure(
        ApiError.validation(message: 'Company name cannot be empty'),
      );
    }

    // Validate email if provided
    if (parameters.email != null && parameters.email!.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(parameters.email!)) {
        return ApiResult.failure(
          ApiError.validation(message: 'Invalid email format'),
        );
      }
    }

    // Validate phone if provided
    if (parameters.phone != null && parameters.phone!.isNotEmpty) {
      if (parameters.phone!.length < 10) {
        return ApiResult.failure(
          ApiError.validation(message: 'Invalid phone number'),
        );
      }
    }

    // Validate birthdate if provided
    if (parameters.birthdate != null && parameters.birthdate!.isNotEmpty) {
      final birthdateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
      if (!birthdateRegex.hasMatch(parameters.birthdate!)) {
        return ApiResult.failure(
          ApiError.validation(
            message: 'Invalid birthdate format. Use YYYY-MM-DD',
          ),
        );
      }
    }

    // Validate gender if provided
    if (parameters.gender != null && parameters.gender!.isNotEmpty) {
      if (parameters.gender != 'male' && parameters.gender != 'female') {
        return ApiResult.failure(
          ApiError.validation(message: 'Invalid gender value'),
        );
      }
    }

    // Call repository
    return _repository.updateProfileInfo(parameters);
  }
}
