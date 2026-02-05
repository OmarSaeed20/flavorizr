import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_auth/domain/entities/driver_credentials.dart';
import 'package:flavorizr/features/driver/driver_auth/domain/repositories/driver_auth_repository.dart';

/// Use case for verifying driver phone number.
class VerifyDriverPhoneUseCase {
  final DriverAuthRepository _repository;

  VerifyDriverPhoneUseCase(this._repository);

  /// Executes the verify driver phone use case.
  Future<ApiResult<DriverCredentials>> call({
    required String phone,
    required String code,
    required String firebaseToken,
  }) {
    return _repository.verifyPhone(phone: phone, code: code, firebaseToken: firebaseToken);
  }
}
