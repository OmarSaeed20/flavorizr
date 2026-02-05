/// Parameters for uploading driver document.
class UploadDriverDocumentParameters {
  final String documentType;
  final String documentNumber;
  final String? frontImageUrl;
  final String? backImageUrl;
  final DateTime? expiryDate;

  UploadDriverDocumentParameters({
    required this.documentType,
    required this.documentNumber,
    this.frontImageUrl,
    this.backImageUrl,
    this.expiryDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'document_type': documentType,
      'document_number': documentNumber,
      if (frontImageUrl != null) 'front_image_url': frontImageUrl,
      if (backImageUrl != null) 'back_image_url': backImageUrl,
      if (expiryDate != null) 'expiry_date': expiryDate!.toIso8601String(),
    };
  }
}