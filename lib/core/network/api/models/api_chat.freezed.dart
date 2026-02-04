// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_chat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApiChatMessage {

/// Message ID
 int get id;/// Order ID
 int get orderId;/// Driver ID
 int get driverId;/// User ID (sender)
 int get userId;/// Message content
 String get message;/// Whether the message is from the user (true) or driver (false)
 bool get isFromUser;/// Message status (e.g., 'sent', 'delivered', 'read')
 String? get status;/// Created at timestamp
 String? get createdAt;/// Updated at timestamp
 String? get updatedAt;/// Driver information (if available)
 ApiChatDriver? get driver;/// User information (if available)
 ApiChatUser? get user;
/// Create a copy of ApiChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiChatMessageCopyWith<ApiChatMessage> get copyWith => _$ApiChatMessageCopyWithImpl<ApiChatMessage>(this as ApiChatMessage, _$identity);

  /// Serializes this ApiChatMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.message, message) || other.message == message)&&(identical(other.isFromUser, isFromUser) || other.isFromUser == isFromUser)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.driver, driver) || other.driver == driver)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,driverId,userId,message,isFromUser,status,createdAt,updatedAt,driver,user);

@override
String toString() {
  return 'ApiChatMessage(id: $id, orderId: $orderId, driverId: $driverId, userId: $userId, message: $message, isFromUser: $isFromUser, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, driver: $driver, user: $user)';
}


}

/// @nodoc
abstract mixin class $ApiChatMessageCopyWith<$Res>  {
  factory $ApiChatMessageCopyWith(ApiChatMessage value, $Res Function(ApiChatMessage) _then) = _$ApiChatMessageCopyWithImpl;
@useResult
$Res call({
 int id, int orderId, int driverId, int userId, String message, bool isFromUser, String? status, String? createdAt, String? updatedAt, ApiChatDriver? driver, ApiChatUser? user
});


$ApiChatDriverCopyWith<$Res>? get driver;$ApiChatUserCopyWith<$Res>? get user;

}
/// @nodoc
class _$ApiChatMessageCopyWithImpl<$Res>
    implements $ApiChatMessageCopyWith<$Res> {
  _$ApiChatMessageCopyWithImpl(this._self, this._then);

  final ApiChatMessage _self;
  final $Res Function(ApiChatMessage) _then;

/// Create a copy of ApiChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = null,Object? driverId = null,Object? userId = null,Object? message = null,Object? isFromUser = null,Object? status = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? driver = freezed,Object? user = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,driverId: null == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isFromUser: null == isFromUser ? _self.isFromUser : isFromUser // ignore: cast_nullable_to_non_nullable
as bool,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,driver: freezed == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as ApiChatDriver?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ApiChatUser?,
  ));
}
/// Create a copy of ApiChatMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiChatDriverCopyWith<$Res>? get driver {
    if (_self.driver == null) {
    return null;
  }

  return $ApiChatDriverCopyWith<$Res>(_self.driver!, (value) {
    return _then(_self.copyWith(driver: value));
  });
}/// Create a copy of ApiChatMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiChatUserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $ApiChatUserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [ApiChatMessage].
extension ApiChatMessagePatterns on ApiChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _ApiChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ApiChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int orderId,  int driverId,  int userId,  String message,  bool isFromUser,  String? status,  String? createdAt,  String? updatedAt,  ApiChatDriver? driver,  ApiChatUser? user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiChatMessage() when $default != null:
return $default(_that.id,_that.orderId,_that.driverId,_that.userId,_that.message,_that.isFromUser,_that.status,_that.createdAt,_that.updatedAt,_that.driver,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int orderId,  int driverId,  int userId,  String message,  bool isFromUser,  String? status,  String? createdAt,  String? updatedAt,  ApiChatDriver? driver,  ApiChatUser? user)  $default,) {final _that = this;
switch (_that) {
case _ApiChatMessage():
return $default(_that.id,_that.orderId,_that.driverId,_that.userId,_that.message,_that.isFromUser,_that.status,_that.createdAt,_that.updatedAt,_that.driver,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int orderId,  int driverId,  int userId,  String message,  bool isFromUser,  String? status,  String? createdAt,  String? updatedAt,  ApiChatDriver? driver,  ApiChatUser? user)?  $default,) {final _that = this;
switch (_that) {
case _ApiChatMessage() when $default != null:
return $default(_that.id,_that.orderId,_that.driverId,_that.userId,_that.message,_that.isFromUser,_that.status,_that.createdAt,_that.updatedAt,_that.driver,_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiChatMessage implements ApiChatMessage {
  const _ApiChatMessage({required this.id, required this.orderId, required this.driverId, required this.userId, required this.message, required this.isFromUser, this.status, this.createdAt, this.updatedAt, this.driver, this.user});
  factory _ApiChatMessage.fromJson(Map<String, dynamic> json) => _$ApiChatMessageFromJson(json);

/// Message ID
@override final  int id;
/// Order ID
@override final  int orderId;
/// Driver ID
@override final  int driverId;
/// User ID (sender)
@override final  int userId;
/// Message content
@override final  String message;
/// Whether the message is from the user (true) or driver (false)
@override final  bool isFromUser;
/// Message status (e.g., 'sent', 'delivered', 'read')
@override final  String? status;
/// Created at timestamp
@override final  String? createdAt;
/// Updated at timestamp
@override final  String? updatedAt;
/// Driver information (if available)
@override final  ApiChatDriver? driver;
/// User information (if available)
@override final  ApiChatUser? user;

/// Create a copy of ApiChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiChatMessageCopyWith<_ApiChatMessage> get copyWith => __$ApiChatMessageCopyWithImpl<_ApiChatMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiChatMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.message, message) || other.message == message)&&(identical(other.isFromUser, isFromUser) || other.isFromUser == isFromUser)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.driver, driver) || other.driver == driver)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,driverId,userId,message,isFromUser,status,createdAt,updatedAt,driver,user);

@override
String toString() {
  return 'ApiChatMessage(id: $id, orderId: $orderId, driverId: $driverId, userId: $userId, message: $message, isFromUser: $isFromUser, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, driver: $driver, user: $user)';
}


}

/// @nodoc
abstract mixin class _$ApiChatMessageCopyWith<$Res> implements $ApiChatMessageCopyWith<$Res> {
  factory _$ApiChatMessageCopyWith(_ApiChatMessage value, $Res Function(_ApiChatMessage) _then) = __$ApiChatMessageCopyWithImpl;
@override @useResult
$Res call({
 int id, int orderId, int driverId, int userId, String message, bool isFromUser, String? status, String? createdAt, String? updatedAt, ApiChatDriver? driver, ApiChatUser? user
});


@override $ApiChatDriverCopyWith<$Res>? get driver;@override $ApiChatUserCopyWith<$Res>? get user;

}
/// @nodoc
class __$ApiChatMessageCopyWithImpl<$Res>
    implements _$ApiChatMessageCopyWith<$Res> {
  __$ApiChatMessageCopyWithImpl(this._self, this._then);

  final _ApiChatMessage _self;
  final $Res Function(_ApiChatMessage) _then;

/// Create a copy of ApiChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = null,Object? driverId = null,Object? userId = null,Object? message = null,Object? isFromUser = null,Object? status = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? driver = freezed,Object? user = freezed,}) {
  return _then(_ApiChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,driverId: null == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isFromUser: null == isFromUser ? _self.isFromUser : isFromUser // ignore: cast_nullable_to_non_nullable
as bool,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,driver: freezed == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as ApiChatDriver?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ApiChatUser?,
  ));
}

/// Create a copy of ApiChatMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiChatDriverCopyWith<$Res>? get driver {
    if (_self.driver == null) {
    return null;
  }

  return $ApiChatDriverCopyWith<$Res>(_self.driver!, (value) {
    return _then(_self.copyWith(driver: value));
  });
}/// Create a copy of ApiChatMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiChatUserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $ApiChatUserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$ApiChatDriver {

/// Driver ID
 int get id;/// Driver name
 String? get name;/// Driver phone
 String? get phone;/// Driver image/avatar URL
 String? get image;
/// Create a copy of ApiChatDriver
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiChatDriverCopyWith<ApiChatDriver> get copyWith => _$ApiChatDriverCopyWithImpl<ApiChatDriver>(this as ApiChatDriver, _$identity);

  /// Serializes this ApiChatDriver to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiChatDriver&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,image);

@override
String toString() {
  return 'ApiChatDriver(id: $id, name: $name, phone: $phone, image: $image)';
}


}

/// @nodoc
abstract mixin class $ApiChatDriverCopyWith<$Res>  {
  factory $ApiChatDriverCopyWith(ApiChatDriver value, $Res Function(ApiChatDriver) _then) = _$ApiChatDriverCopyWithImpl;
@useResult
$Res call({
 int id, String? name, String? phone, String? image
});




}
/// @nodoc
class _$ApiChatDriverCopyWithImpl<$Res>
    implements $ApiChatDriverCopyWith<$Res> {
  _$ApiChatDriverCopyWithImpl(this._self, this._then);

  final ApiChatDriver _self;
  final $Res Function(ApiChatDriver) _then;

/// Create a copy of ApiChatDriver
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? phone = freezed,Object? image = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiChatDriver].
extension ApiChatDriverPatterns on ApiChatDriver {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiChatDriver value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiChatDriver() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiChatDriver value)  $default,){
final _that = this;
switch (_that) {
case _ApiChatDriver():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiChatDriver value)?  $default,){
final _that = this;
switch (_that) {
case _ApiChatDriver() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? name,  String? phone,  String? image)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiChatDriver() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.image);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? name,  String? phone,  String? image)  $default,) {final _that = this;
switch (_that) {
case _ApiChatDriver():
return $default(_that.id,_that.name,_that.phone,_that.image);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? name,  String? phone,  String? image)?  $default,) {final _that = this;
switch (_that) {
case _ApiChatDriver() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.image);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiChatDriver implements ApiChatDriver {
  const _ApiChatDriver({required this.id, this.name, this.phone, this.image});
  factory _ApiChatDriver.fromJson(Map<String, dynamic> json) => _$ApiChatDriverFromJson(json);

/// Driver ID
@override final  int id;
/// Driver name
@override final  String? name;
/// Driver phone
@override final  String? phone;
/// Driver image/avatar URL
@override final  String? image;

/// Create a copy of ApiChatDriver
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiChatDriverCopyWith<_ApiChatDriver> get copyWith => __$ApiChatDriverCopyWithImpl<_ApiChatDriver>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiChatDriverToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiChatDriver&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,image);

@override
String toString() {
  return 'ApiChatDriver(id: $id, name: $name, phone: $phone, image: $image)';
}


}

/// @nodoc
abstract mixin class _$ApiChatDriverCopyWith<$Res> implements $ApiChatDriverCopyWith<$Res> {
  factory _$ApiChatDriverCopyWith(_ApiChatDriver value, $Res Function(_ApiChatDriver) _then) = __$ApiChatDriverCopyWithImpl;
@override @useResult
$Res call({
 int id, String? name, String? phone, String? image
});




}
/// @nodoc
class __$ApiChatDriverCopyWithImpl<$Res>
    implements _$ApiChatDriverCopyWith<$Res> {
  __$ApiChatDriverCopyWithImpl(this._self, this._then);

  final _ApiChatDriver _self;
  final $Res Function(_ApiChatDriver) _then;

/// Create a copy of ApiChatDriver
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? phone = freezed,Object? image = freezed,}) {
  return _then(_ApiChatDriver(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ApiChatUser {

/// User ID
 int get id;/// User name
 String? get name;/// User phone
 String? get phone;/// User image/avatar URL
 String? get image;
/// Create a copy of ApiChatUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiChatUserCopyWith<ApiChatUser> get copyWith => _$ApiChatUserCopyWithImpl<ApiChatUser>(this as ApiChatUser, _$identity);

  /// Serializes this ApiChatUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiChatUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,image);

@override
String toString() {
  return 'ApiChatUser(id: $id, name: $name, phone: $phone, image: $image)';
}


}

/// @nodoc
abstract mixin class $ApiChatUserCopyWith<$Res>  {
  factory $ApiChatUserCopyWith(ApiChatUser value, $Res Function(ApiChatUser) _then) = _$ApiChatUserCopyWithImpl;
@useResult
$Res call({
 int id, String? name, String? phone, String? image
});




}
/// @nodoc
class _$ApiChatUserCopyWithImpl<$Res>
    implements $ApiChatUserCopyWith<$Res> {
  _$ApiChatUserCopyWithImpl(this._self, this._then);

  final ApiChatUser _self;
  final $Res Function(ApiChatUser) _then;

/// Create a copy of ApiChatUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? phone = freezed,Object? image = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiChatUser].
extension ApiChatUserPatterns on ApiChatUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiChatUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiChatUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiChatUser value)  $default,){
final _that = this;
switch (_that) {
case _ApiChatUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiChatUser value)?  $default,){
final _that = this;
switch (_that) {
case _ApiChatUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? name,  String? phone,  String? image)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiChatUser() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.image);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? name,  String? phone,  String? image)  $default,) {final _that = this;
switch (_that) {
case _ApiChatUser():
return $default(_that.id,_that.name,_that.phone,_that.image);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? name,  String? phone,  String? image)?  $default,) {final _that = this;
switch (_that) {
case _ApiChatUser() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.image);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiChatUser implements ApiChatUser {
  const _ApiChatUser({required this.id, this.name, this.phone, this.image});
  factory _ApiChatUser.fromJson(Map<String, dynamic> json) => _$ApiChatUserFromJson(json);

/// User ID
@override final  int id;
/// User name
@override final  String? name;
/// User phone
@override final  String? phone;
/// User image/avatar URL
@override final  String? image;

/// Create a copy of ApiChatUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiChatUserCopyWith<_ApiChatUser> get copyWith => __$ApiChatUserCopyWithImpl<_ApiChatUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiChatUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiChatUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,image);

@override
String toString() {
  return 'ApiChatUser(id: $id, name: $name, phone: $phone, image: $image)';
}


}

/// @nodoc
abstract mixin class _$ApiChatUserCopyWith<$Res> implements $ApiChatUserCopyWith<$Res> {
  factory _$ApiChatUserCopyWith(_ApiChatUser value, $Res Function(_ApiChatUser) _then) = __$ApiChatUserCopyWithImpl;
@override @useResult
$Res call({
 int id, String? name, String? phone, String? image
});




}
/// @nodoc
class __$ApiChatUserCopyWithImpl<$Res>
    implements _$ApiChatUserCopyWith<$Res> {
  __$ApiChatUserCopyWithImpl(this._self, this._then);

  final _ApiChatUser _self;
  final $Res Function(_ApiChatUser) _then;

/// Create a copy of ApiChatUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? phone = freezed,Object? image = freezed,}) {
  return _then(_ApiChatUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
