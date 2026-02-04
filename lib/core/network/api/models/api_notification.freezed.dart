// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApiNotification {

/// Notification ID
 int get id;/// Notification title
 String get title;/// Notification message/body
 String get message;/// Notification type (e.g., 'trip', 'payment', 'system')
 String? get type;/// Whether the notification has been read
 bool get isRead;/// Notification data (additional information)
 Map<String, dynamic>? get data;/// Created at timestamp
 String? get createdAt;/// Updated at timestamp
 String? get updatedAt;
/// Create a copy of ApiNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiNotificationCopyWith<ApiNotification> get copyWith => _$ApiNotificationCopyWithImpl<ApiNotification>(this as ApiNotification, _$identity);

  /// Serializes this ApiNotification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.type, type) || other.type == type)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,message,type,isRead,const DeepCollectionEquality().hash(data),createdAt,updatedAt);

@override
String toString() {
  return 'ApiNotification(id: $id, title: $title, message: $message, type: $type, isRead: $isRead, data: $data, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ApiNotificationCopyWith<$Res>  {
  factory $ApiNotificationCopyWith(ApiNotification value, $Res Function(ApiNotification) _then) = _$ApiNotificationCopyWithImpl;
@useResult
$Res call({
 int id, String title, String message, String? type, bool isRead, Map<String, dynamic>? data, String? createdAt, String? updatedAt
});




}
/// @nodoc
class _$ApiNotificationCopyWithImpl<$Res>
    implements $ApiNotificationCopyWith<$Res> {
  _$ApiNotificationCopyWithImpl(this._self, this._then);

  final ApiNotification _self;
  final $Res Function(ApiNotification) _then;

/// Create a copy of ApiNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? message = null,Object? type = freezed,Object? isRead = null,Object? data = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiNotification].
extension ApiNotificationPatterns on ApiNotification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiNotification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiNotification value)  $default,){
final _that = this;
switch (_that) {
case _ApiNotification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiNotification value)?  $default,){
final _that = this;
switch (_that) {
case _ApiNotification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String message,  String? type,  bool isRead,  Map<String, dynamic>? data,  String? createdAt,  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiNotification() when $default != null:
return $default(_that.id,_that.title,_that.message,_that.type,_that.isRead,_that.data,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String message,  String? type,  bool isRead,  Map<String, dynamic>? data,  String? createdAt,  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ApiNotification():
return $default(_that.id,_that.title,_that.message,_that.type,_that.isRead,_that.data,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String message,  String? type,  bool isRead,  Map<String, dynamic>? data,  String? createdAt,  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ApiNotification() when $default != null:
return $default(_that.id,_that.title,_that.message,_that.type,_that.isRead,_that.data,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiNotification implements ApiNotification {
  const _ApiNotification({required this.id, required this.title, required this.message, this.type, this.isRead = false, final  Map<String, dynamic>? data, this.createdAt, this.updatedAt}): _data = data;
  factory _ApiNotification.fromJson(Map<String, dynamic> json) => _$ApiNotificationFromJson(json);

/// Notification ID
@override final  int id;
/// Notification title
@override final  String title;
/// Notification message/body
@override final  String message;
/// Notification type (e.g., 'trip', 'payment', 'system')
@override final  String? type;
/// Whether the notification has been read
@override@JsonKey() final  bool isRead;
/// Notification data (additional information)
 final  Map<String, dynamic>? _data;
/// Notification data (additional information)
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

/// Created at timestamp
@override final  String? createdAt;
/// Updated at timestamp
@override final  String? updatedAt;

/// Create a copy of ApiNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiNotificationCopyWith<_ApiNotification> get copyWith => __$ApiNotificationCopyWithImpl<_ApiNotification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiNotificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.type, type) || other.type == type)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,message,type,isRead,const DeepCollectionEquality().hash(_data),createdAt,updatedAt);

@override
String toString() {
  return 'ApiNotification(id: $id, title: $title, message: $message, type: $type, isRead: $isRead, data: $data, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ApiNotificationCopyWith<$Res> implements $ApiNotificationCopyWith<$Res> {
  factory _$ApiNotificationCopyWith(_ApiNotification value, $Res Function(_ApiNotification) _then) = __$ApiNotificationCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String message, String? type, bool isRead, Map<String, dynamic>? data, String? createdAt, String? updatedAt
});




}
/// @nodoc
class __$ApiNotificationCopyWithImpl<$Res>
    implements _$ApiNotificationCopyWith<$Res> {
  __$ApiNotificationCopyWithImpl(this._self, this._then);

  final _ApiNotification _self;
  final $Res Function(_ApiNotification) _then;

/// Create a copy of ApiNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? message = null,Object? type = freezed,Object? isRead = null,Object? data = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ApiNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ApiNotificationCount {

/// Total count of unread notifications
 int get count;/// Total count of all notifications
 int? get totalCount;
/// Create a copy of ApiNotificationCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiNotificationCountCopyWith<ApiNotificationCount> get copyWith => _$ApiNotificationCountCopyWithImpl<ApiNotificationCount>(this as ApiNotificationCount, _$identity);

  /// Serializes this ApiNotificationCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiNotificationCount&&(identical(other.count, count) || other.count == count)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,totalCount);

@override
String toString() {
  return 'ApiNotificationCount(count: $count, totalCount: $totalCount)';
}


}

/// @nodoc
abstract mixin class $ApiNotificationCountCopyWith<$Res>  {
  factory $ApiNotificationCountCopyWith(ApiNotificationCount value, $Res Function(ApiNotificationCount) _then) = _$ApiNotificationCountCopyWithImpl;
@useResult
$Res call({
 int count, int? totalCount
});




}
/// @nodoc
class _$ApiNotificationCountCopyWithImpl<$Res>
    implements $ApiNotificationCountCopyWith<$Res> {
  _$ApiNotificationCountCopyWithImpl(this._self, this._then);

  final ApiNotificationCount _self;
  final $Res Function(ApiNotificationCount) _then;

/// Create a copy of ApiNotificationCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? totalCount = freezed,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,totalCount: freezed == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiNotificationCount].
extension ApiNotificationCountPatterns on ApiNotificationCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiNotificationCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiNotificationCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiNotificationCount value)  $default,){
final _that = this;
switch (_that) {
case _ApiNotificationCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiNotificationCount value)?  $default,){
final _that = this;
switch (_that) {
case _ApiNotificationCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  int? totalCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiNotificationCount() when $default != null:
return $default(_that.count,_that.totalCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  int? totalCount)  $default,) {final _that = this;
switch (_that) {
case _ApiNotificationCount():
return $default(_that.count,_that.totalCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  int? totalCount)?  $default,) {final _that = this;
switch (_that) {
case _ApiNotificationCount() when $default != null:
return $default(_that.count,_that.totalCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiNotificationCount implements ApiNotificationCount {
  const _ApiNotificationCount({required this.count, this.totalCount});
  factory _ApiNotificationCount.fromJson(Map<String, dynamic> json) => _$ApiNotificationCountFromJson(json);

/// Total count of unread notifications
@override final  int count;
/// Total count of all notifications
@override final  int? totalCount;

/// Create a copy of ApiNotificationCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiNotificationCountCopyWith<_ApiNotificationCount> get copyWith => __$ApiNotificationCountCopyWithImpl<_ApiNotificationCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiNotificationCountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiNotificationCount&&(identical(other.count, count) || other.count == count)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,totalCount);

@override
String toString() {
  return 'ApiNotificationCount(count: $count, totalCount: $totalCount)';
}


}

/// @nodoc
abstract mixin class _$ApiNotificationCountCopyWith<$Res> implements $ApiNotificationCountCopyWith<$Res> {
  factory _$ApiNotificationCountCopyWith(_ApiNotificationCount value, $Res Function(_ApiNotificationCount) _then) = __$ApiNotificationCountCopyWithImpl;
@override @useResult
$Res call({
 int count, int? totalCount
});




}
/// @nodoc
class __$ApiNotificationCountCopyWithImpl<$Res>
    implements _$ApiNotificationCountCopyWith<$Res> {
  __$ApiNotificationCountCopyWithImpl(this._self, this._then);

  final _ApiNotificationCount _self;
  final $Res Function(_ApiNotificationCount) _then;

/// Create a copy of ApiNotificationCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? totalCount = freezed,}) {
  return _then(_ApiNotificationCount(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,totalCount: freezed == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
