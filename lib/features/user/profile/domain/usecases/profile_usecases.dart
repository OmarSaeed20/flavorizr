// lib/features/profile/domain/usecases/profile_usecases.dart
import 'package:flavorizr/core/network/exception/network_exceptions.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/profile/domain/entities/profile.dart';
import 'package:flavorizr/features/user/profile/domain/repositories/profile_repository.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';

/// Use case for getting the current user's profile.
class GetProfileUseCase implements UseCase<Profile, NoParams> {
  const GetProfileUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<ApiResult<Profile>> call(NoParams params) async {
    return _repository.getProfile();
  }
}

/// Use case for getting detailed profile information.
class GetProfileDetailUseCase implements UseCase<Profile, NoParams> {
  const GetProfileDetailUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<ApiResult<Profile>> call(NoParams params) async {
    return _repository.getProfileDetail();
  }
}

/// Use case for updating the current user's profile information.
class UpdateProfileInfoUseCase implements UseCase<Profile, ProfileUpdateData> {
  const UpdateProfileInfoUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<ApiResult<Profile>> call(ProfileUpdateData data) async {
    // Validate update data
    if (data.isEmpty) {
      return const ApiResult.exception(
        ValidationException(message: 'No data to update'),
      );
    }

    // Validate name length
    if (data.name != null && data.name!.trim().length < 2) {
      return const ApiResult.exception(
        ValidationException(message: 'Name must be at least 2 characters'),
      );
    }

    // Validate email format
    if (data.email != null && data.email!.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(data.email!)) {
        return const ApiResult.exception(
          ValidationException(message: 'Please enter a valid email address'),
        );
      }
    }

    // Validate gender
    if (data.gender != null && !['male', 'female'].contains(data.gender)) {
      return const ApiResult.exception(
        ValidationException(
          message: 'Gender must be either "male" or "female"',
        ),
      );
    }

    // Validate birth date format
    if (data.birthDate != null && data.birthDate!.isNotEmpty) {
      final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
      if (!dateRegex.hasMatch(data.birthDate!)) {
        return const ApiResult.exception(
          ValidationException(
            message: 'Birth date must be in YYYY-MM-DD format',
          ),
        );
      }
    }

    return _repository.updateProfileInfo(data);
  }
}

/// Use case for getting driver reviews.
class GetDriverReviewsUseCase implements UseCase<List<DriverReview>, String> {
  const GetDriverReviewsUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<ApiResult<List<DriverReview>>> call(String driverId) {
    if (driverId.isEmpty) {
      return Future.value(
        const ApiResult.exception(
          ValidationException(message: 'Driver ID is required'),
        ),
      );
    }
    return _repository.getDriverReviews(driverId);
  }
}
