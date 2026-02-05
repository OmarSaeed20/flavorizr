import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_auth/domain/entities/driver_credentials.dart';
import 'package:flavorizr/features/driver/driver_auth/domain/repositories/driver_auth_repository.dart';

/// Use case for driver registration.
class DriverRegisterUseCase {
  final DriverAuthRepository _repository;

  DriverRegisterUseCase(this._repository);

  /// Executes the driver registration use case.
  Future<ApiResult<DriverCredentials>> call({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    String? profileImage,
  }) {
    return _repository.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      password: password,
      profileImage: profileImage,
    );
  }
}