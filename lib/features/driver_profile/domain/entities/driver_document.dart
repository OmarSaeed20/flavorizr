/// Driver document entity.
class DriverDocument {
  final String id;
  final String driverId;
  final String documentType;
  final String documentNumber;
  final String? frontImageUrl;
  final String? backImageUrl;
  final DateTime? expiryDate;
  final bool isVerified;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime? updatedAt;

  DriverDocument({
    required this.id,
    required this.driverId,
    required this.documentType,
    required this.documentNumber,
    this.frontImageUrl,
    this.backImageUrl,
    this.expiryDate,
    required this.isVerified,
    this.rejectionReason,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry > 0 && daysUntilExpiry <= 30;
  }
}