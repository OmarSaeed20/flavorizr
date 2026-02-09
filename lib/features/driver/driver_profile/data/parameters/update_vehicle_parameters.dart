import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for updating driver vehicle information.
///
/// Based on the FAST App API documentation for POST /driver/vehicle/update
@immutable
class UpdateVehicleParameters extends Parameters {
  final int? _vehicleTypeId;
  final String? _vehiclePlateNumber;
  final String? _vehicleImage;
  final String? _vehicleLicenseImage;
  final CancelToken? _cancelToken;

  const UpdateVehicleParameters._({
    int? vehicleTypeId,
    String? vehiclePlateNumber,
    String? vehicleImage,
    String? vehicleLicenseImage,
    CancelToken? cancelToken,
  }) : _vehicleTypeId = vehicleTypeId,
       _vehiclePlateNumber = vehiclePlateNumber,
       _vehicleImage = vehicleImage,
       _vehicleLicenseImage = vehicleLicenseImage,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {
      if (_vehicleTypeId != null) 'vehicle_type_id': _vehicleTypeId,
      if (_vehiclePlateNumber != null) 'vehicle_plate_number': _vehiclePlateNumber,
      if (_vehicleImage != null) 'vehicle_image': _vehicleImage,
      if (_vehicleLicenseImage != null) 'vehicle_license_image': _vehicleLicenseImage,
    };
  }

  int? get vehicleTypeId => _vehicleTypeId;
  String? get vehiclePlateNumber => _vehiclePlateNumber;
  String? get vehicleImage => _vehicleImage;
  String? get vehicleLicenseImage => _vehicleLicenseImage;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static UpdateVehicleParametersBuilder builder() => UpdateVehicleParametersBuilder();
}

/// Builder for UpdateVehicleParameters
class UpdateVehicleParametersBuilder extends ParametersBuilder<UpdateVehicleParameters> {
  int? _vehicleTypeId;
  String? _vehiclePlateNumber;
  String? _vehicleImage;
  String? _vehicleLicenseImage;
  CancelToken? _cancelToken;

  /// Set the vehicle type ID
  UpdateVehicleParametersBuilder withVehicleTypeId(int vehicleTypeId) {
    _vehicleTypeId = vehicleTypeId;
    return this;
  }

  /// Set the vehicle plate number
  UpdateVehicleParametersBuilder withVehiclePlateNumber(String vehiclePlateNumber) {
    _vehiclePlateNumber = vehiclePlateNumber;
    return this;
  }

  /// Set the vehicle image
  UpdateVehicleParametersBuilder withVehicleImage(String vehicleImage) {
    _vehicleImage = vehicleImage;
    return this;
  }

  /// Set the vehicle license image
  UpdateVehicleParametersBuilder withVehicleLicenseImage(String vehicleLicenseImage) {
    _vehicleLicenseImage = vehicleLicenseImage;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  UpdateVehicleParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the UpdateVehicleParameters
  @override
  UpdateVehicleParameters build() {
    return UpdateVehicleParameters._(
      vehicleTypeId: _vehicleTypeId,
      vehiclePlateNumber: _vehiclePlateNumber,
      vehicleImage: _vehicleImage,
      vehicleLicenseImage: _vehicleLicenseImage,
      cancelToken: _cancelToken,
    );
  }
}
