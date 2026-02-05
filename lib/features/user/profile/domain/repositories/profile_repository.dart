// lib/features/profile/domain/repositories/profile_repository.dart
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/profile/domain/entities/profile.dart';

/// Repository interface for profile operations.
///
/// Defines the contract for profile data operations as per FAST API specification.
abstract class ProfileRepository {
  /// Gets the current user's profile.
  ///
  /// Returns the profile if found, or a failure if not authenticated
  /// or profile doesn't exist.
  Future<ApiResult<Profile>> getProfile();

  /// Gets detailed profile information.
  ///
  /// Returns detailed profile data including additional information.
  Future<ApiResult<Profile>> getProfileDetail();

  /// Updates the current user's profile information.
  ///
  /// Only authenticated users can update their own profile.
  Future<ApiResult<Profile>> updateProfileInfo(ProfileUpdateData data);

  /// Gets reviews for a specific driver.
  ///
  /// Returns a list of reviews for the specified driver.
  Future<ApiResult<List<DriverReview>>> getDriverReviews(String driverId);
}

/// Data class for driver review.
class DriverReview {
  const DriverReview({
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
}
