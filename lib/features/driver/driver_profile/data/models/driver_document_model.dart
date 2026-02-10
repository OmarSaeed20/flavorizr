import 'package:fast_golden_taxi/features/driver/driver_profile/domain/entities/driver_document.dart';

/// Model for DriverDocument entity.
class DriverDocumentModel extends DriverDocument {
  DriverDocumentModel({
    required super.id,
    required super.driverId,
    required super.documentType,
    required super.documentNumber,
    super.frontImageUrl,
    super.backImageUrl,
    super.expiryDate,
    required super.isVerified,
    super.rejectionReason,
    required super.createdAt,
    super.updatedAt,
  });

  factory DriverDocumentModel.fromJson(Map<String, dynamic> json) {
    return DriverDocumentModel(
      id: json['id'] as String,
      driverId: json['driver_id'] as String,
      documentType: json['document_type'] as String,
      documentNumber: json['document_number'] as String,
      frontImageUrl: json['front_image_url'] as String?,
      backImageUrl: json['back_image_url'] as String?,
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'] as String)
          : null,
      isVerified: json['is_verified'] as bool? ?? false,
      rejectionReason: json['rejection_reason'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'document_type': documentType,
      'document_number': documentNumber,
      'front_image_url': frontImageUrl,
      'back_image_url': backImageUrl,
      'expiry_date': expiryDate?.toIso8601String(),
      'is_verified': isVerified,
      'rejection_reason': rejectionReason,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  DriverDocument toEntity() {
    return DriverDocument(
      id: id,
      driverId: driverId,
      documentType: documentType,
      documentNumber: documentNumber,
      frontImageUrl: frontImageUrl,
      backImageUrl: backImageUrl,
      expiryDate: expiryDate,
      isVerified: isVerified,
      rejectionReason: rejectionReason,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
