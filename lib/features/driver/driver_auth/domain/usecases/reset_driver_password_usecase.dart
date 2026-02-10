import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/domain/repositories/driver_auth_repository.dart';

/// Use case for resetting driver password.
class ResetDriverPasswordUseCase {
  final DriverAuthRepository _repository;

  ResetDriverPasswordUseCase(this._repository);

  /// Executes the reset driver password use case.
  Future<ApiResult<void>> call({
    required String code,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) {
    return _repository.resetPassword(
      code: code,
      phone: phone,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}
