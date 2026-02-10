// lib/features/profile/data/datasources/profile_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/core/network/api_client.dart';
import 'package:fast_golden_taxi/core/network/api_endpoints.dart';
import 'package:fast_golden_taxi/core/network/base/datasource/base_data_source.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/profile/data/models/profile_model.dart';
import 'package:fast_golden_taxi/features/user/profile/domain/entities/profile.dart';

/// Remote data source for profile operations.
///
/// Handles all HTTP requests related to profile management.
/// Throws exceptions on errors which are caught by the repository.
abstract class ProfileRemoteDataSource {
  /// Gets the current user's profile.
  Future<ApiResult<ProfileModel>> getProfile();

  /// Gets detailed profile information.
  Future<ApiResult<ProfileModel>> getProfileDetail();

  /// Updates the current user's profile information.
  Future<ApiResult<ProfileModel>> updateProfileInfo(ProfileUpdateData data);

  /// Gets reviews for a specific driver.
  Future<ApiResult<List<DriverReviewModel>>> getDriverReviews(String driverId);
}

/// Implementation of [ProfileRemoteDataSource] using BaseRemoteDataSource.
class ProfileRemoteDataSourceImpl with BaseRemoteDataSource implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  @override
  Future<ApiResult<ProfileModel>> getProfile() async {
    return get<ProfileModel>(
      path: ApiEndpoints.userProfile,
      decoder: (data) => ProfileModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<ProfileModel>> getProfileDetail() async {
    return get<ProfileModel>(
      path: ApiEndpoints.userProfileDetail,
      decoder: (data) => ProfileModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<ProfileModel>> updateProfileInfo(ProfileUpdateData data) async {
    return post<ProfileModel>(
      path: ApiEndpoints.updateProfileInfo,
      data: data.toJson(),
      decoder: (responseData) => ProfileModel.fromJson(responseData as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<List<DriverReviewModel>>> getDriverReviews(String driverId) async {
    return get<List<DriverReviewModel>>(
      path: ApiEndpoints.driverReviews,
      queryParameters: {'driver_id': driverId},
      decoder: (data) {
        final jsonData = data as Map<String, dynamic>;
        final items = (jsonData['data'] as List? ?? [])
            .map((e) => DriverReviewModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return items;
      },
    );
  }
}

/// Model for driver review.
class DriverReviewModel {
  const DriverReviewModel({
    required this.id,
    required this.userId,
    required this.driverId,
    required this.rating,
    this.comment,
    this.createdAt,
  });

  final int id;
  final int userId;
  final int driverId;
  final int rating;
  final String? comment;
  final DateTime? createdAt;

  factory DriverReviewModel.fromJson(Map<String, dynamic> json) {
    return DriverReviewModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      driverId: json['driver_id'] as int,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'driver_id': driverId,
      'rating': rating,
      if (comment != null) 'comment': comment,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}
