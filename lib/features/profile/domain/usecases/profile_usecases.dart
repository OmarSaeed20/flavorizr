// lib/features/profile/domain/usecases/profile_usecases.dart
import 'package:flavorizr/core/error/failures.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';
import 'package:flavorizr/features/profile/domain/entities/profile.dart';
import 'package:flavorizr/features/profile/domain/repositories/profile_repository.dart';

/// Use case for getting the current user's profile.
class GetCurrentProfileUseCase implements UseCase<Profile, NoParams> {
  const GetCurrentProfileUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<({Profile? data, Failure? failure})> call(NoParams params) {
    return _repository.getCurrentProfile();
  }
}

/// Use case for getting a profile by user ID.
class GetProfileByUserIdUseCase implements UseCase<Profile, String> {
  const GetProfileByUserIdUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<({Profile? data, Failure? failure})> call(String userId) {
    return _repository.getProfileByUserId(userId);
  }
}

/// Use case for updating the current user's profile.
class UpdateProfileUseCase implements UseCase<Profile, ProfileUpdateData> {
  const UpdateProfileUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<({Profile? data, Failure? failure})> call(ProfileUpdateData data) async {
    // Validate update data
    if (data.isEmpty) {
      return (data: null, failure: const ValidationFailure(message: 'No data to update'));
    }

    // Validate display name length
    if (data.displayName != null && data.displayName!.trim().length < 2) {
      return (
        data: null,
        failure: const ValidationFailure(message: 'Display name must be at least 2 characters'),
      );
    }

    // Validate bio length
    if (data.bio != null && data.bio!.length > 500) {
      return (
        data: null,
        failure: const ValidationFailure(message: 'Bio cannot exceed 500 characters'),
      );
    }

    // Validate website URL
    if (data.website != null && data.website!.isNotEmpty) {
      final urlRegex = RegExp(r'^https?://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(/\S*)?$');
      if (!urlRegex.hasMatch(data.website!)) {
        return (data: null, failure: const ValidationFailure(message: 'Please enter a valid URL'));
      }
    }

    return _repository.updateProfile(data);
  }
}

/// Use case for updating profile photo.
class UpdateProfilePhotoUseCase implements UseCase<Profile, String> {
  const UpdateProfilePhotoUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<({Profile? data, Failure? failure})> call(String imagePath) {
    if (imagePath.isEmpty) {
      return Future.value((
        data: null,
        failure: const ValidationFailure(message: 'Image path is required'),
      ));
    }
    return _repository.updateProfilePhoto(imagePath);
  }
}

/// Use case for updating cover photo.
class UpdateCoverPhotoUseCase implements UseCase<Profile, String> {
  const UpdateCoverPhotoUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<({Profile? data, Failure? failure})> call(String imagePath) {
    if (imagePath.isEmpty) {
      return Future.value((
        data: null,
        failure: const ValidationFailure(message: 'Image path is required'),
      ));
    }
    return _repository.updateCoverPhoto(imagePath);
  }
}

/// Use case for removing profile photo.
class RemoveProfilePhotoUseCase implements UseCase<Profile, NoParams> {
  const RemoveProfilePhotoUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<({Profile? data, Failure? failure})> call(NoParams params) {
    return _repository.removeProfilePhoto();
  }
}

/// Use case for following a user.
class FollowUserUseCase implements UseCase<bool, String> {
  const FollowUserUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<({bool? data, Failure? failure})> call(String userId) {
    if (userId.isEmpty) {
      return Future.value((
        data: null,
        failure: const ValidationFailure(message: 'User ID is required'),
      ));
    }
    return _repository.followUser(userId);
  }
}

/// Use case for unfollowing a user.
class UnfollowUserUseCase implements UseCase<bool, String> {
  const UnfollowUserUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<({bool? data, Failure? failure})> call(String userId) {
    if (userId.isEmpty) {
      return Future.value((
        data: null,
        failure: const ValidationFailure(message: 'User ID is required'),
      ));
    }
    return _repository.unfollowUser(userId);
  }
}

/// Use case for getting followers list.
class GetFollowersUseCase implements UseCase<List<Profile>, GetFollowersParams> {
  const GetFollowersUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<({List<Profile>? data, Failure? failure})> call(GetFollowersParams params) {
    return _repository.getFollowers(params.userId, page: params.page, limit: params.limit);
  }
}

/// Parameters for getting followers.
class GetFollowersParams {
  const GetFollowersParams({required this.userId, this.page = 1, this.limit = 20});

  final String userId;
  final int page;
  final int limit;
}

/// Use case for getting following list.
class GetFollowingUseCase implements UseCase<List<Profile>, GetFollowersParams> {
  const GetFollowingUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<({List<Profile>? data, Failure? failure})> call(GetFollowersParams params) {
    return _repository.getFollowing(params.userId, page: params.page, limit: params.limit);
  }
}

/// Use case for updating profile preferences.
class UpdatePreferencesUseCase implements UseCase<ProfilePreferences, ProfilePreferences> {
  const UpdatePreferencesUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<({ProfilePreferences? data, Failure? failure})> call(ProfilePreferences preferences) {
    return _repository.updatePreferences(preferences);
  }
}

/// Use case for deleting account.
class DeleteAccountUseCase implements UseCase<bool, String> {
  const DeleteAccountUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<({bool? data, Failure? failure})> call(String password) {
    if (password.isEmpty) {
      return Future.value((
        data: null,
        failure: const ValidationFailure(message: 'Password is required'),
      ));
    }
    return _repository.deleteAccount(password);
  }
}
