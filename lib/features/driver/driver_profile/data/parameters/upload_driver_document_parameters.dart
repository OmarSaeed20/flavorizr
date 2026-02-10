import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for uploading driver document.
@immutable
class UploadDriverDocumentParameters extends Parameters {
  final String _documentType;
  final String _documentNumber;
  final String? _frontImageUrl;
  final String? _backImageUrl;
  final DateTime? _expiryDate;
  final CancelToken? _cancelToken;

  const UploadDriverDocumentParameters._({
    required String documentType,
    required String documentNumber,
    String? frontImageUrl,
    String? backImageUrl,
    DateTime? expiryDate,
    CancelToken? cancelToken,
  }) : _documentType = documentType,
       _documentNumber = documentNumber,
       _frontImageUrl = frontImageUrl,
       _backImageUrl = backImageUrl,
       _expiryDate = expiryDate,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {
      'document_type': _documentType,
      'document_number': _documentNumber,
      if (_frontImageUrl != null) 'front_image_url': _frontImageUrl,
      if (_backImageUrl != null) 'back_image_url': _backImageUrl,
      if (_expiryDate != null) 'expiry_date': _expiryDate!.toIso8601String(),
    };
  }

  String get documentType => _documentType;
  String get documentNumber => _documentNumber;
  String? get frontImageUrl => _frontImageUrl;
  String? get backImageUrl => _backImageUrl;
  DateTime? get expiryDate => _expiryDate;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static UploadDriverDocumentParametersBuilder builder() =>
      UploadDriverDocumentParametersBuilder();
}

/// Builder for UploadDriverDocumentParameters
class UploadDriverDocumentParametersBuilder
    extends ParametersBuilder<UploadDriverDocumentParameters> {
  String? _documentType;
  String? _documentNumber;
  String? _frontImageUrl;
  String? _backImageUrl;
  DateTime? _expiryDate;
  CancelToken? _cancelToken;

  /// Set the document type
  UploadDriverDocumentParametersBuilder withDocumentType(String documentType) {
    _documentType = documentType;
    return this;
  }

  /// Set the document number
  UploadDriverDocumentParametersBuilder withDocumentNumber(
    String documentNumber,
  ) {
    _documentNumber = documentNumber;
    return this;
  }

  /// Set the front image URL
  UploadDriverDocumentParametersBuilder withFrontImageUrl(
    String frontImageUrl,
  ) {
    _frontImageUrl = frontImageUrl;
    return this;
  }

  /// Set the back image URL
  UploadDriverDocumentParametersBuilder withBackImageUrl(String backImageUrl) {
    _backImageUrl = backImageUrl;
    return this;
  }

  /// Set the expiry date
  UploadDriverDocumentParametersBuilder withExpiryDate(DateTime expiryDate) {
    _expiryDate = expiryDate;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  UploadDriverDocumentParametersBuilder withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the UploadDriverDocumentParameters
  @override
  UploadDriverDocumentParameters build() {
    if (_documentType == null) {
      throw ArgumentError('Document type is required');
    }
    if (_documentNumber == null) {
      throw ArgumentError('Document number is required');
    }
    return UploadDriverDocumentParameters._(
      documentType: _documentType!,
      documentNumber: _documentNumber!,
      frontImageUrl: _frontImageUrl,
      backImageUrl: _backImageUrl,
      expiryDate: _expiryDate,
      cancelToken: _cancelToken,
    );
  }
}
