import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/entities/driver_document.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/repositories/driver_profile_repository.dart';

/// Use case for uploading driver document.
class UploadDriverDocumentUseCase {
  final DriverProfileRepository _repository;

  UploadDriverDocumentUseCase(this._repository);

  /// Executes the upload driver document use case.
  Future<ApiResult<DriverDocument>> call({
    required String documentType,
    required String documentImage,
  }) {
    return _repository.uploadDocument(documentType: documentType, documentImage: documentImage);
  }
}
