import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for uploading driver document.
///
/// Based on the FAST App API documentation for POST /driver/documents/upload
@immutable
class UploadDocumentParameters extends Parameters {
  final String _documentType;
  final String _documentImage;
  final CancelToken? _cancelToken;

  const UploadDocumentParameters._({
    required String documentType,
    required String documentImage,
    CancelToken? cancelToken,
  }) : _documentType = documentType,
       _documentImage = documentImage,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {'document_type': _documentType, 'document_image': _documentImage};
  }

  String get documentType => _documentType;
  String get documentImage => _documentImage;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static UploadDocumentParametersBuilder builder() =>
      UploadDocumentParametersBuilder();
}

/// Builder for UploadDocumentParameters
class UploadDocumentParametersBuilder
    extends ParametersBuilder<UploadDocumentParameters> {
  String? _documentType;
  String? _documentImage;
  CancelToken? _cancelToken;

  /// Set the document type
  UploadDocumentParametersBuilder withDocumentType(String documentType) {
    _documentType = documentType;
    return this;
  }

  /// Set the document image
  UploadDocumentParametersBuilder withDocumentImage(String documentImage) {
    _documentImage = documentImage;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  UploadDocumentParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the UploadDocumentParameters
  @override
  UploadDocumentParameters build() {
    if (_documentType == null) {
      throw ArgumentError('Document type is required');
    }
    if (_documentImage == null) {
      throw ArgumentError('Document image is required');
    }
    return UploadDocumentParameters._(
      documentType: _documentType!,
      documentImage: _documentImage!,
      cancelToken: _cancelToken,
    );
  }
}
