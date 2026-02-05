import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_trip.freezed.dart';
part 'api_trip.g.dart';

/// API Trip model representing trip data from the backend
@freezed
abstract class ApiTrip with _$ApiTrip {
  const factory ApiTrip({
    required int id,
    required String type,
    required String status,
    required String pickupLocation,
    required String dropoffLocation,
    required String pickupLatitude,
    required String pickupLongitude,
    required String dropoffLatitude,
    required String dropoffLongitude,
    required int vehicleTypeId,
    String? vehicleTypeName,
    String? vehicleTypeImage,
    double? estimatedPrice,
    double? actualPrice,
    String? scheduledDate,
    String? scheduledTime,
    String? notes,
    int? userId,
    int? driverId,
    String? driverName,
    String? driverPhone,
    String? driverAvatar,
    double? driverRating,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
  }) = _ApiTrip;

  factory ApiTrip.fromJson(Map<String, dynamic> json) =>
      _$ApiTripFromJson(json);
}

/// API Trip Type model representing trip type data from the backend
@freezed
abstract class ApiTripType with _$ApiTripType {
  const factory ApiTripType({
    required int id,
    required String name,
    String? description,
    String? image,
    double? basePrice,
    double? pricePerKm,
    double? pricePerMinute,
    int? estimatedTime,
    bool? isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ApiTripType;

  factory ApiTripType.fromJson(Map<String, dynamic> json) =>
      _$ApiTripTypeFromJson(json);
}

/// API Trip Order model representing trip order data from the backend
@freezed
abstract class ApiTripOrder with _$ApiTripOrder {
  const factory ApiTripOrder({
    required int id,
    required int tripId,
    required String status,
    required String pickupLocation,
    required String dropoffLocation,
    double? price,
    String? scheduledDate,
    String? scheduledTime,
    int? userId,
    int? driverId,
    String? driverName,
    String? driverPhone,
    String? driverAvatar,
    double? driverRating,
    String? vehicleType,
    String? vehicleModel,
    String? vehiclePlateNumber,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'accepted_at') DateTime? acceptedAt,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
  }) = _ApiTripOrder;

  factory ApiTripOrder.fromJson(Map<String, dynamic> json) =>
      _$ApiTripOrderFromJson(json);
}

/// API Trip Evaluation model representing trip evaluation data from the backend
@freezed
abstract class ApiTripEvaluation with _$ApiTripEvaluation {
  const factory ApiTripEvaluation({
    required int id,
    required int tripId,
    required int rating,
    String? comment,
    int? userId,
    int? driverId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ApiTripEvaluation;

  factory ApiTripEvaluation.fromJson(Map<String, dynamic> json) =>
      _$ApiTripEvaluationFromJson(json);
}
