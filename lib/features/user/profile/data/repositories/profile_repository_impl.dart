// lib/features/profile/data/repositories/profile_repository_impl.dart
import 'package:flavorizr/core/network/base/repo/base_repository.dart';
import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/profile/data/datasources/profile_local_datasource.dart';
import 'package:flavorizr/features/user/profile/data/datasources/profile_remote_datasource.dart';
import 'package:flavorizr/features/user/profile/data/models/profile_model.dart';
import 'package:flavorizr/features/user/profile/domain/entities/profile.dart';
import 'package:flavorizr/features/user/profile/domain/repositories/profile_repository.dart';

/// Implementation of [ProfileRepository].
///
/// Coordinates with remote and local data sources for profile operations
/// as per FAST API specification.
class ProfileRepositoryImpl extends BaseRepository
    implements ProfileRepository {
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

  @override
  NetworkInfo get networkInfo => _networkInfo;

  @override
  Future<ApiResult<Profile>> getProfile() async {
    // Try to get from cache first
    final cachedResult = await _localDataSource.getProfile();

    // If cache exists and is valid, return it
    if (cachedResult.isSuccess && cachedResult.data != null) {
      return cachedResult.when(
        success: (profileModel, _) =>
            ApiResult.success(profileModel.toEntity()),
        exception: ApiResult.exception,
      );
    }

    // Fetch from remote
    final result = await executeRemoteRequest<ProfileModel>(
      request: _remoteDataSource.getProfile,
    );

    return result.when(
      success: (profileModel, _) async {
        // Cache the profile
        await _localDataSource.saveProfile(profileModel);
        return ApiResult.success(profileModel.toEntity());
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<Profile>> getProfileDetail() async {
    // Profile detail is always fetched from remote as it may contain updated info
    final result = await executeRemoteRequest<ProfileModel>(
      request: _remoteDataSource.getProfileDetail,
    );

    return result.when(
      success: (profileModel, _) async {
        // Update cache with detailed profile
        await _localDataSource.saveProfile(profileModel);
        return ApiResult.success(profileModel.toEntity());
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<Profile>> updateProfileInfo(ProfileUpdateData data) async {
    final result = await executeRemoteRequest<ProfileModel>(
      request: () => _remoteDataSource.updateProfileInfo(data),
    );

    return result.when(
      success: (profileModel, _) async {
        // Update cache with new profile data
        await _localDataSource.saveProfile(profileModel);
        return ApiResult.success(profileModel.toEntity());
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<List<DriverReview>>> getDriverReviews(
    String driverId,
  ) async {
    // Driver reviews are always fetched from remote
    final result = await executeRemoteRequest<List<DriverReviewModel>>(
      request: () => _remoteDataSource.getDriverReviews(driverId),
    );

    return result.when(
      success: (reviewModels, _) {
        final reviews = reviewModels
            .map(
              (model) => DriverReview(
                id: model.id,
                userId: model.userId,
                driverId: model.driverId,
                rating: model.rating,
                comment: model.comment,
                createdAt: model.createdAt,
              ),
            )
            .toList();
        return ApiResult.success(reviews);
      },
      exception: ApiResult.exception,
    );
  }

  /// Clears the profile cache.
  ///
  /// Call this when user logs out or profile is deleted.
  Future<void> clearProfileCache() async {
    await _localDataSource.clearAll();
  }

  /// Gets the cached profile without fetching from remote.
  ///
  /// Returns null if no cached profile exists.
  Future<ApiResult<Profile?>> getCachedProfile() async {
    final cachedResult = await _localDataSource.getProfile();
    return cachedResult.when(
      success: (profileModel, _) => ApiResult.success(profileModel.toEntity()),
      exception: ApiResult.exception,
    );
  }
}
