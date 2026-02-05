// lib/features/trip/data/models/trip_order_model.dart
import 'package:flavorizr/features/user/trip/domain/entities/trip_order.dart';

/// Data model for TripOrder, used for JSON serialization.
///
/// This model handles the conversion between API JSON
/// and the domain TripOrder entity.
class TripOrderModel {
  const TripOrderModel({
    required this.id,
    required this.tripId,
    required this.userId,
    required this.createdAt,
    this.status = OrderStatus.pending,
    this.paymentStatus = PaymentStatus.pending,
    this.paymentMethod,
    this.totalAmount,
    this.currency = 'USD',
    this.discountAmount,
    this.promoCode,
    this.confirmedAt,
    this.paidAt,
    this.cancelledAt,
    this.notes,
    this.metadata = const {},
  });

  /// Creates a model from JSON.
  factory TripOrderModel.fromJson(Map<String, dynamic> json) {
    return TripOrderModel(
      id: json['id'] as String,
      tripId: json['trip_id'] as String? ?? json['tripId'] as String,
      userId: json['user_id'] as String? ?? json['userId'] as String,
      status: OrderStatus.fromString(json['status'] as String? ?? 'pending'),
      paymentStatus: PaymentStatus.fromString(
        json['payment_status'] as String? ?? 'pending',
      ),
      paymentMethod:
          json['payment_method'] as String? ?? json['paymentMethod'] as String?,
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      discountAmount: (json['discount_amount'] as num?)?.toDouble(),
      promoCode: json['promo_code'] as String? ?? json['promoCode'] as String?,
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.parse(json['confirmed_at'] as String)
          : json['confirmedAt'] != null
          ? DateTime.parse(json['confirmedAt'] as String)
          : null,
      paidAt: json['paid_at'] != null
          ? DateTime.parse(json['paid_at'] as String)
          : json['paidAt'] != null
          ? DateTime.parse(json['paidAt'] as String)
          : null,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'] as String)
          : json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      notes: json['notes'] as String?,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    );
  }

  /// Creates a model from a domain entity.
  factory TripOrderModel.fromEntity(TripOrder entity) {
    return TripOrderModel(
      id: entity.id,
      tripId: entity.tripId,
      userId: entity.userId,
      status: entity.status,
      paymentStatus: entity.paymentStatus,
      paymentMethod: entity.paymentMethod,
      totalAmount: entity.totalAmount,
      currency: entity.currency,
      discountAmount: entity.discountAmount,
      promoCode: entity.promoCode,
      confirmedAt: entity.confirmedAt,
      paidAt: entity.paidAt,
      cancelledAt: entity.cancelledAt,
      createdAt: entity.createdAt,
      notes: entity.notes,
      metadata: entity.metadata,
    );
  }

  final String id;
  final String tripId;
  final String userId;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final String? paymentMethod;
  final double? totalAmount;
  final String currency;
  final double? discountAmount;
  final String? promoCode;
  final DateTime? confirmedAt;
  final DateTime? paidAt;
  final DateTime? cancelledAt;
  final DateTime createdAt;
  final String? notes;
  final Map<String, dynamic> metadata;

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trip_id': tripId,
      'user_id': userId,
      'status': status.value,
      'payment_status': paymentStatus.value,
      'payment_method': paymentMethod,
      'total_amount': totalAmount,
      'currency': currency,
      'discount_amount': discountAmount,
      'promo_code': promoCode,
      'confirmed_at': confirmedAt?.toIso8601String(),
      'paid_at': paidAt?.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'notes': notes,
      'metadata': metadata,
    };
  }

  /// Converts to a domain entity.
  TripOrder toEntity() {
    return TripOrder(
      id: id,
      tripId: tripId,
      userId: userId,
      status: status,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      totalAmount: totalAmount,
      currency: currency,
      discountAmount: discountAmount,
      promoCode: promoCode,
      confirmedAt: confirmedAt,
      paidAt: paidAt,
      cancelledAt: cancelledAt,
      createdAt: createdAt,
      notes: notes,
      metadata: metadata,
    );
  }
}
