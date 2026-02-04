import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver_profile/domain/entities/driver_profile.dart';
import 'package:flavorizr/features/driver_profile/domain/repositories/driver_profile_repository.dart';

/// Use case for getting driver profile.
class GetDriverProfileUseCase {
  final DriverProfileRepository _repository;

  GetDriverProfileUseCase(this._repository);

  /// Executes the get driver profile use case.
  Future<ApiResult<DriverProfile>> call() {
    return _repository.getDriverProfile();
  }
}