// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiTrip _$ApiTripFromJson(Map<String, dynamic> json) => _ApiTrip(
  id: (json['id'] as num).toInt(),
  type: json['type'] as String,
  status: json['status'] as String,
  pickupLocation: json['pickupLocation'] as String,
  dropoffLocation: json['dropoffLocation'] as String,
  pickupLatitude: json['pickupLatitude'] as String,
  pickupLongitude: json['pickupLongitude'] as String,
  dropoffLatitude: json['dropoffLatitude'] as String,
  dropoffLongitude: json['dropoffLongitude'] as String,
  vehicleTypeId: (json['vehicleTypeId'] as num).toInt(),
  vehicleTypeName: json['vehicleTypeName'] as String?,
  vehicleTypeImage: json['vehicleTypeImage'] as String?,
  estimatedPrice: (json['estimatedPrice'] as num?)?.toDouble(),
  actualPrice: (json['actualPrice'] as num?)?.toDouble(),
  scheduledDate: json['scheduledDate'] as String?,
  scheduledTime: json['scheduledTime'] as String?,
  notes: json['notes'] as String?,
  userId: (json['userId'] as num?)?.toInt(),
  driverId: (json['driverId'] as num?)?.toInt(),
  driverName: json['driverName'] as String?,
  driverPhone: json['driverPhone'] as String?,
  driverAvatar: json['driverAvatar'] as String?,
  driverRating: (json['driverRating'] as num?)?.toDouble(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  startedAt: json['started_at'] == null
      ? null
      : DateTime.parse(json['started_at'] as String),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  cancelledAt: json['cancelled_at'] == null
      ? null
      : DateTime.parse(json['cancelled_at'] as String),
);

Map<String, dynamic> _$ApiTripToJson(_ApiTrip instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'status': instance.status,
  'pickupLocation': instance.pickupLocation,
  'dropoffLocation': instance.dropoffLocation,
  'pickupLatitude': instance.pickupLatitude,
  'pickupLongitude': instance.pickupLongitude,
  'dropoffLatitude': instance.dropoffLatitude,
  'dropoffLongitude': instance.dropoffLongitude,
  'vehicleTypeId': instance.vehicleTypeId,
  'vehicleTypeName': instance.vehicleTypeName,
  'vehicleTypeImage': instance.vehicleTypeImage,
  'estimatedPrice': instance.estimatedPrice,
  'actualPrice': instance.actualPrice,
  'scheduledDate': instance.scheduledDate,
  'scheduledTime': instance.scheduledTime,
  'notes': instance.notes,
  'userId': instance.userId,
  'driverId': instance.driverId,
  'driverName': instance.driverName,
  'driverPhone': instance.driverPhone,
  'driverAvatar': instance.driverAvatar,
  'driverRating': instance.driverRating,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'started_at': instance.startedAt?.toIso8601String(),
  'completed_at': instance.completedAt?.toIso8601String(),
  'cancelled_at': instance.cancelledAt?.toIso8601String(),
};

_ApiTripType _$ApiTripTypeFromJson(Map<String, dynamic> json) => _ApiTripType(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  image: json['image'] as String?,
  basePrice: (json['basePrice'] as num?)?.toDouble(),
  pricePerKm: (json['pricePerKm'] as num?)?.toDouble(),
  pricePerMinute: (json['pricePerMinute'] as num?)?.toDouble(),
  estimatedTime: (json['estimatedTime'] as num?)?.toInt(),
  isActive: json['isActive'] as bool?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ApiTripTypeToJson(_ApiTripType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'basePrice': instance.basePrice,
      'pricePerKm': instance.pricePerKm,
      'pricePerMinute': instance.pricePerMinute,
      'estimatedTime': instance.estimatedTime,
      'isActive': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_ApiTripOrder _$ApiTripOrderFromJson(Map<String, dynamic> json) =>
    _ApiTripOrder(
      id: (json['id'] as num).toInt(),
      tripId: (json['tripId'] as num).toInt(),
      status: json['status'] as String,
      pickupLocation: json['pickupLocation'] as String,
      dropoffLocation: json['dropoffLocation'] as String,
      price: (json['price'] as num?)?.toDouble(),
      scheduledDate: json['scheduledDate'] as String?,
      scheduledTime: json['scheduledTime'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      driverId: (json['driverId'] as num?)?.toInt(),
      driverName: json['driverName'] as String?,
      driverPhone: json['driverPhone'] as String?,
      driverAvatar: json['driverAvatar'] as String?,
      driverRating: (json['driverRating'] as num?)?.toDouble(),
      vehicleType: json['vehicleType'] as String?,
      vehicleModel: json['vehicleModel'] as String?,
      vehiclePlateNumber: json['vehiclePlateNumber'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      acceptedAt: json['accepted_at'] == null
          ? null
          : DateTime.parse(json['accepted_at'] as String),
      startedAt: json['started_at'] == null
          ? null
          : DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      cancelledAt: json['cancelled_at'] == null
          ? null
          : DateTime.parse(json['cancelled_at'] as String),
    );

Map<String, dynamic> _$ApiTripOrderToJson(_ApiTripOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tripId': instance.tripId,
      'status': instance.status,
      'pickupLocation': instance.pickupLocation,
      'dropoffLocation': instance.dropoffLocation,
      'price': instance.price,
      'scheduledDate': instance.scheduledDate,
      'scheduledTime': instance.scheduledTime,
      'userId': instance.userId,
      'driverId': instance.driverId,
      'driverName': instance.driverName,
      'driverPhone': instance.driverPhone,
      'driverAvatar': instance.driverAvatar,
      'driverRating': instance.driverRating,
      'vehicleType': instance.vehicleType,
      'vehicleModel': instance.vehicleModel,
      'vehiclePlateNumber': instance.vehiclePlateNumber,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'accepted_at': instance.acceptedAt?.toIso8601String(),
      'started_at': instance.startedAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'cancelled_at': instance.cancelledAt?.toIso8601String(),
    };

_ApiTripEvaluation _$ApiTripEvaluationFromJson(Map<String, dynamic> json) =>
    _ApiTripEvaluation(
      id: (json['id'] as num).toInt(),
      tripId: (json['tripId'] as num).toInt(),
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      driverId: (json['driverId'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ApiTripEvaluationToJson(_ApiTripEvaluation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tripId': instance.tripId,
      'rating': instance.rating,
      'comment': instance.comment,
      'userId': instance.userId,
      'driverId': instance.driverId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
