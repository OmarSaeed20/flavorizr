// lib/features/company/company_profile/data/parameters/update_company_profile_image_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Update Company Profile Image API parameters
///
/// Used to update company profile image.
/// Based on API_DOCUMENTATION.md
class UpdateCompanyProfileImageParameters extends Parameters {
  final String imagePath;
  @override
  final CancelToken? cancelToken;

  const UpdateCompanyProfileImageParameters({required this.imagePath, this.cancelToken});

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {'imagePath': imagePath};

  /// Convert to FormData for API request
  FormData toFormData() {
    return FormData.fromMap({'image': MultipartFile.fromFileSync(imagePath)});
  }

  /// Create a builder for this parameters type
  UpdateCompanyProfileImageParametersBuilder builder() =>
      UpdateCompanyProfileImageParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdateCompanyProfileImageParameters &&
        other.imagePath == imagePath &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode => imagePath.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'UpdateCompanyProfileImageParameters(imagePath: $imagePath, cancelToken: $cancelToken)';
}

/// Builder for UpdateCompanyProfileImageParameters
class UpdateCompanyProfileImageParametersBuilder
    extends ParametersBuilder<UpdateCompanyProfileImageParameters> {
  String? _imagePath;
  CancelToken? _cancelToken;

  /// Set the image path
  UpdateCompanyProfileImageParametersBuilder imagePath(String imagePath) {
    _imagePath = imagePath;
    return this;
  }

  /// Set the cancel token
  UpdateCompanyProfileImageParametersBuilder cancelToken(CancelToken cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ParametersBuilder<UpdateCompanyProfileImageParameters> withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  UpdateCompanyProfileImageParameters build() {
    return UpdateCompanyProfileImageParameters(imagePath: _imagePath!, cancelToken: _cancelToken);
  }
}
