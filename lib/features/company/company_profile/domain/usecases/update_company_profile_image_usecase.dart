// lib/features/company/company_profile/domain/usecases/update_company_profile_image_usecase.dart
import 'dart:io';

import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_profile/data/parameters/update_company_profile_image_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_profile/domain/repositories/company_profile_repository.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';

/// Update Company Profile Image Use Case
///
/// Updates company profile image.
/// Validates image file before calling repository.
class UpdateCompanyProfileImageUseCase {
  final CompanyProfileRepository _repository;

  UpdateCompanyProfileImageUseCase(this._repository);

  Future<ApiResult<UserModel>> execute(
    UpdateCompanyProfileImageParameters parameters,
  ) async {
    // Validate image path
    if (parameters.imagePath.isEmpty) {
      return ApiResult.failure(
        const ValidationException(message: 'Image path is required'),
      );
    }

    // Validate file exists
    final file = File(parameters.imagePath);
    if (!await file.exists()) {
      return ApiResult.failure(
        const ValidationException(message: 'Image file does not exist'),
      );
    }

    // Validate file size (max 5MB)
    final fileSize = await file.length();
    if (fileSize > 5 * 1024 * 1024) {
      return ApiResult.failure(
        const ValidationException(message: 'Image size must be less than 5MB'),
      );
    }

    // Validate file type
    final fileExtension = parameters.imagePath.split('.').last.toLowerCase();
    if (!['jpg', 'jpeg', 'png', 'gif'].contains(fileExtension)) {
      return ApiResult.failure(
        const ValidationException(
          message: 'Invalid image format. Use JPG, PNG, or GIF',
        ),
      );
    }

    // Call repository
    return _repository.updateProfileImage(parameters);
  }
}
