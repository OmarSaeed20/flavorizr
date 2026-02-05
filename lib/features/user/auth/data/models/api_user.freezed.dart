// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApiUser {

 int get id; String get name; String? get nickname; String get phone; String? get email; String? get country; String? get governorate; String? get birthdate; String? get gender; String? get avatar; String? get deviceType; String? get deviceToken; String? get deviceId;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of ApiUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiUserCopyWith<ApiUser> get copyWith => _$ApiUserCopyWithImpl<ApiUser>(this as ApiUser, _$identity);

  /// Serializes this ApiUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.country, country) || other.country == country)&&(identical(other.governorate, governorate) || other.governorate == governorate)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.deviceToken, deviceToken) || other.deviceToken == deviceToken)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nickname,phone,email,country,governorate,birthdate,gender,avatar,deviceType,deviceToken,deviceId,createdAt,updatedAt);

@override
String toString() {
  return 'ApiUser(id: $id, name: $name, nickname: $nickname, phone: $phone, email: $email, country: $country, governorate: $governorate, birthdate: $birthdate, gender: $gender, avatar: $avatar, deviceType: $deviceType, deviceToken: $deviceToken, deviceId: $deviceId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ApiUserCopyWith<$Res>  {
  factory $ApiUserCopyWith(ApiUser value, $Res Function(ApiUser) _then) = _$ApiUserCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? nickname, String phone, String? email, String? country, String? governorate, String? birthdate, String? gender, String? avatar, String? deviceType, String? deviceToken, String? deviceId,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$ApiUserCopyWithImpl<$Res>
    implements $ApiUserCopyWith<$Res> {
  _$ApiUserCopyWithImpl(this._self, this._then);

  final ApiUser _self;
  final $Res Function(ApiUser) _then;

/// Create a copy of ApiUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nickname = freezed,Object? phone = null,Object? email = freezed,Object? country = freezed,Object? governorate = freezed,Object? birthdate = freezed,Object? gender = freezed,Object? avatar = freezed,Object? deviceType = freezed,Object? deviceToken = freezed,Object? deviceId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,governorate: freezed == governorate ? _self.governorate : governorate // ignore: cast_nullable_to_non_nullable
as String?,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,deviceType: freezed == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as String?,deviceToken: freezed == deviceToken ? _self.deviceToken : deviceToken // ignore: cast_nullable_to_non_nullable
as String?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiUser].
extension ApiUserPatterns on ApiUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiUser value)  $default,){
final _that = this;
switch (_that) {
case _ApiUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiUser value)?  $default,){
final _that = this;
switch (_that) {
case _ApiUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? nickname,  String phone,  String? email,  String? country,  String? governorate,  String? birthdate,  String? gender,  String? avatar,  String? deviceType,  String? deviceToken,  String? deviceId, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiUser() when $default != null:
return $default(_that.id,_that.name,_that.nickname,_that.phone,_that.email,_that.country,_that.governorate,_that.birthdate,_that.gender,_that.avatar,_that.deviceType,_that.deviceToken,_that.deviceId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? nickname,  String phone,  String? email,  String? country,  String? governorate,  String? birthdate,  String? gender,  String? avatar,  String? deviceType,  String? deviceToken,  String? deviceId, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ApiUser():
return $default(_that.id,_that.name,_that.nickname,_that.phone,_that.email,_that.country,_that.governorate,_that.birthdate,_that.gender,_that.avatar,_that.deviceType,_that.deviceToken,_that.deviceId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? nickname,  String phone,  String? email,  String? country,  String? governorate,  String? birthdate,  String? gender,  String? avatar,  String? deviceType,  String? deviceToken,  String? deviceId, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ApiUser() when $default != null:
return $default(_that.id,_that.name,_that.nickname,_that.phone,_that.email,_that.country,_that.governorate,_that.birthdate,_that.gender,_that.avatar,_that.deviceType,_that.deviceToken,_that.deviceId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiUser extends ApiUser {
  const _ApiUser({required this.id, required this.name, this.nickname, required this.phone, this.email, this.country, this.governorate, this.birthdate, this.gender, this.avatar, this.deviceType, this.deviceToken, this.deviceId, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): super._();
  factory _ApiUser.fromJson(Map<String, dynamic> json) => _$ApiUserFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? nickname;
@override final  String phone;
@override final  String? email;
@override final  String? country;
@override final  String? governorate;
@override final  String? birthdate;
@override final  String? gender;
@override final  String? avatar;
@override final  String? deviceType;
@override final  String? deviceToken;
@override final  String? deviceId;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of ApiUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiUserCopyWith<_ApiUser> get copyWith => __$ApiUserCopyWithImpl<_ApiUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.country, country) || other.country == country)&&(identical(other.governorate, governorate) || other.governorate == governorate)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.deviceToken, deviceToken) || other.deviceToken == deviceToken)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nickname,phone,email,country,governorate,birthdate,gender,avatar,deviceType,deviceToken,deviceId,createdAt,updatedAt);

@override
String toString() {
  return 'ApiUser(id: $id, name: $name, nickname: $nickname, phone: $phone, email: $email, country: $country, governorate: $governorate, birthdate: $birthdate, gender: $gender, avatar: $avatar, deviceType: $deviceType, deviceToken: $deviceToken, deviceId: $deviceId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ApiUserCopyWith<$Res> implements $ApiUserCopyWith<$Res> {
  factory _$ApiUserCopyWith(_ApiUser value, $Res Function(_ApiUser) _then) = __$ApiUserCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? nickname, String phone, String? email, String? country, String? governorate, String? birthdate, String? gender, String? avatar, String? deviceType, String? deviceToken, String? deviceId,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$ApiUserCopyWithImpl<$Res>
    implements _$ApiUserCopyWith<$Res> {
  __$ApiUserCopyWithImpl(this._self, this._then);

  final _ApiUser _self;
  final $Res Function(_ApiUser) _then;

/// Create a copy of ApiUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nickname = freezed,Object? phone = null,Object? email = freezed,Object? country = freezed,Object? governorate = freezed,Object? birthdate = freezed,Object? gender = freezed,Object? avatar = freezed,Object? deviceType = freezed,Object? deviceToken = freezed,Object? deviceId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ApiUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,governorate: freezed == governorate ? _self.governorate : governorate // ignore: cast_nullable_to_non_nullable
as String?,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,deviceType: freezed == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as String?,deviceToken: freezed == deviceToken ? _self.deviceToken : deviceToken // ignore: cast_nullable_to_non_nullable
as String?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
