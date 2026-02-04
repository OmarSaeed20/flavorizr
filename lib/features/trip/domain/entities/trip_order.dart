// lib/features/trip/domain/entities/trip_order.dart


/// Represents a trip order in the domain layer.
///
/// A trip order is created when a user books a trip.
class TripOrder {
  /// Creates a new [TripOrder] instance.
  const TripOrder({
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

  /// Creates a trip order from a map.
  factory TripOrder.fromMap(Map<String, dynamic> map) {
    return TripOrder(
      id: map['id'] as String,
      tripId: map['tripId'] as String,
      userId: map['userId'] as String,
      status: OrderStatus.fromString(map['status'] as String? ?? 'pending'),
      paymentStatus: PaymentStatus.fromString(map['paymentStatus'] as String? ?? 'pending'),
      paymentMethod: map['paymentMethod'] as String?,
      totalAmount: (map['totalAmount'] as num?)?.toDouble(),
      currency: map['currency'] as String? ?? 'USD',
      discountAmount: (map['discountAmount'] as num?)?.toDouble(),
      promoCode: map['promoCode'] as String?,
      confirmedAt: map['confirmedAt'] != null
          ? DateTime.parse(map['confirmedAt'] as String)
          : null,
      paidAt: map['paidAt'] != null
          ? DateTime.parse(map['paidAt'] as String)
          : null,
      cancelledAt: map['cancelledAt'] != null
          ? DateTime.parse(map['cancelledAt'] as String)
          : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      notes: map['notes'] as String?,
      metadata: Map<String, dynamic>.from(map['metadata'] as Map? ?? {}),
    );
  }

  /// Unique identifier for the order.
  final String id;

  /// Associated trip ID.
  final String tripId;

  /// User ID who placed the order.
  final String userId;

  /// Current status of the order.
  final OrderStatus status;

  /// Payment status.
  final PaymentStatus paymentStatus;

  /// Payment method used.
  final String? paymentMethod;

  /// Total amount.
  final double? totalAmount;

  /// Currency code.
  final String currency;

  /// Discount amount applied.
  final double? discountAmount;

  /// Promo code used.
  final String? promoCode;

  /// Confirmation timestamp.
  final DateTime? confirmedAt;

  /// Payment timestamp.
  final DateTime? paidAt;

  /// Cancellation timestamp.
  final DateTime? cancelledAt;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Additional notes.
  final String? notes;

  /// Additional metadata.
  final Map<String, dynamic> metadata;

  /// Converts to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripId': tripId,
      'userId': userId,
      'status': status.value,
      'paymentStatus': paymentStatus.value,
      'paymentMethod': paymentMethod,
      'totalAmount': totalAmount,
      'currency': currency,
      'discountAmount': discountAmount,
      'promoCode': promoCode,
      'confirmedAt': confirmedAt?.toIso8601String(),
      'paidAt': paidAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'notes': notes,
      'metadata': metadata,
    };
  }

  /// Creates a copy with modified fields.
  TripOrder copyWith({
    String? id,
    String? tripId,
    String? userId,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    String? paymentMethod,
    double? totalAmount,
    String? currency,
    double? discountAmount,
    String? promoCode,
    DateTime? confirmedAt,
    DateTime? paidAt,
    DateTime? cancelledAt,
    DateTime? createdAt,
    String? notes,
    Map<String, dynamic>? metadata,
  }) {
    return TripOrder(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      discountAmount: discountAmount ?? this.discountAmount,
      promoCode: promoCode ?? this.promoCode,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      paidAt: paidAt ?? this.paidAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Order status enumeration.
enum OrderStatus {
  pending('pending'),
  confirmed('confirmed'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled'),
  failed('failed');

  const OrderStatus(this.value);
  final String value;

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => OrderStatus.pending,
    );
  }
}

/// Payment status enumeration.
enum PaymentStatus {
  pending('pending'),
  processing('processing'),
  paid('paid'),
  failed('failed'),
  refunded('refunded');

  const PaymentStatus(this.value);
  final String value;

  static PaymentStatus fromString(String value) {
    return PaymentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => PaymentStatus.pending,
    );
  }
}