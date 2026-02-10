import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/domain/entities/driver_credentials.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/domain/repositories/driver_auth_repository.dart';

/// Use case for driver login.
class DriverLoginUseCase {
  final DriverAuthRepository _repository;

  DriverLoginUseCase(this._repository);

  /// Executes the driver login use case.
  Future<ApiResult<DriverCredentials>> call({required String phone, required String password}) {
    return _repository.login(phone: phone, password: password);
  }
}
