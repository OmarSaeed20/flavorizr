// lib/features/profile/data/repositories/profile_repository_impl.dart
import 'dart:async';

import 'package:flavorizr/core/network/base/repo/base_repository.dart';
import 'package:flavorizr/core/network/exception/network_exceptions.dart';
import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:flavorizr/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:flavorizr/features/profile/data/models/profile_model.dart';
import 'package:flavorizr/features/profile/domain/entities/profile.dart';
import 'package:flavorizr/features/profile/domain/repositories/profile_repository.dart';

/// Implementation of [ProfileRepository].
///
/// Coordinates between remote and local data sources,
/// handles network connectivity, and manages profile state.
/// Extends BaseRepository for consistent error handling and network checks.
class ProfileRepositoryImpl extends BaseRepository implements ProfileRepository {
  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required ProfileLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  final NetworkInfo _networkInfo;

  // Stream controller for profile updates
  final _profileController = StreamController<Profile?>.broadcast();

  Profile? _currentProfile;

  @override
  Stream<Profile?> get profileUpdates => _profileController.stream;

  // ==================== Profile CRUD ====================

  @override
  Future<ApiResult<Profile>> getCurrentProfile() async {
    // First try to return cached profile if available
    if (_currentProfile != null) {
      return ApiResult.success(_currentProfile!);
    }

    final result = await fetchWithCache<ProfileModel>(
      cacheKey: 'current_profile',
      remoteFetcher: _remoteDataSource.getCurrentProfile,
      localFetcher: _localDataSource.getProfile,
      cacheSaver: _localDataSource.saveProfile,
      strategy: CacheStrategy.networkFirst,
      maxCacheAge: const Duration(minutes: 5),
    );

    return result.when(
      success: (profileModel, _) {
        _currentProfile = profileModel.toEntity();
        _profileController.add(_currentProfile);
        return ApiResult.success(_currentProfile!);
      },
      exception: (error) {
        // If we have cached data, return it with the failure
        if (_currentProfile != null) {
          return ApiResult.success(_currentProfile!, error);
        }
        return ApiResult.exception(error);
      },
    );
  }

  @override
  Future<ApiResult<Profile>> getProfileByUserId(String userId) async {
    final result = await fetchWithCache<ProfileModel>(
      cacheKey: 'profile_$userId',
      remoteFetcher: () => _remoteDataSource.getProfileByUserId(userId),
      localFetcher: () async {
        final cached = await _localDataSource.getProfileById(userId);
        return cached;
      },
      cacheSaver: (profile) => _localDataSource.saveProfileById(userId, profile),
      maxCacheAge: const Duration(minutes: 10),
    );

    return result.when(
      success: (profileModel, _) => ApiResult.success(profileModel.toEntity()),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<Profile>> getProfileByUsername(String username) async {
    final result = await executeRemoteRequest<ProfileModel>(
      request: () => _remoteDataSource.getProfileByUsername(username),
    );

    return result.when(
      success: (profileModel, _) => ApiResult.success(profileModel.toEntity()),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<Profile>> updateProfile(ProfileUpdateData data) async {
    if (data.isEmpty) {
      return ApiResult.success(_currentProfile!);
    }

    final result = await executeRemoteRequest<ProfileModel>(
      request: () => _remoteDataSource.updateProfile(data),
    );

    return result.when(
      success: (profileModel, _) {
        _currentProfile = profileModel.toEntity();
        // Update cache
        _localDataSource.saveProfile(profileModel);
        _profileController.add(_currentProfile);
        return ApiResult.success(_currentProfile!);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<Profile>> updateProfilePhoto(String imagePath) async {
    final result = await executeRemoteRequest<ProfileModel>(
      request: () => _remoteDataSource.updateProfilePhoto(imagePath),
    );

    return result.when(
      success: (profileModel, _) {
        _currentProfile = profileModel.toEntity();
        // Update cache
        _localDataSource.saveProfile(profileModel);
        _profileController.add(_currentProfile);
        return ApiResult.success(_currentProfile!);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<Profile>> updateCoverPhoto(String imagePath) async {
    final result = await executeRemoteRequest<ProfileModel>(
      request: () => _remoteDataSource.updateCoverPhoto(imagePath),
    );

    return result.when(
      success: (profileModel, _) {
        _currentProfile = profileModel.toEntity();
        // Update cache
        _localDataSource.saveProfile(profileModel);
        _profileController.add(_currentProfile);
        return ApiResult.success(_currentProfile!);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<Profile>> removeProfilePhoto() async {
    final result = await executeRemoteRequest<ProfileModel>(
      request: _remoteDataSource.removeProfilePhoto,
    );

    return result.when(
      success: (profileModel, _) {
        _currentProfile = profileModel.toEntity();
        // Update cache
        _localDataSource.saveProfile(profileModel);
        _profileController.add(_currentProfile);
        return ApiResult.success(_currentProfile!);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<Profile>> removeCoverPhoto() async {
    final result = await executeRemoteRequest<ProfileModel>(
      request: _remoteDataSource.removeCoverPhoto,
    );

    return result.when(
      success: (profileModel, _) {
        _currentProfile = profileModel.toEntity();
        // Update cache
        _localDataSource.saveProfile(profileModel);
        _profileController.add(_currentProfile);
        return ApiResult.success(_currentProfile!);
      },
      exception: ApiResult.exception,
    );
  }

  // ==================== Preferences ====================

  @override
  Future<ApiResult<ProfilePreferences>> getPreferences() async {
    final result = await fetchWithCache<ProfilePreferences>(
      cacheKey: 'profile_preferences',
      remoteFetcher: _remoteDataSource.getPreferences,
      localFetcher: _localDataSource.getPreferences,
      cacheSaver: _localDataSource.savePreferences,
      strategy: CacheStrategy.staleWhileRevalidate,
      maxCacheAge: const Duration(minutes: 15),
    );

    return result.when(
      success: (prefsModel, _) => ApiResult.success(prefsModel),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<ProfilePreferences>> updatePreferences(ProfilePreferences preferences) async {
    final result = await executeRemoteRequest<ProfilePreferences>(
      request: () => _remoteDataSource.updatePreferences(preferences),
    );

    return result.when(
      success: (prefsModel, _) {
        // Update cache
        _localDataSource.savePreferences(prefsModel);
        return ApiResult.success(prefsModel);
      },
      exception: ApiResult.exception,
    );
  }

  // ==================== Social ====================

  @override
  Future<ApiResult<bool>> followUser(String userId) async {
    final result = await executeRemoteRequest<void>(
      request: () => _remoteDataSource.followUser(userId),
    );

    return result.when(
      success: (_, __) => const ApiResult.success(true),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<bool>> unfollowUser(String userId) async {
    final result = await executeRemoteRequest<void>(
      request: () => _remoteDataSource.unfollowUser(userId),
    );

    return result.when(
      success: (_, __) => const ApiResult.success(true),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<List<Profile>>> getFollowers(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    final result = await fetchWithCache<List<ProfileModel>>(
      cacheKey: 'followers_${userId}_${page}_$limit',
      remoteFetcher: () => _remoteDataSource.getFollowers(userId, page: page, limit: limit),
      localFetcher: () async => const ApiResult.exception(NotFoundException()),
      cacheSaver: (_) async {}, // No local caching for followers list
      strategy: CacheStrategy.networkFirst,
      maxCacheAge: const Duration(minutes: 5),
    );

    return result.when(
      success: (profileModels, _) {
        final profiles = profileModels.map((m) => m.toEntity()).toList();
        return ApiResult.success(profiles);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<List<Profile>>> getFollowing(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    final result = await fetchWithCache<List<ProfileModel>>(
      cacheKey: 'following_${userId}_${page}_$limit',
      remoteFetcher: () => _remoteDataSource.getFollowing(userId, page: page, limit: limit),
      localFetcher: () async => const ApiResult.exception(NotFoundException()),
      cacheSaver: (_) async {}, // No local caching for following list
      strategy: CacheStrategy.networkFirst,
      maxCacheAge: const Duration(minutes: 5),
    );

    return result.when(
      success: (profileModels, _) {
        final profiles = profileModels.map((m) => m.toEntity()).toList();
        return ApiResult.success(profiles);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<bool>> isFollowing(String userId) async {
    final result = await executeRemoteRequest<bool>(
      request: () => _remoteDataSource.isFollowing(userId),
    );

    return result.when(
      success: (isFollowing, _) => ApiResult.success(isFollowing),
      exception: ApiResult.exception,
    );
  }

  // ==================== Account ====================

  @override
  Future<ApiResult<bool>> deleteAccount(String password) async {
    final result = await executeRemoteRequest<void>(
      request: () => _remoteDataSource.deleteAccount(password),
    );

    return result.when(
      success: (_, __) async {
        // Clear all local data
        await _localDataSource.clearAll();
        _currentProfile = null;
        _profileController.add(null);
        return const ApiResult.success(true);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<String?>> exportUserData() async {
    final result = await executeRemoteRequest<String?>(request: _remoteDataSource.exportUserData);

    return result.when(
      success: (downloadUrl, _) => ApiResult.success(downloadUrl),
      exception: ApiResult.exception,
    );
  }

  // ==================== Cache ====================

  @override
  Future<ApiResult<Profile?>> getCachedProfile() async {
    final cached = await _localDataSource.getProfile();
    return cached;
  }

  @override
  Future<void> cacheProfile(Profile profile) async {
    final model = ProfileModel.fromEntity(profile);
    await _localDataSource.saveProfile(model);
  }

  @override
  Future<void> clearProfileCache() async {
    await _localDataSource.clearAll();
    _currentProfile = null;
    _profileController.add(null);
  }

  /// Disposes the repository and closes streams.
  void dispose() {
    _profileController.close();
  }
}
