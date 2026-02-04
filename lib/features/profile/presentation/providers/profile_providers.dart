// lib/features/profile/presentation/providers/profile_providers.dart
import 'package:flavorizr/core/di/providers.dart';
import 'package:flavorizr/features/auth/presentation/providers/auth_providers.dart';
import 'package:flavorizr/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:flavorizr/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:flavorizr/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flavorizr/features/profile/domain/entities/profile.dart';
import 'package:flavorizr/features/profile/domain/repositories/profile_repository.dart';
import 'package:flavorizr/features/profile/domain/usecases/profile_usecases.dart';
import 'package:flavorizr/features/profile/presentation/controllers/edit_profile_controller.dart';
import 'package:flavorizr/features/profile/presentation/controllers/profile_controller.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==================== Data Sources ====================

/// Provider for ProfileRemoteDataSource.
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfileRemoteDataSourceImpl(apiClient);
});

/// Provider for ProfileLocalDataSource.
final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ProfileLocalDataSourceImpl(prefs: prefs);
});

// ==================== Repository ====================

/// Provider for ProfileRepository.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remoteDataSource = ref.watch(profileRemoteDataSourceProvider);
  final localDataSource = ref.watch(profileLocalDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return ProfileRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );
});

// ==================== Use Cases ====================

/// Provider for GetCurrentProfileUseCase.
final getCurrentProfileUseCaseProvider = Provider<GetCurrentProfileUseCase>((ref) {
  return GetCurrentProfileUseCase(ref.watch(profileRepositoryProvider));
});

/// Provider for GetProfileByUserIdUseCase.
final getProfileByUserIdUseCaseProvider = Provider<GetProfileByUserIdUseCase>((ref) {
  return GetProfileByUserIdUseCase(ref.watch(profileRepositoryProvider));
});

/// Provider for UpdateProfileUseCase.
final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  return UpdateProfileUseCase(ref.watch(profileRepositoryProvider));
});

/// Provider for UpdateProfilePhotoUseCase.
final updateProfilePhotoUseCaseProvider = Provider<UpdateProfilePhotoUseCase>((ref) {
  return UpdateProfilePhotoUseCase(ref.watch(profileRepositoryProvider));
});

/// Provider for UpdateCoverPhotoUseCase.
final updateCoverPhotoUseCaseProvider = Provider<UpdateCoverPhotoUseCase>((ref) {
  return UpdateCoverPhotoUseCase(ref.watch(profileRepositoryProvider));
});

/// Provider for RemoveProfilePhotoUseCase.
final removeProfilePhotoUseCaseProvider = Provider<RemoveProfilePhotoUseCase>((ref) {
  return RemoveProfilePhotoUseCase(ref.watch(profileRepositoryProvider));
});

/// Provider for RemoveCoverPhotoUseCase.
final removeCoverPhotoUseCaseProvider = Provider<RemoveCoverPhotoUseCase>((ref) {
  return RemoveCoverPhotoUseCase(ref.watch(profileRepositoryProvider));
});

/// Provider for FollowUserUseCase.
final followUserUseCaseProvider = Provider<FollowUserUseCase>((ref) {
  return FollowUserUseCase(ref.watch(profileRepositoryProvider));
});

/// Provider for UnfollowUserUseCase.
final unfollowUserUseCaseProvider = Provider<UnfollowUserUseCase>((ref) {
  return UnfollowUserUseCase(ref.watch(profileRepositoryProvider));
});

/// Provider for GetFollowersUseCase.
final getFollowersUseCaseProvider = Provider<GetFollowersUseCase>((ref) {
  return GetFollowersUseCase(ref.watch(profileRepositoryProvider));
});

/// Provider for GetFollowingUseCase.
final getFollowingUseCaseProvider = Provider<GetFollowingUseCase>((ref) {
  return GetFollowingUseCase(ref.watch(profileRepositoryProvider));
});

/// Provider for UpdatePreferencesUseCase.
final updatePreferencesUseCaseProvider = Provider<UpdatePreferencesUseCase>((ref) {
  return UpdatePreferencesUseCase(ref.watch(profileRepositoryProvider));
});

/// Provider for DeleteAccountUseCase.
final deleteAccountUseCaseProvider = Provider<DeleteAccountUseCase>((ref) {
  return DeleteAccountUseCase(ref.watch(profileRepositoryProvider));
});

// ==================== State Providers ====================

/// Provider for the current user's profile.
final currentProfileProvider = FutureProvider<Profile?>((ref) async {
  final useCase = ref.watch(getCurrentProfileUseCaseProvider);
  final result = await useCase(const NoParams());
  return result.data;
});

/// Provider for a user's profile by ID.
final userProfileProvider = FutureProvider.family<Profile?, String>((ref, userId) async {
  final useCase = ref.watch(getProfileByUserIdUseCaseProvider);
  final result = await useCase(userId);
  return result.data;
});

/// Provider for checking if current user follows a specific user.
final isFollowingProvider = FutureProvider.family<bool, String>((ref, userId) async {
  final repository = ref.watch(profileRepositoryProvider);
  final result = await repository.isFollowing(userId);
  return result.data ?? false;
});

/// Provider for followers list.
final followersProvider = FutureProvider.family<List<Profile>, String>((ref, userId) async {
  final useCase = ref.watch(getFollowersUseCaseProvider);
  final result = await useCase(GetFollowersParams(userId: userId));
  return result.data ?? [];
});

/// Provider for following list.
final followingProvider = FutureProvider.family<List<Profile>, String>((ref, userId) async {
  final useCase = ref.watch(getFollowingUseCaseProvider);
  final result = await useCase(GetFollowersParams(userId: userId));
  return result.data ?? [];
});

// ==================== Controllers ====================

/// Provider for ProfileController.
final profileControllerProvider = NotifierProvider.autoDispose<ProfileController, ProfileState>(
  ProfileController.new,
);

/// Provider for EditProfileController.
final editProfileControllerProvider =
    NotifierProvider.autoDispose<EditProfileController, EditProfileState>(
      EditProfileController.new,
    );
