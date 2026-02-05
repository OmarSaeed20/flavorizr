import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for updating driver profile image.
@immutable
class UpdateProfileImageParameters extends Parameters {
  final String _profileImage;
  final CancelToken? _cancelToken;

  const UpdateProfileImageParameters._({
    required String profileImage,
    CancelToken? cancelToken,
  }) : _profileImage = profileImage,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {'profile_image': _profileImage};
  }

  String get profileImage => _profileImage;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static UpdateProfileImageParametersBuilder builder() =>
      UpdateProfileImageParametersBuilder();
}

/// Builder for UpdateProfileImageParameters
class UpdateProfileImageParametersBuilder
    extends ParametersBuilder<UpdateProfileImageParameters> {
  String? _profileImage;
  CancelToken? _cancelToken;

  /// Set the profile image
  UpdateProfileImageParametersBuilder withProfileImage(String profileImage) {
    _profileImage = profileImage;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  UpdateProfileImageParametersBuilder withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the UpdateProfileImageParameters
  @override
  UpdateProfileImageParameters build() {
    if (_profileImage == null) {
      throw ArgumentError('Profile image is required');
    }
    return UpdateProfileImageParameters._(
      profileImage: _profileImage!,
      cancelToken: _cancelToken,
    );
  }
}
