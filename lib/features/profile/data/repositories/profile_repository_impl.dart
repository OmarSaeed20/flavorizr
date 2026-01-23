// lib/features/profile/data/repositories/profile_repository_impl.dart
import 'dart:async';

import 'package:flavorizr/core/error/failures.dart';
import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:flavorizr/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:flavorizr/features/profile/data/models/profile_model.dart';
import 'package:flavorizr/features/profile/domain/entities/profile.dart';
import 'package:flavorizr/features/profile/domain/repositories/profile_repository.dart';

/// Implementation of [ProfileRepository].
///
/// Coordinates between remote and local data sources,
/// handles network connectivity, and manages profile state.
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required ProfileLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  // Stream controller for profile updates
  final _profileController = StreamController<Profile?>.broadcast();

  Profile? _currentProfile;

  @override
  Stream<Profile?> get profileUpdates => _profileController.stream;

  // ==================== Profile CRUD ====================

  @override
  Future<({Profile? data, Failure? failure})> getCurrentProfile() async {
    // First try to return cached profile if available
    if (_currentProfile != null) {
      return (data: _currentProfile, failure: null);
    }

    // Check local cache
    final cachedProfile = await _localDataSource.getProfile();
    if (cachedProfile != null) {
      _currentProfile = cachedProfile.toEntity();
      _profileController.add(_currentProfile);
    }

    // If no network, return cached or error
    if (!await _networkInfo.isConnected) {
      if (_currentProfile != null) {
        return (data: _currentProfile, failure: null);
      }
      return (data: null, failure: const NetworkFailure());
    }

    try {
      final profileModel = await _remoteDataSource.getCurrentProfile();
      _currentProfile = profileModel.toEntity();

      // Cache the profile
      await _localDataSource.saveProfile(profileModel);
      _profileController.add(_currentProfile);

      return (data: _currentProfile, failure: null);
    } catch (e) {
      // If we have cached data, return it with the failure
      if (_currentProfile != null) {
        return (data: _currentProfile, failure: _mapExceptionToFailure(e));
      }
      return (data: null, failure: _mapExceptionToFailure(e));
    }
  }

  @override
  Future<({Profile? data, Failure? failure})> getProfileByUserId(String userId) async {
    // Check local cache first
    final cachedProfile = await _localDataSource.getProfileById(userId);
    if (cachedProfile != null && !await _networkInfo.isConnected) {
      return (data: cachedProfile.toEntity(), failure: null);
    }

    if (!await _networkInfo.isConnected) {
      return (data: cachedProfile?.toEntity(), failure: const NetworkFailure());
    }

    try {
      final profileModel = await _remoteDataSource.getProfileByUserId(userId);
      // Cache the profile
      await _localDataSource.saveProfileById(userId, profileModel);
      return (data: profileModel.toEntity(), failure: null);
    } catch (e) {
      if (cachedProfile != null) {
        return (data: cachedProfile.toEntity(), failure: _mapExceptionToFailure(e));
      }
      return (data: null, failure: _mapExceptionToFailure(e));
    }
  }

  @override
  Future<({Profile? data, Failure? failure})> getProfileByUsername(String username) async {
    if (!await _networkInfo.isConnected) {
      return (data: null, failure: const NetworkFailure());
    }

    try {
      final profileModel = await _remoteDataSource.getProfileByUsername(username);
      return (data: profileModel.toEntity(), failure: null);
    } catch (e) {
      return (data: null, failure: _mapExceptionToFailure(e));
    }
  }

  @override
  Future<({Profile? data, Failure? failure})> updateProfile(ProfileUpdateData data) async {
    if (!await _networkInfo.isConnected) {
      return (data: null, failure: const NetworkFailure());
    }

    if (data.isEmpty) {
      return (data: _currentProfile, failure: null);
    }

    try {
      final profileModel = await _remoteDataSource.updateProfile(data);
      _currentProfile = profileModel.toEntity();

      // Update cache
      await _localDataSource.saveProfile(profileModel);
      _profileController.add(_currentProfile);

      return (data: _currentProfile, failure: null);
    } catch (e) {
      return (data: null, failure: _mapExceptionToFailure(e));
    }
  }

  @override
  Future<({Profile? data, Failure? failure})> updateProfilePhoto(String imagePath) async {
    if (!await _networkInfo.isConnected) {
      return (data: null, failure: const NetworkFailure());
    }

    try {
      final profileModel = await _remoteDataSource.updateProfilePhoto(imagePath);
      _currentProfile = profileModel.toEntity();

      // Update cache
      await _localDataSource.saveProfile(profileModel);
      _profileController.add(_currentProfile);

      return (data: _currentProfile, failure: null);
    } catch (e) {
      return (data: null, failure: _mapExceptionToFailure(e));
    }
  }

  @override
  Future<({Profile? data, Failure? failure})> updateCoverPhoto(String imagePath) async {
    if (!await _networkInfo.isConnected) {
      return (data: null, failure: const NetworkFailure());
    }

    try {
      final profileModel = await _remoteDataSource.updateCoverPhoto(imagePath);
      _currentProfile = profileModel.toEntity();

      // Update cache
      await _localDataSource.saveProfile(profileModel);
      _profileController.add(_currentProfile);

      return (data: _currentProfile, failure: null);
    } catch (e) {
      return (data: null, failure: _mapExceptionToFailure(e));
    }
  }

  @override
  Future<({Profile? data, Failure? failure})> removeProfilePhoto() async {
    if (!await _networkInfo.isConnected) {
      return (data: null, failure: const NetworkFailure());
    }

    try {
      final profileModel = await _remoteDataSource.removeProfilePhoto();
      _currentProfile = profileModel.toEntity();

      // Update cache
      await _localDataSource.saveProfile(profileModel);
      _profileController.add(_currentProfile);

      return (data: _currentProfile, failure: null);
    } catch (e) {
      return (data: null, failure: _mapExceptionToFailure(e));
    }
  }

  @override
  Future<({Profile? data, Failure? failure})> removeCoverPhoto() async {
    if (!await _networkInfo.isConnected) {
      return (data: null, failure: const NetworkFailure());
    }

    try {
      final profileModel = await _remoteDataSource.removeCoverPhoto();
      _currentProfile = profileModel.toEntity();

      // Update cache
      await _localDataSource.saveProfile(profileModel);
      _profileController.add(_currentProfile);

      return (data: _currentProfile, failure: null);
    } catch (e) {
      return (data: null, failure: _mapExceptionToFailure(e));
    }
  }

  // ==================== Preferences ====================

  @override
  Future<({ProfilePreferences? data, Failure? failure})> getPreferences() async {
    // Check local cache first
    final cachedPrefs = await _localDataSource.getPreferences();
    if (!await _networkInfo.isConnected) {
      if (cachedPrefs != null) {
        return (data: cachedPrefs, failure: null);
      }
      return (data: null, failure: const NetworkFailure());
    }

    try {
      final prefsModel = await _remoteDataSource.getPreferences();
      // Cache preferences
      await _localDataSource.savePreferences(prefsModel);
      return (data: prefsModel, failure: null);
    } catch (e) {
      if (cachedPrefs != null) {
        return (data: cachedPrefs, failure: _mapExceptionToFailure(e));
      }
      return (data: null, failure: _mapExceptionToFailure(e));
    }
  }

  @override
  Future<({ProfilePreferences? data, Failure? failure})> updatePreferences(
    ProfilePreferences preferences,
  ) async {
    if (!await _networkInfo.isConnected) {
      return (data: null, failure: const NetworkFailure());
    }

    try {
      final prefsModel = await _remoteDataSource.updatePreferences(preferences);
      // Update cache
      await _localDataSource.savePreferences(prefsModel);
      return (data: prefsModel, failure: null);
    } catch (e) {
      return (data: null, failure: _mapExceptionToFailure(e));
    }
  }

  // ==================== Social ====================

  @override
  Future<({bool? data, Failure? failure})> followUser(String userId) async {
    if (!await _networkInfo.isConnected) {
      return (data: null, failure: const NetworkFailure());
    }

    try {
      await _remoteDataSource.followUser(userId);
      return (data: true, failure: null);
    } catch (e) {
      return (data: null, failure: _mapExceptionToFailure(e));
    }
  }

  @override
  Future<({bool? data, Failure? failure})> unfollowUser(String userId) async {
    if (!await _networkInfo.isConnected) {
      return (data: null, failure: const NetworkFailure());
    }

    try {
      await _remoteDataSource.unfollowUser(userId);
      return (data: true, failure: null);
    } catch (e) {
      return (data: null, failure: _mapExceptionToFailure(e));
    }
  }

  @override
  Future<({List<Profile>? data, Failure? failure})> getFollowers(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    if (!await _networkInfo.isConnected) {
      return (data: null, failure: const NetworkFailure());
    }

    try {
      final profileModels = await _remoteDataSource.getFollowers(userId, page: page, limit: limit);
      final profiles = profileModels.map((m) => m.toEntity()).toList();
      return (data: profiles, failure: null);
    } catch (e) {
      return (data: null, failure: _mapExceptionToFailure(e));
    }
  }

  @override
  Future<({List<Profile>? data, Failure? failure})> getFollowing(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    if (!await _networkInfo.isConnected) {
      return (data: null, failure: const NetworkFailure());
    }

    try {
      final profileModels = await _remoteDataSource.getFollowing(userId, page: page, limit: limit);
      final profiles = profileModels.map((m) => m.toEntity()).toList();
      return (data: profiles, failure: null);
    } catch (e) {
      return (data: null, failure: _mapExceptionToFailure(e));
    }
  }

  @override
  Future<({bool? data, Failure? failure})> isFollowing(String userId) async {
    if (!await _networkInfo.isConnected) {
      return (data: null, failure: const NetworkFailure());
    }

    try {
      final isFollowing = await _remoteDataSource.isFollowing(userId);
      return (data: isFollowing, failure: null);
    } catch (e) {
      return (data: null, failure: _mapExceptionToFailure(e));
    }
  }

  // ==================== Account ====================

  @override
  Future<({bool? data, Failure? failure})> deleteAccount(String password) async {
    if (!await _networkInfo.isConnected) {
      return (data: null, failure: const NetworkFailure());
    }

    try {
      await _remoteDataSource.deleteAccount(password);
      // Clear all local data
      await _localDataSource.clearAll();
      _currentProfile = null;
      _profileController.add(null);
      return (data: true, failure: null);
    } catch (e) {
      return (data: null, failure: _mapExceptionToFailure(e));
    }
  }

  @override
  Future<({String? data, Failure? failure})> exportUserData() async {
    if (!await _networkInfo.isConnected) {
      return (data: null, failure: const NetworkFailure());
    }

    try {
      final downloadUrl = await _remoteDataSource.exportUserData();
      return (data: downloadUrl, failure: null);
    } catch (e) {
      return (data: null, failure: _mapExceptionToFailure(e));
    }
  }

  // ==================== Cache ====================

  @override
  Future<Profile?> getCachedProfile() async {
    final cached = await _localDataSource.getProfile();
    return cached?.toEntity();
  }

  @override
  Future<void> cacheProfile(Profile profile) async {
    final model = ProfileModel.fromEntity(profile);
    await _localDataSource.saveProfile(model);
  }

  @override
  Future<void> clearCache() async {
    await _localDataSource.clearAll();
    _currentProfile = null;
    _profileController.add(null);
  }

  // ==================== Private Helpers ====================

  Failure _mapExceptionToFailure(dynamic exception) {
    final message = exception.toString();

    if (message.contains('401') || message.contains('Unauthorized')) {
      return const UnauthenticatedFailure();
    }
    if (message.contains('403') || message.contains('Forbidden')) {
      return const UnauthorizedFailure(
        message: 'You do not have permission to access this profile',
      );
    }
    if (message.contains('404') || message.contains('Not Found')) {
      return const NotFoundFailure(message: 'Profile not found');
    }
    if (message.contains('409') || message.contains('Conflict')) {
      return const ConflictFailure(message: 'A conflict occurred while updating profile');
    }
    if (message.contains('timeout')) {
      return const TimeoutFailure();
    }
    if (message.contains('413') || message.contains('too large')) {
      return const ValidationFailure(message: 'File size is too large');
    }
    if (message.contains('415') || message.contains('Unsupported Media')) {
      return const ValidationFailure(message: 'Unsupported file format');
    }

    return UnexpectedFailure(message: 'An unexpected error occurred', exception: exception);
  }

  /// Disposes the repository and closes streams.
  void dispose() {
    _profileController.close();
  }
}
