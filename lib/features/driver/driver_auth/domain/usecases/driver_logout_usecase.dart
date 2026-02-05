import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_auth/domain/repositories/driver_auth_repository.dart';

/// Use case for driver logout.
class DriverLogoutUseCase {
  final DriverAuthRepository _repository;

  DriverLogoutUseCase(this._repository);

  /// Executes the driver logout use case.
  Future<ApiResult<void>> call() {
    return _repository.logout();
  }
}