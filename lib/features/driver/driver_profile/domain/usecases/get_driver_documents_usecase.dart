import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_profile/domain/entities/driver_document.dart';
import 'package:flavorizr/features/driver/driver_profile/domain/repositories/driver_profile_repository.dart';

/// Use case for getting driver documents.
class GetDriverDocumentsUseCase {
  final DriverProfileRepository _repository;

  GetDriverDocumentsUseCase(this._repository);

  /// Executes the get driver documents use case.
  Future<ApiResult<List<DriverDocument>>> call() {
    return _repository.getDriverDocuments();
  }
}