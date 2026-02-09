import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for submitting driver verification.
@immutable
class SubmitVerificationParameters extends Parameters {
  final String? _nationalId;
  final String? _nationalIdImage;
  final String? _drivingLicenseImage;
  final String? _vehicleLicenseImage;
  final String? _vehicleImage;
  final CancelToken? _cancelToken;

  const SubmitVerificationParameters._({
    String? nationalId,
    String? nationalIdImage,
    String? drivingLicenseImage,
    String? vehicleLicenseImage,
    String? vehicleImage,
    CancelToken? cancelToken,
  }) : _nationalId = nationalId,
       _nationalIdImage = nationalIdImage,
       _drivingLicenseImage = drivingLicenseImage,
       _vehicleLicenseImage = vehicleLicenseImage,
       _vehicleImage = vehicleImage,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {
      if (_nationalId != null) 'national_id': _nationalId,
      if (_nationalIdImage != null) 'national_id_image': _nationalIdImage,
      if (_drivingLicenseImage != null) 'driving_license_image': _drivingLicenseImage,
      if (_vehicleLicenseImage != null) 'vehicle_license_image': _vehicleLicenseImage,
      if (_vehicleImage != null) 'vehicle_image': _vehicleImage,
    };
  }

  String? get nationalId => _nationalId;
  String? get nationalIdImage => _nationalIdImage;
  String? get drivingLicenseImage => _drivingLicenseImage;
  String? get vehicleLicenseImage => _vehicleLicenseImage;
  String? get vehicleImage => _vehicleImage;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static SubmitVerificationParametersBuilder builder() => SubmitVerificationParametersBuilder();
}

/// Builder for SubmitVerificationParameters
class SubmitVerificationParametersBuilder extends ParametersBuilder<SubmitVerificationParameters> {
  String? _nationalId;
  String? _nationalIdImage;
  String? _drivingLicenseImage;
  String? _vehicleLicenseImage;
  String? _vehicleImage;
  CancelToken? _cancelToken;

  /// Set the national ID
  SubmitVerificationParametersBuilder withNationalId(String nationalId) {
    _nationalId = nationalId;
    return this;
  }

  /// Set the national ID image
  SubmitVerificationParametersBuilder withNationalIdImage(String nationalIdImage) {
    _nationalIdImage = nationalIdImage;
    return this;
  }

  /// Set the driving license image
  SubmitVerificationParametersBuilder withDrivingLicenseImage(String drivingLicenseImage) {
    _drivingLicenseImage = drivingLicenseImage;
    return this;
  }

  /// Set the vehicle license image
  SubmitVerificationParametersBuilder withVehicleLicenseImage(String vehicleLicenseImage) {
    _vehicleLicenseImage = vehicleLicenseImage;
    return this;
  }

  /// Set the vehicle image
  SubmitVerificationParametersBuilder withVehicleImage(String vehicleImage) {
    _vehicleImage = vehicleImage;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  SubmitVerificationParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the SubmitVerificationParameters
  @override
  SubmitVerificationParameters build() {
    return SubmitVerificationParameters._(
      nationalId: _nationalId,
      nationalIdImage: _nationalIdImage,
      drivingLicenseImage: _drivingLicenseImage,
      vehicleLicenseImage: _vehicleLicenseImage,
      vehicleImage: _vehicleImage,
      cancelToken: _cancelToken,
    );
  }
}
