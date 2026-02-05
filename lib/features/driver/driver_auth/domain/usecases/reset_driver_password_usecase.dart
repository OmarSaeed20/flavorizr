import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_auth/domain/repositories/driver_auth_repository.dart';

/// Use case for resetting driver password.
class ResetDriverPasswordUseCase {
  final DriverAuthRepository _repository;

  ResetDriverPasswordUseCase(this._repository);

  /// Executes the reset driver password use case.
  Future<ApiResult<void>> call({
    required String phone,
    required String newPassword,
    required String otp,
  }) {
    return _repository.resetPassword(
      phone: phone,
      newPassword: newPassword,
      otp: otp,
    );
  }
}