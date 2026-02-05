// lib/features/profile/presentation/providers/profile_providers.dart
import 'package:flavorizr/core/di/providers.dart';
import 'package:flavorizr/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:flavorizr/features/user/profile/data/datasources/profile_local_datasource.dart';
import 'package:flavorizr/features/user/profile/data/datasources/profile_remote_datasource.dart';
import 'package:flavorizr/features/user/profile/data/repositories/profile_repository_impl.dart';
import 'package:flavorizr/features/user/profile/domain/entities/profile.dart';
import 'package:flavorizr/features/user/profile/domain/repositories/profile_repository.dart';
import 'package:flavorizr/features/user/profile/domain/usecases/profile_usecases.dart';
import 'package:flavorizr/features/user/profile/presentation/controllers/edit_profile_controller.dart';
import 'package:flavorizr/features/user/profile/presentation/controllers/profile_controller.dart';
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

/// Provider for GetProfileUseCase.
final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  return GetProfileUseCase(ref.watch(profileRepositoryProvider));
});

/// Provider for GetProfileDetailUseCase.
final getProfileDetailUseCaseProvider = Provider<GetProfileDetailUseCase>((ref) {
  return GetProfileDetailUseCase(ref.watch(profileRepositoryProvider));
});

/// Provider for UpdateProfileInfoUseCase.
final updateProfileInfoUseCaseProvider = Provider<UpdateProfileInfoUseCase>((ref) {
  return UpdateProfileInfoUseCase(ref.watch(profileRepositoryProvider));
});

/// Provider for GetDriverReviewsUseCase.
final getDriverReviewsUseCaseProvider = Provider<GetDriverReviewsUseCase>((ref) {
  return GetDriverReviewsUseCase(ref.watch(profileRepositoryProvider));
});

// ==================== State Providers ====================

/// Provider for the current user's profile.
final currentProfileProvider = FutureProvider<Profile?>((ref) async {
  final useCase = ref.watch(getProfileUseCaseProvider);
  final result = await useCase(const NoParams());
  return result.data;
});

/// Provider for the current user's profile detail.
final currentProfileDetailProvider = FutureProvider<Profile?>((ref) async {
  final useCase = ref.watch(getProfileDetailUseCaseProvider);
  final result = await useCase(const NoParams());
  return result.data;
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
