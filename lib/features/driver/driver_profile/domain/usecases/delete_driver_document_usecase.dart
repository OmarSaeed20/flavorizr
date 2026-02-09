import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/repositories/driver_profile_repository.dart';

/// Use case for deleting driver document.
class DeleteDriverDocumentUseCase {
  final DriverProfileRepository _repository;

  DeleteDriverDocumentUseCase(this._repository);

  /// Executes the delete driver document use case.
  Future<ApiResult<void>> call(String documentId) {
    return _repository.deleteDocument(documentId);
  }
}
