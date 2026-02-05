import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for driver registration.
///
/// Based on the FAST App API documentation for POST /driver/auth/register
@immutable
class DriverRegisterParameters extends Parameters {
  final String _phone;
  final String _password;
  final String _passwordConfirmation;
  final String _name;
  final String _email;
  final int _countryId;
  final int _governorateId;
  final int _cityId;
  final String _birthdate;
  final String _gender;
  final String _nationalId;
  final String _nationalIdImage;
  final String _drivingLicenseImage;
  final String _vehicleLicenseImage;
  final String _vehicleImage;
  final int _vehicleTypeId;
  final String _vehiclePlateNumber;
  final CancelToken? _cancelToken;

  const DriverRegisterParameters._({
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String name,
    required String email,
    required int countryId,
    required int governorateId,
    required int cityId,
    required String birthdate,
    required String gender,
    required String nationalId,
    required String nationalIdImage,
    required String drivingLicenseImage,
    required String vehicleLicenseImage,
    required String vehicleImage,
    required int vehicleTypeId,
    required String vehiclePlateNumber,
    CancelToken? cancelToken,
  }) : _phone = phone,
       _password = password,
       _passwordConfirmation = passwordConfirmation,
       _name = name,
       _email = email,
       _countryId = countryId,
       _governorateId = governorateId,
       _cityId = cityId,
       _birthdate = birthdate,
       _gender = gender,
       _nationalId = nationalId,
       _nationalIdImage = nationalIdImage,
       _drivingLicenseImage = drivingLicenseImage,
       _vehicleLicenseImage = vehicleLicenseImage,
       _vehicleImage = vehicleImage,
       _vehicleTypeId = vehicleTypeId,
       _vehiclePlateNumber = vehiclePlateNumber,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {
      'phone': _phone,
      'password': _password,
      'password_confirmation': _passwordConfirmation,
      'name': _name,
      'email': _email,
      'country_id': _countryId,
      'governorate_id': _governorateId,
      'city_id': _cityId,
      'birthdate': _birthdate,
      'gender': _gender,
      'national_id': _nationalId,
      'national_id_image': _nationalIdImage,
      'driving_license_image': _drivingLicenseImage,
      'vehicle_license_image': _vehicleLicenseImage,
      'vehicle_image': _vehicleImage,
      'vehicle_type_id': _vehicleTypeId,
      'vehicle_plate_number': _vehiclePlateNumber,
    };
  }

  String get phone => _phone;
  String get password => _password;
  String get passwordConfirmation => _passwordConfirmation;
  String get name => _name;
  String get email => _email;
  int get countryId => _countryId;
  int get governorateId => _governorateId;
  int get cityId => _cityId;
  String get birthdate => _birthdate;
  String get gender => _gender;
  String get nationalId => _nationalId;
  String get nationalIdImage => _nationalIdImage;
  String get drivingLicenseImage => _drivingLicenseImage;
  String get vehicleLicenseImage => _vehicleLicenseImage;
  String get vehicleImage => _vehicleImage;
  int get vehicleTypeId => _vehicleTypeId;
  String get vehiclePlateNumber => _vehiclePlateNumber;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static DriverRegisterParametersBuilder builder() =>
      DriverRegisterParametersBuilder();
}

/// Builder for DriverRegisterParameters
class DriverRegisterParametersBuilder
    extends ParametersBuilder<DriverRegisterParameters> {
  String? _phone;
  String? _password;
  String? _passwordConfirmation;
  String? _name;
  String? _email;
  int? _countryId;
  int? _governorateId;
  int? _cityId;
  String? _birthdate;
  String? _gender;
  String? _nationalId;
  String? _nationalIdImage;
  String? _drivingLicenseImage;
  String? _vehicleLicenseImage;
  String? _vehicleImage;
  int? _vehicleTypeId;
  String? _vehiclePlateNumber;
  CancelToken? _cancelToken;

  /// Set the phone number
  DriverRegisterParametersBuilder withPhone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the password
  DriverRegisterParametersBuilder withPassword(String password) {
    _password = password;
    return this;
  }

  /// Set the password confirmation
  DriverRegisterParametersBuilder withPasswordConfirmation(
    String passwordConfirmation,
  ) {
    _passwordConfirmation = passwordConfirmation;
    return this;
  }

  /// Set the driver's full name
  DriverRegisterParametersBuilder withName(String name) {
    _name = name;
    return this;
  }

  /// Set the email
  DriverRegisterParametersBuilder withEmail(String email) {
    _email = email;
    return this;
  }

  /// Set the country ID
  DriverRegisterParametersBuilder withCountryId(int countryId) {
    _countryId = countryId;
    return this;
  }

  /// Set the governorate ID
  DriverRegisterParametersBuilder withGovernorateId(int governorateId) {
    _governorateId = governorateId;
    return this;
  }

  /// Set the city ID
  DriverRegisterParametersBuilder withCityId(int cityId) {
    _cityId = cityId;
    return this;
  }

  /// Set the birthdate (format: YYYY-MM-DD)
  DriverRegisterParametersBuilder withBirthdate(String birthdate) {
    _birthdate = birthdate;
    return this;
  }

  /// Set the gender (male or female)
  DriverRegisterParametersBuilder withGender(String gender) {
    _gender = gender;
    return this;
  }

  /// Set the national ID
  DriverRegisterParametersBuilder withNationalId(String nationalId) {
    _nationalId = nationalId;
    return this;
  }

  /// Set the national ID image (base64)
  DriverRegisterParametersBuilder withNationalIdImage(String nationalIdImage) {
    _nationalIdImage = nationalIdImage;
    return this;
  }

  /// Set the driving license image (base64)
  DriverRegisterParametersBuilder withDrivingLicenseImage(
    String drivingLicenseImage,
  ) {
    _drivingLicenseImage = drivingLicenseImage;
    return this;
  }

  /// Set the vehicle license image (base64)
  DriverRegisterParametersBuilder withVehicleLicenseImage(
    String vehicleLicenseImage,
  ) {
    _vehicleLicenseImage = vehicleLicenseImage;
    return this;
  }

  /// Set the vehicle image (base64)
  DriverRegisterParametersBuilder withVehicleImage(String vehicleImage) {
    _vehicleImage = vehicleImage;
    return this;
  }

  /// Set the vehicle type ID
  DriverRegisterParametersBuilder withVehicleTypeId(int vehicleTypeId) {
    _vehicleTypeId = vehicleTypeId;
    return this;
  }

  /// Set the vehicle plate number
  DriverRegisterParametersBuilder withVehiclePlateNumber(
    String vehiclePlateNumber,
  ) {
    _vehiclePlateNumber = vehiclePlateNumber;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  DriverRegisterParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the DriverRegisterParameters
  @override
  DriverRegisterParameters build() {
    if (_phone == null) {
      throw ArgumentError('Phone is required');
    }
    if (_password == null) {
      throw ArgumentError('Password is required');
    }
    if (_passwordConfirmation == null) {
      throw ArgumentError('Password confirmation is required');
    }
    if (_name == null) {
      throw ArgumentError('Name is required');
    }
    if (_email == null) {
      throw ArgumentError('Email is required');
    }
    if (_countryId == null) {
      throw ArgumentError('Country ID is required');
    }
    if (_governorateId == null) {
      throw ArgumentError('Governorate ID is required');
    }
    if (_cityId == null) {
      throw ArgumentError('City ID is required');
    }
    if (_birthdate == null) {
      throw ArgumentError('Birthdate is required');
    }
    if (_gender == null) {
      throw ArgumentError('Gender is required');
    }
    if (_nationalId == null) {
      throw ArgumentError('National ID is required');
    }
    if (_nationalIdImage == null) {
      throw ArgumentError('National ID image is required');
    }
    if (_drivingLicenseImage == null) {
      throw ArgumentError('Driving license image is required');
    }
    if (_vehicleLicenseImage == null) {
      throw ArgumentError('Vehicle license image is required');
    }
    if (_vehicleImage == null) {
      throw ArgumentError('Vehicle image is required');
    }
    if (_vehicleTypeId == null) {
      throw ArgumentError('Vehicle type ID is required');
    }
    if (_vehiclePlateNumber == null) {
      throw ArgumentError('Vehicle plate number is required');
    }
    return DriverRegisterParameters._(
      phone: _phone!,
      password: _password!,
      passwordConfirmation: _passwordConfirmation!,
      name: _name!,
      email: _email!,
      countryId: _countryId!,
      governorateId: _governorateId!,
      cityId: _cityId!,
      birthdate: _birthdate!,
      gender: _gender!,
      nationalId: _nationalId!,
      nationalIdImage: _nationalIdImage!,
      drivingLicenseImage: _drivingLicenseImage!,
      vehicleLicenseImage: _vehicleLicenseImage!,
      vehicleImage: _vehicleImage!,
      vehicleTypeId: _vehicleTypeId!,
      vehiclePlateNumber: _vehiclePlateNumber!,
      cancelToken: _cancelToken,
    );
  }
}
