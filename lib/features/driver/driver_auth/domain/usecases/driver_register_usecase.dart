import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_auth/domain/entities/driver_credentials.dart';
import 'package:flavorizr/features/driver/driver_auth/domain/repositories/driver_auth_repository.dart';

/// Use case for driver registration.
class DriverRegisterUseCase {
  final DriverAuthRepository _repository;

  DriverRegisterUseCase(this._repository);

  /// Executes the driver registration use case.
  Future<ApiResult<DriverCredentials>> call({
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
  }) {
    return _repository.register(
      phone: phone,
      password: password,
      passwordConfirmation: passwordConfirmation,
      name: name,
      email: email,
      countryId: countryId,
      governorateId: governorateId,
      cityId: cityId,
      birthdate: birthdate,
      gender: gender,
      nationalId: nationalId,
      nationalIdImage: nationalIdImage,
      drivingLicenseImage: drivingLicenseImage,
      vehicleLicenseImage: vehicleLicenseImage,
      vehicleImage: vehicleImage,
      vehicleTypeId: vehicleTypeId,
      vehiclePlateNumber: vehiclePlateNumber,
    );
  }
}
