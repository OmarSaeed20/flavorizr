// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApiTrip {

 int get id; String get type; String get status; String get pickupLocation; String get dropoffLocation; String get pickupLatitude; String get pickupLongitude; String get dropoffLatitude; String get dropoffLongitude; int get vehicleTypeId; String? get vehicleTypeName; String? get vehicleTypeImage; double? get estimatedPrice; double? get actualPrice; String? get scheduledDate; String? get scheduledTime; String? get notes; int? get userId; int? get driverId; String? get driverName; String? get driverPhone; String? get driverAvatar; double? get driverRating;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;@JsonKey(name: 'started_at') DateTime? get startedAt;@JsonKey(name: 'completed_at') DateTime? get completedAt;@JsonKey(name: 'cancelled_at') DateTime? get cancelledAt;
/// Create a copy of ApiTrip
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiTripCopyWith<ApiTrip> get copyWith => _$ApiTripCopyWithImpl<ApiTrip>(this as ApiTrip, _$identity);

  /// Serializes this ApiTrip to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiTrip&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.pickupLocation, pickupLocation) || other.pickupLocation == pickupLocation)&&(identical(other.dropoffLocation, dropoffLocation) || other.dropoffLocation == dropoffLocation)&&(identical(other.pickupLatitude, pickupLatitude) || other.pickupLatitude == pickupLatitude)&&(identical(other.pickupLongitude, pickupLongitude) || other.pickupLongitude == pickupLongitude)&&(identical(other.dropoffLatitude, dropoffLatitude) || other.dropoffLatitude == dropoffLatitude)&&(identical(other.dropoffLongitude, dropoffLongitude) || other.dropoffLongitude == dropoffLongitude)&&(identical(other.vehicleTypeId, vehicleTypeId) || other.vehicleTypeId == vehicleTypeId)&&(identical(other.vehicleTypeName, vehicleTypeName) || other.vehicleTypeName == vehicleTypeName)&&(identical(other.vehicleTypeImage, vehicleTypeImage) || other.vehicleTypeImage == vehicleTypeImage)&&(identical(other.estimatedPrice, estimatedPrice) || other.estimatedPrice == estimatedPrice)&&(identical(other.actualPrice, actualPrice) || other.actualPrice == actualPrice)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.driverName, driverName) || other.driverName == driverName)&&(identical(other.driverPhone, driverPhone) || other.driverPhone == driverPhone)&&(identical(other.driverAvatar, driverAvatar) || other.driverAvatar == driverAvatar)&&(identical(other.driverRating, driverRating) || other.driverRating == driverRating)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,type,status,pickupLocation,dropoffLocation,pickupLatitude,pickupLongitude,dropoffLatitude,dropoffLongitude,vehicleTypeId,vehicleTypeName,vehicleTypeImage,estimatedPrice,actualPrice,scheduledDate,scheduledTime,notes,userId,driverId,driverName,driverPhone,driverAvatar,driverRating,createdAt,updatedAt,startedAt,completedAt,cancelledAt]);

@override
String toString() {
  return 'ApiTrip(id: $id, type: $type, status: $status, pickupLocation: $pickupLocation, dropoffLocation: $dropoffLocation, pickupLatitude: $pickupLatitude, pickupLongitude: $pickupLongitude, dropoffLatitude: $dropoffLatitude, dropoffLongitude: $dropoffLongitude, vehicleTypeId: $vehicleTypeId, vehicleTypeName: $vehicleTypeName, vehicleTypeImage: $vehicleTypeImage, estimatedPrice: $estimatedPrice, actualPrice: $actualPrice, scheduledDate: $scheduledDate, scheduledTime: $scheduledTime, notes: $notes, userId: $userId, driverId: $driverId, driverName: $driverName, driverPhone: $driverPhone, driverAvatar: $driverAvatar, driverRating: $driverRating, createdAt: $createdAt, updatedAt: $updatedAt, startedAt: $startedAt, completedAt: $completedAt, cancelledAt: $cancelledAt)';
}


}

/// @nodoc
abstract mixin class $ApiTripCopyWith<$Res>  {
  factory $ApiTripCopyWith(ApiTrip value, $Res Function(ApiTrip) _then) = _$ApiTripCopyWithImpl;
@useResult
$Res call({
 int id, String type, String status, String pickupLocation, String dropoffLocation, String pickupLatitude, String pickupLongitude, String dropoffLatitude, String dropoffLongitude, int vehicleTypeId, String? vehicleTypeName, String? vehicleTypeImage, double? estimatedPrice, double? actualPrice, String? scheduledDate, String? scheduledTime, String? notes, int? userId, int? driverId, String? driverName, String? driverPhone, String? driverAvatar, double? driverRating,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'cancelled_at') DateTime? cancelledAt
});




}
/// @nodoc
class _$ApiTripCopyWithImpl<$Res>
    implements $ApiTripCopyWith<$Res> {
  _$ApiTripCopyWithImpl(this._self, this._then);

  final ApiTrip _self;
  final $Res Function(ApiTrip) _then;

/// Create a copy of ApiTrip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? status = null,Object? pickupLocation = null,Object? dropoffLocation = null,Object? pickupLatitude = null,Object? pickupLongitude = null,Object? dropoffLatitude = null,Object? dropoffLongitude = null,Object? vehicleTypeId = null,Object? vehicleTypeName = freezed,Object? vehicleTypeImage = freezed,Object? estimatedPrice = freezed,Object? actualPrice = freezed,Object? scheduledDate = freezed,Object? scheduledTime = freezed,Object? notes = freezed,Object? userId = freezed,Object? driverId = freezed,Object? driverName = freezed,Object? driverPhone = freezed,Object? driverAvatar = freezed,Object? driverRating = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? cancelledAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,pickupLocation: null == pickupLocation ? _self.pickupLocation : pickupLocation // ignore: cast_nullable_to_non_nullable
as String,dropoffLocation: null == dropoffLocation ? _self.dropoffLocation : dropoffLocation // ignore: cast_nullable_to_non_nullable
as String,pickupLatitude: null == pickupLatitude ? _self.pickupLatitude : pickupLatitude // ignore: cast_nullable_to_non_nullable
as String,pickupLongitude: null == pickupLongitude ? _self.pickupLongitude : pickupLongitude // ignore: cast_nullable_to_non_nullable
as String,dropoffLatitude: null == dropoffLatitude ? _self.dropoffLatitude : dropoffLatitude // ignore: cast_nullable_to_non_nullable
as String,dropoffLongitude: null == dropoffLongitude ? _self.dropoffLongitude : dropoffLongitude // ignore: cast_nullable_to_non_nullable
as String,vehicleTypeId: null == vehicleTypeId ? _self.vehicleTypeId : vehicleTypeId // ignore: cast_nullable_to_non_nullable
as int,vehicleTypeName: freezed == vehicleTypeName ? _self.vehicleTypeName : vehicleTypeName // ignore: cast_nullable_to_non_nullable
as String?,vehicleTypeImage: freezed == vehicleTypeImage ? _self.vehicleTypeImage : vehicleTypeImage // ignore: cast_nullable_to_non_nullable
as String?,estimatedPrice: freezed == estimatedPrice ? _self.estimatedPrice : estimatedPrice // ignore: cast_nullable_to_non_nullable
as double?,actualPrice: freezed == actualPrice ? _self.actualPrice : actualPrice // ignore: cast_nullable_to_non_nullable
as double?,scheduledDate: freezed == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as String?,scheduledTime: freezed == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,driverId: freezed == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as int?,driverName: freezed == driverName ? _self.driverName : driverName // ignore: cast_nullable_to_non_nullable
as String?,driverPhone: freezed == driverPhone ? _self.driverPhone : driverPhone // ignore: cast_nullable_to_non_nullable
as String?,driverAvatar: freezed == driverAvatar ? _self.driverAvatar : driverAvatar // ignore: cast_nullable_to_non_nullable
as String?,driverRating: freezed == driverRating ? _self.driverRating : driverRating // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiTrip].
extension ApiTripPatterns on ApiTrip {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiTrip value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiTrip() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiTrip value)  $default,){
final _that = this;
switch (_that) {
case _ApiTrip():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiTrip value)?  $default,){
final _that = this;
switch (_that) {
case _ApiTrip() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String type,  String status,  String pickupLocation,  String dropoffLocation,  String pickupLatitude,  String pickupLongitude,  String dropoffLatitude,  String dropoffLongitude,  int vehicleTypeId,  String? vehicleTypeName,  String? vehicleTypeImage,  double? estimatedPrice,  double? actualPrice,  String? scheduledDate,  String? scheduledTime,  String? notes,  int? userId,  int? driverId,  String? driverName,  String? driverPhone,  String? driverAvatar,  double? driverRating, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'cancelled_at')  DateTime? cancelledAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiTrip() when $default != null:
return $default(_that.id,_that.type,_that.status,_that.pickupLocation,_that.dropoffLocation,_that.pickupLatitude,_that.pickupLongitude,_that.dropoffLatitude,_that.dropoffLongitude,_that.vehicleTypeId,_that.vehicleTypeName,_that.vehicleTypeImage,_that.estimatedPrice,_that.actualPrice,_that.scheduledDate,_that.scheduledTime,_that.notes,_that.userId,_that.driverId,_that.driverName,_that.driverPhone,_that.driverAvatar,_that.driverRating,_that.createdAt,_that.updatedAt,_that.startedAt,_that.completedAt,_that.cancelledAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String type,  String status,  String pickupLocation,  String dropoffLocation,  String pickupLatitude,  String pickupLongitude,  String dropoffLatitude,  String dropoffLongitude,  int vehicleTypeId,  String? vehicleTypeName,  String? vehicleTypeImage,  double? estimatedPrice,  double? actualPrice,  String? scheduledDate,  String? scheduledTime,  String? notes,  int? userId,  int? driverId,  String? driverName,  String? driverPhone,  String? driverAvatar,  double? driverRating, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'cancelled_at')  DateTime? cancelledAt)  $default,) {final _that = this;
switch (_that) {
case _ApiTrip():
return $default(_that.id,_that.type,_that.status,_that.pickupLocation,_that.dropoffLocation,_that.pickupLatitude,_that.pickupLongitude,_that.dropoffLatitude,_that.dropoffLongitude,_that.vehicleTypeId,_that.vehicleTypeName,_that.vehicleTypeImage,_that.estimatedPrice,_that.actualPrice,_that.scheduledDate,_that.scheduledTime,_that.notes,_that.userId,_that.driverId,_that.driverName,_that.driverPhone,_that.driverAvatar,_that.driverRating,_that.createdAt,_that.updatedAt,_that.startedAt,_that.completedAt,_that.cancelledAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String type,  String status,  String pickupLocation,  String dropoffLocation,  String pickupLatitude,  String pickupLongitude,  String dropoffLatitude,  String dropoffLongitude,  int vehicleTypeId,  String? vehicleTypeName,  String? vehicleTypeImage,  double? estimatedPrice,  double? actualPrice,  String? scheduledDate,  String? scheduledTime,  String? notes,  int? userId,  int? driverId,  String? driverName,  String? driverPhone,  String? driverAvatar,  double? driverRating, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'cancelled_at')  DateTime? cancelledAt)?  $default,) {final _that = this;
switch (_that) {
case _ApiTrip() when $default != null:
return $default(_that.id,_that.type,_that.status,_that.pickupLocation,_that.dropoffLocation,_that.pickupLatitude,_that.pickupLongitude,_that.dropoffLatitude,_that.dropoffLongitude,_that.vehicleTypeId,_that.vehicleTypeName,_that.vehicleTypeImage,_that.estimatedPrice,_that.actualPrice,_that.scheduledDate,_that.scheduledTime,_that.notes,_that.userId,_that.driverId,_that.driverName,_that.driverPhone,_that.driverAvatar,_that.driverRating,_that.createdAt,_that.updatedAt,_that.startedAt,_that.completedAt,_that.cancelledAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiTrip implements ApiTrip {
  const _ApiTrip({required this.id, required this.type, required this.status, required this.pickupLocation, required this.dropoffLocation, required this.pickupLatitude, required this.pickupLongitude, required this.dropoffLatitude, required this.dropoffLongitude, required this.vehicleTypeId, this.vehicleTypeName, this.vehicleTypeImage, this.estimatedPrice, this.actualPrice, this.scheduledDate, this.scheduledTime, this.notes, this.userId, this.driverId, this.driverName, this.driverPhone, this.driverAvatar, this.driverRating, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(name: 'started_at') this.startedAt, @JsonKey(name: 'completed_at') this.completedAt, @JsonKey(name: 'cancelled_at') this.cancelledAt});
  factory _ApiTrip.fromJson(Map<String, dynamic> json) => _$ApiTripFromJson(json);

@override final  int id;
@override final  String type;
@override final  String status;
@override final  String pickupLocation;
@override final  String dropoffLocation;
@override final  String pickupLatitude;
@override final  String pickupLongitude;
@override final  String dropoffLatitude;
@override final  String dropoffLongitude;
@override final  int vehicleTypeId;
@override final  String? vehicleTypeName;
@override final  String? vehicleTypeImage;
@override final  double? estimatedPrice;
@override final  double? actualPrice;
@override final  String? scheduledDate;
@override final  String? scheduledTime;
@override final  String? notes;
@override final  int? userId;
@override final  int? driverId;
@override final  String? driverName;
@override final  String? driverPhone;
@override final  String? driverAvatar;
@override final  double? driverRating;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
@override@JsonKey(name: 'started_at') final  DateTime? startedAt;
@override@JsonKey(name: 'completed_at') final  DateTime? completedAt;
@override@JsonKey(name: 'cancelled_at') final  DateTime? cancelledAt;

/// Create a copy of ApiTrip
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiTripCopyWith<_ApiTrip> get copyWith => __$ApiTripCopyWithImpl<_ApiTrip>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiTripToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiTrip&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.pickupLocation, pickupLocation) || other.pickupLocation == pickupLocation)&&(identical(other.dropoffLocation, dropoffLocation) || other.dropoffLocation == dropoffLocation)&&(identical(other.pickupLatitude, pickupLatitude) || other.pickupLatitude == pickupLatitude)&&(identical(other.pickupLongitude, pickupLongitude) || other.pickupLongitude == pickupLongitude)&&(identical(other.dropoffLatitude, dropoffLatitude) || other.dropoffLatitude == dropoffLatitude)&&(identical(other.dropoffLongitude, dropoffLongitude) || other.dropoffLongitude == dropoffLongitude)&&(identical(other.vehicleTypeId, vehicleTypeId) || other.vehicleTypeId == vehicleTypeId)&&(identical(other.vehicleTypeName, vehicleTypeName) || other.vehicleTypeName == vehicleTypeName)&&(identical(other.vehicleTypeImage, vehicleTypeImage) || other.vehicleTypeImage == vehicleTypeImage)&&(identical(other.estimatedPrice, estimatedPrice) || other.estimatedPrice == estimatedPrice)&&(identical(other.actualPrice, actualPrice) || other.actualPrice == actualPrice)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.driverName, driverName) || other.driverName == driverName)&&(identical(other.driverPhone, driverPhone) || other.driverPhone == driverPhone)&&(identical(other.driverAvatar, driverAvatar) || other.driverAvatar == driverAvatar)&&(identical(other.driverRating, driverRating) || other.driverRating == driverRating)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,type,status,pickupLocation,dropoffLocation,pickupLatitude,pickupLongitude,dropoffLatitude,dropoffLongitude,vehicleTypeId,vehicleTypeName,vehicleTypeImage,estimatedPrice,actualPrice,scheduledDate,scheduledTime,notes,userId,driverId,driverName,driverPhone,driverAvatar,driverRating,createdAt,updatedAt,startedAt,completedAt,cancelledAt]);

@override
String toString() {
  return 'ApiTrip(id: $id, type: $type, status: $status, pickupLocation: $pickupLocation, dropoffLocation: $dropoffLocation, pickupLatitude: $pickupLatitude, pickupLongitude: $pickupLongitude, dropoffLatitude: $dropoffLatitude, dropoffLongitude: $dropoffLongitude, vehicleTypeId: $vehicleTypeId, vehicleTypeName: $vehicleTypeName, vehicleTypeImage: $vehicleTypeImage, estimatedPrice: $estimatedPrice, actualPrice: $actualPrice, scheduledDate: $scheduledDate, scheduledTime: $scheduledTime, notes: $notes, userId: $userId, driverId: $driverId, driverName: $driverName, driverPhone: $driverPhone, driverAvatar: $driverAvatar, driverRating: $driverRating, createdAt: $createdAt, updatedAt: $updatedAt, startedAt: $startedAt, completedAt: $completedAt, cancelledAt: $cancelledAt)';
}


}

/// @nodoc
abstract mixin class _$ApiTripCopyWith<$Res> implements $ApiTripCopyWith<$Res> {
  factory _$ApiTripCopyWith(_ApiTrip value, $Res Function(_ApiTrip) _then) = __$ApiTripCopyWithImpl;
@override @useResult
$Res call({
 int id, String type, String status, String pickupLocation, String dropoffLocation, String pickupLatitude, String pickupLongitude, String dropoffLatitude, String dropoffLongitude, int vehicleTypeId, String? vehicleTypeName, String? vehicleTypeImage, double? estimatedPrice, double? actualPrice, String? scheduledDate, String? scheduledTime, String? notes, int? userId, int? driverId, String? driverName, String? driverPhone, String? driverAvatar, double? driverRating,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'cancelled_at') DateTime? cancelledAt
});




}
/// @nodoc
class __$ApiTripCopyWithImpl<$Res>
    implements _$ApiTripCopyWith<$Res> {
  __$ApiTripCopyWithImpl(this._self, this._then);

  final _ApiTrip _self;
  final $Res Function(_ApiTrip) _then;

/// Create a copy of ApiTrip
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? status = null,Object? pickupLocation = null,Object? dropoffLocation = null,Object? pickupLatitude = null,Object? pickupLongitude = null,Object? dropoffLatitude = null,Object? dropoffLongitude = null,Object? vehicleTypeId = null,Object? vehicleTypeName = freezed,Object? vehicleTypeImage = freezed,Object? estimatedPrice = freezed,Object? actualPrice = freezed,Object? scheduledDate = freezed,Object? scheduledTime = freezed,Object? notes = freezed,Object? userId = freezed,Object? driverId = freezed,Object? driverName = freezed,Object? driverPhone = freezed,Object? driverAvatar = freezed,Object? driverRating = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? cancelledAt = freezed,}) {
  return _then(_ApiTrip(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,pickupLocation: null == pickupLocation ? _self.pickupLocation : pickupLocation // ignore: cast_nullable_to_non_nullable
as String,dropoffLocation: null == dropoffLocation ? _self.dropoffLocation : dropoffLocation // ignore: cast_nullable_to_non_nullable
as String,pickupLatitude: null == pickupLatitude ? _self.pickupLatitude : pickupLatitude // ignore: cast_nullable_to_non_nullable
as String,pickupLongitude: null == pickupLongitude ? _self.pickupLongitude : pickupLongitude // ignore: cast_nullable_to_non_nullable
as String,dropoffLatitude: null == dropoffLatitude ? _self.dropoffLatitude : dropoffLatitude // ignore: cast_nullable_to_non_nullable
as String,dropoffLongitude: null == dropoffLongitude ? _self.dropoffLongitude : dropoffLongitude // ignore: cast_nullable_to_non_nullable
as String,vehicleTypeId: null == vehicleTypeId ? _self.vehicleTypeId : vehicleTypeId // ignore: cast_nullable_to_non_nullable
as int,vehicleTypeName: freezed == vehicleTypeName ? _self.vehicleTypeName : vehicleTypeName // ignore: cast_nullable_to_non_nullable
as String?,vehicleTypeImage: freezed == vehicleTypeImage ? _self.vehicleTypeImage : vehicleTypeImage // ignore: cast_nullable_to_non_nullable
as String?,estimatedPrice: freezed == estimatedPrice ? _self.estimatedPrice : estimatedPrice // ignore: cast_nullable_to_non_nullable
as double?,actualPrice: freezed == actualPrice ? _self.actualPrice : actualPrice // ignore: cast_nullable_to_non_nullable
as double?,scheduledDate: freezed == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as String?,scheduledTime: freezed == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,driverId: freezed == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as int?,driverName: freezed == driverName ? _self.driverName : driverName // ignore: cast_nullable_to_non_nullable
as String?,driverPhone: freezed == driverPhone ? _self.driverPhone : driverPhone // ignore: cast_nullable_to_non_nullable
as String?,driverAvatar: freezed == driverAvatar ? _self.driverAvatar : driverAvatar // ignore: cast_nullable_to_non_nullable
as String?,driverRating: freezed == driverRating ? _self.driverRating : driverRating // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ApiTripType {

 int get id; String get name; String? get description; String? get image; double? get basePrice; double? get pricePerKm; double? get pricePerMinute; int? get estimatedTime; bool? get isActive;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of ApiTripType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiTripTypeCopyWith<ApiTripType> get copyWith => _$ApiTripTypeCopyWithImpl<ApiTripType>(this as ApiTripType, _$identity);

  /// Serializes this ApiTripType to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiTripType&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.image, image) || other.image == image)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.pricePerKm, pricePerKm) || other.pricePerKm == pricePerKm)&&(identical(other.pricePerMinute, pricePerMinute) || other.pricePerMinute == pricePerMinute)&&(identical(other.estimatedTime, estimatedTime) || other.estimatedTime == estimatedTime)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,image,basePrice,pricePerKm,pricePerMinute,estimatedTime,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'ApiTripType(id: $id, name: $name, description: $description, image: $image, basePrice: $basePrice, pricePerKm: $pricePerKm, pricePerMinute: $pricePerMinute, estimatedTime: $estimatedTime, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ApiTripTypeCopyWith<$Res>  {
  factory $ApiTripTypeCopyWith(ApiTripType value, $Res Function(ApiTripType) _then) = _$ApiTripTypeCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? description, String? image, double? basePrice, double? pricePerKm, double? pricePerMinute, int? estimatedTime, bool? isActive,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$ApiTripTypeCopyWithImpl<$Res>
    implements $ApiTripTypeCopyWith<$Res> {
  _$ApiTripTypeCopyWithImpl(this._self, this._then);

  final ApiTripType _self;
  final $Res Function(ApiTripType) _then;

/// Create a copy of ApiTripType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? image = freezed,Object? basePrice = freezed,Object? pricePerKm = freezed,Object? pricePerMinute = freezed,Object? estimatedTime = freezed,Object? isActive = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,basePrice: freezed == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as double?,pricePerKm: freezed == pricePerKm ? _self.pricePerKm : pricePerKm // ignore: cast_nullable_to_non_nullable
as double?,pricePerMinute: freezed == pricePerMinute ? _self.pricePerMinute : pricePerMinute // ignore: cast_nullable_to_non_nullable
as double?,estimatedTime: freezed == estimatedTime ? _self.estimatedTime : estimatedTime // ignore: cast_nullable_to_non_nullable
as int?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiTripType].
extension ApiTripTypePatterns on ApiTripType {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiTripType value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiTripType() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiTripType value)  $default,){
final _that = this;
switch (_that) {
case _ApiTripType():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiTripType value)?  $default,){
final _that = this;
switch (_that) {
case _ApiTripType() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? description,  String? image,  double? basePrice,  double? pricePerKm,  double? pricePerMinute,  int? estimatedTime,  bool? isActive, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiTripType() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.image,_that.basePrice,_that.pricePerKm,_that.pricePerMinute,_that.estimatedTime,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? description,  String? image,  double? basePrice,  double? pricePerKm,  double? pricePerMinute,  int? estimatedTime,  bool? isActive, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ApiTripType():
return $default(_that.id,_that.name,_that.description,_that.image,_that.basePrice,_that.pricePerKm,_that.pricePerMinute,_that.estimatedTime,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? description,  String? image,  double? basePrice,  double? pricePerKm,  double? pricePerMinute,  int? estimatedTime,  bool? isActive, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ApiTripType() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.image,_that.basePrice,_that.pricePerKm,_that.pricePerMinute,_that.estimatedTime,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiTripType implements ApiTripType {
  const _ApiTripType({required this.id, required this.name, this.description, this.image, this.basePrice, this.pricePerKm, this.pricePerMinute, this.estimatedTime, this.isActive, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _ApiTripType.fromJson(Map<String, dynamic> json) => _$ApiTripTypeFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? description;
@override final  String? image;
@override final  double? basePrice;
@override final  double? pricePerKm;
@override final  double? pricePerMinute;
@override final  int? estimatedTime;
@override final  bool? isActive;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of ApiTripType
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiTripTypeCopyWith<_ApiTripType> get copyWith => __$ApiTripTypeCopyWithImpl<_ApiTripType>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiTripTypeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiTripType&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.image, image) || other.image == image)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.pricePerKm, pricePerKm) || other.pricePerKm == pricePerKm)&&(identical(other.pricePerMinute, pricePerMinute) || other.pricePerMinute == pricePerMinute)&&(identical(other.estimatedTime, estimatedTime) || other.estimatedTime == estimatedTime)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,image,basePrice,pricePerKm,pricePerMinute,estimatedTime,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'ApiTripType(id: $id, name: $name, description: $description, image: $image, basePrice: $basePrice, pricePerKm: $pricePerKm, pricePerMinute: $pricePerMinute, estimatedTime: $estimatedTime, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ApiTripTypeCopyWith<$Res> implements $ApiTripTypeCopyWith<$Res> {
  factory _$ApiTripTypeCopyWith(_ApiTripType value, $Res Function(_ApiTripType) _then) = __$ApiTripTypeCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? description, String? image, double? basePrice, double? pricePerKm, double? pricePerMinute, int? estimatedTime, bool? isActive,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$ApiTripTypeCopyWithImpl<$Res>
    implements _$ApiTripTypeCopyWith<$Res> {
  __$ApiTripTypeCopyWithImpl(this._self, this._then);

  final _ApiTripType _self;
  final $Res Function(_ApiTripType) _then;

/// Create a copy of ApiTripType
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? image = freezed,Object? basePrice = freezed,Object? pricePerKm = freezed,Object? pricePerMinute = freezed,Object? estimatedTime = freezed,Object? isActive = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ApiTripType(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,basePrice: freezed == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as double?,pricePerKm: freezed == pricePerKm ? _self.pricePerKm : pricePerKm // ignore: cast_nullable_to_non_nullable
as double?,pricePerMinute: freezed == pricePerMinute ? _self.pricePerMinute : pricePerMinute // ignore: cast_nullable_to_non_nullable
as double?,estimatedTime: freezed == estimatedTime ? _self.estimatedTime : estimatedTime // ignore: cast_nullable_to_non_nullable
as int?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ApiTripOrder {

 int get id; int get tripId; String get status; String get pickupLocation; String get dropoffLocation; double? get price; String? get scheduledDate; String? get scheduledTime; int? get userId; int? get driverId; String? get driverName; String? get driverPhone; String? get driverAvatar; double? get driverRating; String? get vehicleType; String? get vehicleModel; String? get vehiclePlateNumber;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;@JsonKey(name: 'accepted_at') DateTime? get acceptedAt;@JsonKey(name: 'started_at') DateTime? get startedAt;@JsonKey(name: 'completed_at') DateTime? get completedAt;@JsonKey(name: 'cancelled_at') DateTime? get cancelledAt;
/// Create a copy of ApiTripOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiTripOrderCopyWith<ApiTripOrder> get copyWith => _$ApiTripOrderCopyWithImpl<ApiTripOrder>(this as ApiTripOrder, _$identity);

  /// Serializes this ApiTripOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiTripOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.status, status) || other.status == status)&&(identical(other.pickupLocation, pickupLocation) || other.pickupLocation == pickupLocation)&&(identical(other.dropoffLocation, dropoffLocation) || other.dropoffLocation == dropoffLocation)&&(identical(other.price, price) || other.price == price)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.driverName, driverName) || other.driverName == driverName)&&(identical(other.driverPhone, driverPhone) || other.driverPhone == driverPhone)&&(identical(other.driverAvatar, driverAvatar) || other.driverAvatar == driverAvatar)&&(identical(other.driverRating, driverRating) || other.driverRating == driverRating)&&(identical(other.vehicleType, vehicleType) || other.vehicleType == vehicleType)&&(identical(other.vehicleModel, vehicleModel) || other.vehicleModel == vehicleModel)&&(identical(other.vehiclePlateNumber, vehiclePlateNumber) || other.vehiclePlateNumber == vehiclePlateNumber)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.acceptedAt, acceptedAt) || other.acceptedAt == acceptedAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,tripId,status,pickupLocation,dropoffLocation,price,scheduledDate,scheduledTime,userId,driverId,driverName,driverPhone,driverAvatar,driverRating,vehicleType,vehicleModel,vehiclePlateNumber,createdAt,updatedAt,acceptedAt,startedAt,completedAt,cancelledAt]);

@override
String toString() {
  return 'ApiTripOrder(id: $id, tripId: $tripId, status: $status, pickupLocation: $pickupLocation, dropoffLocation: $dropoffLocation, price: $price, scheduledDate: $scheduledDate, scheduledTime: $scheduledTime, userId: $userId, driverId: $driverId, driverName: $driverName, driverPhone: $driverPhone, driverAvatar: $driverAvatar, driverRating: $driverRating, vehicleType: $vehicleType, vehicleModel: $vehicleModel, vehiclePlateNumber: $vehiclePlateNumber, createdAt: $createdAt, updatedAt: $updatedAt, acceptedAt: $acceptedAt, startedAt: $startedAt, completedAt: $completedAt, cancelledAt: $cancelledAt)';
}


}

/// @nodoc
abstract mixin class $ApiTripOrderCopyWith<$Res>  {
  factory $ApiTripOrderCopyWith(ApiTripOrder value, $Res Function(ApiTripOrder) _then) = _$ApiTripOrderCopyWithImpl;
@useResult
$Res call({
 int id, int tripId, String status, String pickupLocation, String dropoffLocation, double? price, String? scheduledDate, String? scheduledTime, int? userId, int? driverId, String? driverName, String? driverPhone, String? driverAvatar, double? driverRating, String? vehicleType, String? vehicleModel, String? vehiclePlateNumber,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'accepted_at') DateTime? acceptedAt,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'cancelled_at') DateTime? cancelledAt
});




}
/// @nodoc
class _$ApiTripOrderCopyWithImpl<$Res>
    implements $ApiTripOrderCopyWith<$Res> {
  _$ApiTripOrderCopyWithImpl(this._self, this._then);

  final ApiTripOrder _self;
  final $Res Function(ApiTripOrder) _then;

/// Create a copy of ApiTripOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tripId = null,Object? status = null,Object? pickupLocation = null,Object? dropoffLocation = null,Object? price = freezed,Object? scheduledDate = freezed,Object? scheduledTime = freezed,Object? userId = freezed,Object? driverId = freezed,Object? driverName = freezed,Object? driverPhone = freezed,Object? driverAvatar = freezed,Object? driverRating = freezed,Object? vehicleType = freezed,Object? vehicleModel = freezed,Object? vehiclePlateNumber = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? acceptedAt = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? cancelledAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,pickupLocation: null == pickupLocation ? _self.pickupLocation : pickupLocation // ignore: cast_nullable_to_non_nullable
as String,dropoffLocation: null == dropoffLocation ? _self.dropoffLocation : dropoffLocation // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,scheduledDate: freezed == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as String?,scheduledTime: freezed == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,driverId: freezed == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as int?,driverName: freezed == driverName ? _self.driverName : driverName // ignore: cast_nullable_to_non_nullable
as String?,driverPhone: freezed == driverPhone ? _self.driverPhone : driverPhone // ignore: cast_nullable_to_non_nullable
as String?,driverAvatar: freezed == driverAvatar ? _self.driverAvatar : driverAvatar // ignore: cast_nullable_to_non_nullable
as String?,driverRating: freezed == driverRating ? _self.driverRating : driverRating // ignore: cast_nullable_to_non_nullable
as double?,vehicleType: freezed == vehicleType ? _self.vehicleType : vehicleType // ignore: cast_nullable_to_non_nullable
as String?,vehicleModel: freezed == vehicleModel ? _self.vehicleModel : vehicleModel // ignore: cast_nullable_to_non_nullable
as String?,vehiclePlateNumber: freezed == vehiclePlateNumber ? _self.vehiclePlateNumber : vehiclePlateNumber // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acceptedAt: freezed == acceptedAt ? _self.acceptedAt : acceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiTripOrder].
extension ApiTripOrderPatterns on ApiTripOrder {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiTripOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiTripOrder() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiTripOrder value)  $default,){
final _that = this;
switch (_that) {
case _ApiTripOrder():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiTripOrder value)?  $default,){
final _that = this;
switch (_that) {
case _ApiTripOrder() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int tripId,  String status,  String pickupLocation,  String dropoffLocation,  double? price,  String? scheduledDate,  String? scheduledTime,  int? userId,  int? driverId,  String? driverName,  String? driverPhone,  String? driverAvatar,  double? driverRating,  String? vehicleType,  String? vehicleModel,  String? vehiclePlateNumber, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'accepted_at')  DateTime? acceptedAt, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'cancelled_at')  DateTime? cancelledAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiTripOrder() when $default != null:
return $default(_that.id,_that.tripId,_that.status,_that.pickupLocation,_that.dropoffLocation,_that.price,_that.scheduledDate,_that.scheduledTime,_that.userId,_that.driverId,_that.driverName,_that.driverPhone,_that.driverAvatar,_that.driverRating,_that.vehicleType,_that.vehicleModel,_that.vehiclePlateNumber,_that.createdAt,_that.updatedAt,_that.acceptedAt,_that.startedAt,_that.completedAt,_that.cancelledAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int tripId,  String status,  String pickupLocation,  String dropoffLocation,  double? price,  String? scheduledDate,  String? scheduledTime,  int? userId,  int? driverId,  String? driverName,  String? driverPhone,  String? driverAvatar,  double? driverRating,  String? vehicleType,  String? vehicleModel,  String? vehiclePlateNumber, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'accepted_at')  DateTime? acceptedAt, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'cancelled_at')  DateTime? cancelledAt)  $default,) {final _that = this;
switch (_that) {
case _ApiTripOrder():
return $default(_that.id,_that.tripId,_that.status,_that.pickupLocation,_that.dropoffLocation,_that.price,_that.scheduledDate,_that.scheduledTime,_that.userId,_that.driverId,_that.driverName,_that.driverPhone,_that.driverAvatar,_that.driverRating,_that.vehicleType,_that.vehicleModel,_that.vehiclePlateNumber,_that.createdAt,_that.updatedAt,_that.acceptedAt,_that.startedAt,_that.completedAt,_that.cancelledAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int tripId,  String status,  String pickupLocation,  String dropoffLocation,  double? price,  String? scheduledDate,  String? scheduledTime,  int? userId,  int? driverId,  String? driverName,  String? driverPhone,  String? driverAvatar,  double? driverRating,  String? vehicleType,  String? vehicleModel,  String? vehiclePlateNumber, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'accepted_at')  DateTime? acceptedAt, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'cancelled_at')  DateTime? cancelledAt)?  $default,) {final _that = this;
switch (_that) {
case _ApiTripOrder() when $default != null:
return $default(_that.id,_that.tripId,_that.status,_that.pickupLocation,_that.dropoffLocation,_that.price,_that.scheduledDate,_that.scheduledTime,_that.userId,_that.driverId,_that.driverName,_that.driverPhone,_that.driverAvatar,_that.driverRating,_that.vehicleType,_that.vehicleModel,_that.vehiclePlateNumber,_that.createdAt,_that.updatedAt,_that.acceptedAt,_that.startedAt,_that.completedAt,_that.cancelledAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiTripOrder implements ApiTripOrder {
  const _ApiTripOrder({required this.id, required this.tripId, required this.status, required this.pickupLocation, required this.dropoffLocation, this.price, this.scheduledDate, this.scheduledTime, this.userId, this.driverId, this.driverName, this.driverPhone, this.driverAvatar, this.driverRating, this.vehicleType, this.vehicleModel, this.vehiclePlateNumber, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(name: 'accepted_at') this.acceptedAt, @JsonKey(name: 'started_at') this.startedAt, @JsonKey(name: 'completed_at') this.completedAt, @JsonKey(name: 'cancelled_at') this.cancelledAt});
  factory _ApiTripOrder.fromJson(Map<String, dynamic> json) => _$ApiTripOrderFromJson(json);

@override final  int id;
@override final  int tripId;
@override final  String status;
@override final  String pickupLocation;
@override final  String dropoffLocation;
@override final  double? price;
@override final  String? scheduledDate;
@override final  String? scheduledTime;
@override final  int? userId;
@override final  int? driverId;
@override final  String? driverName;
@override final  String? driverPhone;
@override final  String? driverAvatar;
@override final  double? driverRating;
@override final  String? vehicleType;
@override final  String? vehicleModel;
@override final  String? vehiclePlateNumber;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
@override@JsonKey(name: 'accepted_at') final  DateTime? acceptedAt;
@override@JsonKey(name: 'started_at') final  DateTime? startedAt;
@override@JsonKey(name: 'completed_at') final  DateTime? completedAt;
@override@JsonKey(name: 'cancelled_at') final  DateTime? cancelledAt;

/// Create a copy of ApiTripOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiTripOrderCopyWith<_ApiTripOrder> get copyWith => __$ApiTripOrderCopyWithImpl<_ApiTripOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiTripOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiTripOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.status, status) || other.status == status)&&(identical(other.pickupLocation, pickupLocation) || other.pickupLocation == pickupLocation)&&(identical(other.dropoffLocation, dropoffLocation) || other.dropoffLocation == dropoffLocation)&&(identical(other.price, price) || other.price == price)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.driverName, driverName) || other.driverName == driverName)&&(identical(other.driverPhone, driverPhone) || other.driverPhone == driverPhone)&&(identical(other.driverAvatar, driverAvatar) || other.driverAvatar == driverAvatar)&&(identical(other.driverRating, driverRating) || other.driverRating == driverRating)&&(identical(other.vehicleType, vehicleType) || other.vehicleType == vehicleType)&&(identical(other.vehicleModel, vehicleModel) || other.vehicleModel == vehicleModel)&&(identical(other.vehiclePlateNumber, vehiclePlateNumber) || other.vehiclePlateNumber == vehiclePlateNumber)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.acceptedAt, acceptedAt) || other.acceptedAt == acceptedAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,tripId,status,pickupLocation,dropoffLocation,price,scheduledDate,scheduledTime,userId,driverId,driverName,driverPhone,driverAvatar,driverRating,vehicleType,vehicleModel,vehiclePlateNumber,createdAt,updatedAt,acceptedAt,startedAt,completedAt,cancelledAt]);

@override
String toString() {
  return 'ApiTripOrder(id: $id, tripId: $tripId, status: $status, pickupLocation: $pickupLocation, dropoffLocation: $dropoffLocation, price: $price, scheduledDate: $scheduledDate, scheduledTime: $scheduledTime, userId: $userId, driverId: $driverId, driverName: $driverName, driverPhone: $driverPhone, driverAvatar: $driverAvatar, driverRating: $driverRating, vehicleType: $vehicleType, vehicleModel: $vehicleModel, vehiclePlateNumber: $vehiclePlateNumber, createdAt: $createdAt, updatedAt: $updatedAt, acceptedAt: $acceptedAt, startedAt: $startedAt, completedAt: $completedAt, cancelledAt: $cancelledAt)';
}


}

/// @nodoc
abstract mixin class _$ApiTripOrderCopyWith<$Res> implements $ApiTripOrderCopyWith<$Res> {
  factory _$ApiTripOrderCopyWith(_ApiTripOrder value, $Res Function(_ApiTripOrder) _then) = __$ApiTripOrderCopyWithImpl;
@override @useResult
$Res call({
 int id, int tripId, String status, String pickupLocation, String dropoffLocation, double? price, String? scheduledDate, String? scheduledTime, int? userId, int? driverId, String? driverName, String? driverPhone, String? driverAvatar, double? driverRating, String? vehicleType, String? vehicleModel, String? vehiclePlateNumber,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'accepted_at') DateTime? acceptedAt,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'cancelled_at') DateTime? cancelledAt
});




}
/// @nodoc
class __$ApiTripOrderCopyWithImpl<$Res>
    implements _$ApiTripOrderCopyWith<$Res> {
  __$ApiTripOrderCopyWithImpl(this._self, this._then);

  final _ApiTripOrder _self;
  final $Res Function(_ApiTripOrder) _then;

/// Create a copy of ApiTripOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tripId = null,Object? status = null,Object? pickupLocation = null,Object? dropoffLocation = null,Object? price = freezed,Object? scheduledDate = freezed,Object? scheduledTime = freezed,Object? userId = freezed,Object? driverId = freezed,Object? driverName = freezed,Object? driverPhone = freezed,Object? driverAvatar = freezed,Object? driverRating = freezed,Object? vehicleType = freezed,Object? vehicleModel = freezed,Object? vehiclePlateNumber = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? acceptedAt = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? cancelledAt = freezed,}) {
  return _then(_ApiTripOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,pickupLocation: null == pickupLocation ? _self.pickupLocation : pickupLocation // ignore: cast_nullable_to_non_nullable
as String,dropoffLocation: null == dropoffLocation ? _self.dropoffLocation : dropoffLocation // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,scheduledDate: freezed == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as String?,scheduledTime: freezed == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,driverId: freezed == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as int?,driverName: freezed == driverName ? _self.driverName : driverName // ignore: cast_nullable_to_non_nullable
as String?,driverPhone: freezed == driverPhone ? _self.driverPhone : driverPhone // ignore: cast_nullable_to_non_nullable
as String?,driverAvatar: freezed == driverAvatar ? _self.driverAvatar : driverAvatar // ignore: cast_nullable_to_non_nullable
as String?,driverRating: freezed == driverRating ? _self.driverRating : driverRating // ignore: cast_nullable_to_non_nullable
as double?,vehicleType: freezed == vehicleType ? _self.vehicleType : vehicleType // ignore: cast_nullable_to_non_nullable
as String?,vehicleModel: freezed == vehicleModel ? _self.vehicleModel : vehicleModel // ignore: cast_nullable_to_non_nullable
as String?,vehiclePlateNumber: freezed == vehiclePlateNumber ? _self.vehiclePlateNumber : vehiclePlateNumber // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acceptedAt: freezed == acceptedAt ? _self.acceptedAt : acceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ApiTripEvaluation {

 int get id; int get tripId; int get rating; String? get comment; int? get userId; int? get driverId;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of ApiTripEvaluation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiTripEvaluationCopyWith<ApiTripEvaluation> get copyWith => _$ApiTripEvaluationCopyWithImpl<ApiTripEvaluation>(this as ApiTripEvaluation, _$identity);

  /// Serializes this ApiTripEvaluation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiTripEvaluation&&(identical(other.id, id) || other.id == id)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tripId,rating,comment,userId,driverId,createdAt,updatedAt);

@override
String toString() {
  return 'ApiTripEvaluation(id: $id, tripId: $tripId, rating: $rating, comment: $comment, userId: $userId, driverId: $driverId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ApiTripEvaluationCopyWith<$Res>  {
  factory $ApiTripEvaluationCopyWith(ApiTripEvaluation value, $Res Function(ApiTripEvaluation) _then) = _$ApiTripEvaluationCopyWithImpl;
@useResult
$Res call({
 int id, int tripId, int rating, String? comment, int? userId, int? driverId,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$ApiTripEvaluationCopyWithImpl<$Res>
    implements $ApiTripEvaluationCopyWith<$Res> {
  _$ApiTripEvaluationCopyWithImpl(this._self, this._then);

  final ApiTripEvaluation _self;
  final $Res Function(ApiTripEvaluation) _then;

/// Create a copy of ApiTripEvaluation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tripId = null,Object? rating = null,Object? comment = freezed,Object? userId = freezed,Object? driverId = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as int,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,driverId: freezed == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiTripEvaluation].
extension ApiTripEvaluationPatterns on ApiTripEvaluation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiTripEvaluation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiTripEvaluation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiTripEvaluation value)  $default,){
final _that = this;
switch (_that) {
case _ApiTripEvaluation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiTripEvaluation value)?  $default,){
final _that = this;
switch (_that) {
case _ApiTripEvaluation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int tripId,  int rating,  String? comment,  int? userId,  int? driverId, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiTripEvaluation() when $default != null:
return $default(_that.id,_that.tripId,_that.rating,_that.comment,_that.userId,_that.driverId,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int tripId,  int rating,  String? comment,  int? userId,  int? driverId, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ApiTripEvaluation():
return $default(_that.id,_that.tripId,_that.rating,_that.comment,_that.userId,_that.driverId,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int tripId,  int rating,  String? comment,  int? userId,  int? driverId, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ApiTripEvaluation() when $default != null:
return $default(_that.id,_that.tripId,_that.rating,_that.comment,_that.userId,_that.driverId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiTripEvaluation implements ApiTripEvaluation {
  const _ApiTripEvaluation({required this.id, required this.tripId, required this.rating, this.comment, this.userId, this.driverId, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _ApiTripEvaluation.fromJson(Map<String, dynamic> json) => _$ApiTripEvaluationFromJson(json);

@override final  int id;
@override final  int tripId;
@override final  int rating;
@override final  String? comment;
@override final  int? userId;
@override final  int? driverId;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of ApiTripEvaluation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiTripEvaluationCopyWith<_ApiTripEvaluation> get copyWith => __$ApiTripEvaluationCopyWithImpl<_ApiTripEvaluation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiTripEvaluationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiTripEvaluation&&(identical(other.id, id) || other.id == id)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tripId,rating,comment,userId,driverId,createdAt,updatedAt);

@override
String toString() {
  return 'ApiTripEvaluation(id: $id, tripId: $tripId, rating: $rating, comment: $comment, userId: $userId, driverId: $driverId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ApiTripEvaluationCopyWith<$Res> implements $ApiTripEvaluationCopyWith<$Res> {
  factory _$ApiTripEvaluationCopyWith(_ApiTripEvaluation value, $Res Function(_ApiTripEvaluation) _then) = __$ApiTripEvaluationCopyWithImpl;
@override @useResult
$Res call({
 int id, int tripId, int rating, String? comment, int? userId, int? driverId,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$ApiTripEvaluationCopyWithImpl<$Res>
    implements _$ApiTripEvaluationCopyWith<$Res> {
  __$ApiTripEvaluationCopyWithImpl(this._self, this._then);

  final _ApiTripEvaluation _self;
  final $Res Function(_ApiTripEvaluation) _then;

/// Create a copy of ApiTripEvaluation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tripId = null,Object? rating = null,Object? comment = freezed,Object? userId = freezed,Object? driverId = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ApiTripEvaluation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as int,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,driverId: freezed == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
