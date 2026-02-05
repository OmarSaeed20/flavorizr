import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for updating driver vehicle.
@immutable
class UpdateDriverVehicleParameters extends Parameters {
  final String? _make;
  final String? _model;
  final int? _year;
  final String? _color;
  final String? _licensePlate;
  final String? _vehicleType;
  final int? _capacity;
  final String? _vin;
  final String? _registrationNumber;
  final DateTime? _registrationExpiry;
  final CancelToken? _cancelToken;

  const UpdateDriverVehicleParameters._({
    String? make,
    String? model,
    int? year,
    String? color,
    String? licensePlate,
    String? vehicleType,
    int? capacity,
    String? vin,
    String? registrationNumber,
    DateTime? registrationExpiry,
    CancelToken? cancelToken,
  }) : _make = make,
       _model = model,
       _year = year,
       _color = color,
       _licensePlate = licensePlate,
       _vehicleType = vehicleType,
       _capacity = capacity,
       _vin = vin,
       _registrationNumber = registrationNumber,
       _registrationExpiry = registrationExpiry,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {
      if (_make != null) 'make': _make,
      if (_model != null) 'model': _model,
      if (_year != null) 'year': _year,
      if (_color != null) 'color': _color,
      if (_licensePlate != null) 'license_plate': _licensePlate,
      if (_vehicleType != null) 'vehicle_type': _vehicleType,
      if (_capacity != null) 'capacity': _capacity,
      if (_vin != null) 'vin': _vin,
      if (_registrationNumber != null)
        'registration_number': _registrationNumber,
      if (_registrationExpiry != null)
        'registration_expiry': _registrationExpiry!.toIso8601String(),
    };
  }

  String? get make => _make;
  String? get model => _model;
  int? get year => _year;
  String? get color => _color;
  String? get licensePlate => _licensePlate;
  String? get vehicleType => _vehicleType;
  int? get capacity => _capacity;
  String? get vin => _vin;
  String? get registrationNumber => _registrationNumber;
  DateTime? get registrationExpiry => _registrationExpiry;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static UpdateDriverVehicleParametersBuilder builder() =>
      UpdateDriverVehicleParametersBuilder();
}

/// Builder for UpdateDriverVehicleParameters
class UpdateDriverVehicleParametersBuilder
    extends ParametersBuilder<UpdateDriverVehicleParameters> {
  String? _make;
  String? _model;
  int? _year;
  String? _color;
  String? _licensePlate;
  String? _vehicleType;
  int? _capacity;
  String? _vin;
  String? _registrationNumber;
  DateTime? _registrationExpiry;
  CancelToken? _cancelToken;

  /// Set the make
  UpdateDriverVehicleParametersBuilder withMake(String make) {
    _make = make;
    return this;
  }

  /// Set the model
  UpdateDriverVehicleParametersBuilder withModel(String model) {
    _model = model;
    return this;
  }

  /// Set the year
  UpdateDriverVehicleParametersBuilder withYear(int year) {
    _year = year;
    return this;
  }

  /// Set the color
  UpdateDriverVehicleParametersBuilder withColor(String color) {
    _color = color;
    return this;
  }

  /// Set the license plate
  UpdateDriverVehicleParametersBuilder withLicensePlate(String licensePlate) {
    _licensePlate = licensePlate;
    return this;
  }

  /// Set the vehicle type
  UpdateDriverVehicleParametersBuilder withVehicleType(String vehicleType) {
    _vehicleType = vehicleType;
    return this;
  }

  /// Set the capacity
  UpdateDriverVehicleParametersBuilder withCapacity(int capacity) {
    _capacity = capacity;
    return this;
  }

  /// Set the VIN
  UpdateDriverVehicleParametersBuilder withVin(String vin) {
    _vin = vin;
    return this;
  }

  /// Set the registration number
  UpdateDriverVehicleParametersBuilder withRegistrationNumber(
    String registrationNumber,
  ) {
    _registrationNumber = registrationNumber;
    return this;
  }

  /// Set the registration expiry
  UpdateDriverVehicleParametersBuilder withRegistrationExpiry(
    DateTime registrationExpiry,
  ) {
    _registrationExpiry = registrationExpiry;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  UpdateDriverVehicleParametersBuilder withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the UpdateDriverVehicleParameters
  @override
  UpdateDriverVehicleParameters build() {
    return UpdateDriverVehicleParameters._(
      make: _make,
      model: _model,
      year: _year,
      color: _color,
      licensePlate: _licensePlate,
      vehicleType: _vehicleType,
      capacity: _capacity,
      vin: _vin,
      registrationNumber: _registrationNumber,
      registrationExpiry: _registrationExpiry,
      cancelToken: _cancelToken,
    );
  }
}
