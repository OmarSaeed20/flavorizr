import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for deleting a driver document.
@immutable
class DeleteDocumentParameters extends Parameters {
  final String _documentId;
  final CancelToken? _cancelToken;

  const DeleteDocumentParameters._({
    required String documentId,
    CancelToken? cancelToken,
  }) : _documentId = documentId,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {'document_id': _documentId};
  }

  String get documentId => _documentId;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static DeleteDocumentParametersBuilder builder() =>
      DeleteDocumentParametersBuilder();
}

/// Builder for DeleteDocumentParameters
class DeleteDocumentParametersBuilder
    extends ParametersBuilder<DeleteDocumentParameters> {
  String? _documentId;
  CancelToken? _cancelToken;

  /// Set the document ID
  DeleteDocumentParametersBuilder withDocumentId(String documentId) {
    _documentId = documentId;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  DeleteDocumentParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the DeleteDocumentParameters
  @override
  DeleteDocumentParameters build() {
    if (_documentId == null) {
      throw ArgumentError('Document ID is required');
    }
    return DeleteDocumentParameters._(
      documentId: _documentId!,
      cancelToken: _cancelToken,
    );
  }
}
