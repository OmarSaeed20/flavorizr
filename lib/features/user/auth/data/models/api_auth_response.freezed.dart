// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_auth_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApiTokenData {

 String get token; int get expiration;
/// Create a copy of ApiTokenData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiTokenDataCopyWith<ApiTokenData> get copyWith => _$ApiTokenDataCopyWithImpl<ApiTokenData>(this as ApiTokenData, _$identity);

  /// Serializes this ApiTokenData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiTokenData&&(identical(other.token, token) || other.token == token)&&(identical(other.expiration, expiration) || other.expiration == expiration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,expiration);

@override
String toString() {
  return 'ApiTokenData(token: $token, expiration: $expiration)';
}


}

/// @nodoc
abstract mixin class $ApiTokenDataCopyWith<$Res>  {
  factory $ApiTokenDataCopyWith(ApiTokenData value, $Res Function(ApiTokenData) _then) = _$ApiTokenDataCopyWithImpl;
@useResult
$Res call({
 String token, int expiration
});




}
/// @nodoc
class _$ApiTokenDataCopyWithImpl<$Res>
    implements $ApiTokenDataCopyWith<$Res> {
  _$ApiTokenDataCopyWithImpl(this._self, this._then);

  final ApiTokenData _self;
  final $Res Function(ApiTokenData) _then;

/// Create a copy of ApiTokenData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? expiration = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,expiration: null == expiration ? _self.expiration : expiration // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiTokenData].
extension ApiTokenDataPatterns on ApiTokenData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiTokenData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiTokenData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiTokenData value)  $default,){
final _that = this;
switch (_that) {
case _ApiTokenData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiTokenData value)?  $default,){
final _that = this;
switch (_that) {
case _ApiTokenData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  int expiration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiTokenData() when $default != null:
return $default(_that.token,_that.expiration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  int expiration)  $default,) {final _that = this;
switch (_that) {
case _ApiTokenData():
return $default(_that.token,_that.expiration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  int expiration)?  $default,) {final _that = this;
switch (_that) {
case _ApiTokenData() when $default != null:
return $default(_that.token,_that.expiration);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiTokenData implements ApiTokenData {
  const _ApiTokenData({required this.token, required this.expiration});
  factory _ApiTokenData.fromJson(Map<String, dynamic> json) => _$ApiTokenDataFromJson(json);

@override final  String token;
@override final  int expiration;

/// Create a copy of ApiTokenData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiTokenDataCopyWith<_ApiTokenData> get copyWith => __$ApiTokenDataCopyWithImpl<_ApiTokenData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiTokenDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiTokenData&&(identical(other.token, token) || other.token == token)&&(identical(other.expiration, expiration) || other.expiration == expiration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,expiration);

@override
String toString() {
  return 'ApiTokenData(token: $token, expiration: $expiration)';
}


}

/// @nodoc
abstract mixin class _$ApiTokenDataCopyWith<$Res> implements $ApiTokenDataCopyWith<$Res> {
  factory _$ApiTokenDataCopyWith(_ApiTokenData value, $Res Function(_ApiTokenData) _then) = __$ApiTokenDataCopyWithImpl;
@override @useResult
$Res call({
 String token, int expiration
});




}
/// @nodoc
class __$ApiTokenDataCopyWithImpl<$Res>
    implements _$ApiTokenDataCopyWith<$Res> {
  __$ApiTokenDataCopyWithImpl(this._self, this._then);

  final _ApiTokenData _self;
  final $Res Function(_ApiTokenData) _then;

/// Create a copy of ApiTokenData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? expiration = null,}) {
  return _then(_ApiTokenData(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,expiration: null == expiration ? _self.expiration : expiration // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ApiToken {

 ApiTokenData get access; ApiTokenData get refresh;
/// Create a copy of ApiToken
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiTokenCopyWith<ApiToken> get copyWith => _$ApiTokenCopyWithImpl<ApiToken>(this as ApiToken, _$identity);

  /// Serializes this ApiToken to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiToken&&(identical(other.access, access) || other.access == access)&&(identical(other.refresh, refresh) || other.refresh == refresh));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,access,refresh);

@override
String toString() {
  return 'ApiToken(access: $access, refresh: $refresh)';
}


}

/// @nodoc
abstract mixin class $ApiTokenCopyWith<$Res>  {
  factory $ApiTokenCopyWith(ApiToken value, $Res Function(ApiToken) _then) = _$ApiTokenCopyWithImpl;
@useResult
$Res call({
 ApiTokenData access, ApiTokenData refresh
});


$ApiTokenDataCopyWith<$Res> get access;$ApiTokenDataCopyWith<$Res> get refresh;

}
/// @nodoc
class _$ApiTokenCopyWithImpl<$Res>
    implements $ApiTokenCopyWith<$Res> {
  _$ApiTokenCopyWithImpl(this._self, this._then);

  final ApiToken _self;
  final $Res Function(ApiToken) _then;

/// Create a copy of ApiToken
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? access = null,Object? refresh = null,}) {
  return _then(_self.copyWith(
access: null == access ? _self.access : access // ignore: cast_nullable_to_non_nullable
as ApiTokenData,refresh: null == refresh ? _self.refresh : refresh // ignore: cast_nullable_to_non_nullable
as ApiTokenData,
  ));
}
/// Create a copy of ApiToken
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiTokenDataCopyWith<$Res> get access {
  
  return $ApiTokenDataCopyWith<$Res>(_self.access, (value) {
    return _then(_self.copyWith(access: value));
  });
}/// Create a copy of ApiToken
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiTokenDataCopyWith<$Res> get refresh {
  
  return $ApiTokenDataCopyWith<$Res>(_self.refresh, (value) {
    return _then(_self.copyWith(refresh: value));
  });
}
}


/// Adds pattern-matching-related methods to [ApiToken].
extension ApiTokenPatterns on ApiToken {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiToken value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiToken() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiToken value)  $default,){
final _that = this;
switch (_that) {
case _ApiToken():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiToken value)?  $default,){
final _that = this;
switch (_that) {
case _ApiToken() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ApiTokenData access,  ApiTokenData refresh)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiToken() when $default != null:
return $default(_that.access,_that.refresh);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ApiTokenData access,  ApiTokenData refresh)  $default,) {final _that = this;
switch (_that) {
case _ApiToken():
return $default(_that.access,_that.refresh);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ApiTokenData access,  ApiTokenData refresh)?  $default,) {final _that = this;
switch (_that) {
case _ApiToken() when $default != null:
return $default(_that.access,_that.refresh);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiToken implements ApiToken {
  const _ApiToken({required this.access, required this.refresh});
  factory _ApiToken.fromJson(Map<String, dynamic> json) => _$ApiTokenFromJson(json);

@override final  ApiTokenData access;
@override final  ApiTokenData refresh;

/// Create a copy of ApiToken
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiTokenCopyWith<_ApiToken> get copyWith => __$ApiTokenCopyWithImpl<_ApiToken>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiTokenToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiToken&&(identical(other.access, access) || other.access == access)&&(identical(other.refresh, refresh) || other.refresh == refresh));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,access,refresh);

@override
String toString() {
  return 'ApiToken(access: $access, refresh: $refresh)';
}


}

/// @nodoc
abstract mixin class _$ApiTokenCopyWith<$Res> implements $ApiTokenCopyWith<$Res> {
  factory _$ApiTokenCopyWith(_ApiToken value, $Res Function(_ApiToken) _then) = __$ApiTokenCopyWithImpl;
@override @useResult
$Res call({
 ApiTokenData access, ApiTokenData refresh
});


@override $ApiTokenDataCopyWith<$Res> get access;@override $ApiTokenDataCopyWith<$Res> get refresh;

}
/// @nodoc
class __$ApiTokenCopyWithImpl<$Res>
    implements _$ApiTokenCopyWith<$Res> {
  __$ApiTokenCopyWithImpl(this._self, this._then);

  final _ApiToken _self;
  final $Res Function(_ApiToken) _then;

/// Create a copy of ApiToken
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? access = null,Object? refresh = null,}) {
  return _then(_ApiToken(
access: null == access ? _self.access : access // ignore: cast_nullable_to_non_nullable
as ApiTokenData,refresh: null == refresh ? _self.refresh : refresh // ignore: cast_nullable_to_non_nullable
as ApiTokenData,
  ));
}

/// Create a copy of ApiToken
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiTokenDataCopyWith<$Res> get access {
  
  return $ApiTokenDataCopyWith<$Res>(_self.access, (value) {
    return _then(_self.copyWith(access: value));
  });
}/// Create a copy of ApiToken
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiTokenDataCopyWith<$Res> get refresh {
  
  return $ApiTokenDataCopyWith<$Res>(_self.refresh, (value) {
    return _then(_self.copyWith(refresh: value));
  });
}
}


/// @nodoc
mixin _$ApiAuthData {

 ApiUser get user; ApiToken get token;
/// Create a copy of ApiAuthData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiAuthDataCopyWith<ApiAuthData> get copyWith => _$ApiAuthDataCopyWithImpl<ApiAuthData>(this as ApiAuthData, _$identity);

  /// Serializes this ApiAuthData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiAuthData&&(identical(other.user, user) || other.user == user)&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,token);

@override
String toString() {
  return 'ApiAuthData(user: $user, token: $token)';
}


}

/// @nodoc
abstract mixin class $ApiAuthDataCopyWith<$Res>  {
  factory $ApiAuthDataCopyWith(ApiAuthData value, $Res Function(ApiAuthData) _then) = _$ApiAuthDataCopyWithImpl;
@useResult
$Res call({
 ApiUser user, ApiToken token
});


$ApiUserCopyWith<$Res> get user;$ApiTokenCopyWith<$Res> get token;

}
/// @nodoc
class _$ApiAuthDataCopyWithImpl<$Res>
    implements $ApiAuthDataCopyWith<$Res> {
  _$ApiAuthDataCopyWithImpl(this._self, this._then);

  final ApiAuthData _self;
  final $Res Function(ApiAuthData) _then;

/// Create a copy of ApiAuthData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? token = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ApiUser,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as ApiToken,
  ));
}
/// Create a copy of ApiAuthData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiUserCopyWith<$Res> get user {
  
  return $ApiUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of ApiAuthData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiTokenCopyWith<$Res> get token {
  
  return $ApiTokenCopyWith<$Res>(_self.token, (value) {
    return _then(_self.copyWith(token: value));
  });
}
}


/// Adds pattern-matching-related methods to [ApiAuthData].
extension ApiAuthDataPatterns on ApiAuthData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiAuthData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiAuthData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiAuthData value)  $default,){
final _that = this;
switch (_that) {
case _ApiAuthData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiAuthData value)?  $default,){
final _that = this;
switch (_that) {
case _ApiAuthData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ApiUser user,  ApiToken token)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiAuthData() when $default != null:
return $default(_that.user,_that.token);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ApiUser user,  ApiToken token)  $default,) {final _that = this;
switch (_that) {
case _ApiAuthData():
return $default(_that.user,_that.token);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ApiUser user,  ApiToken token)?  $default,) {final _that = this;
switch (_that) {
case _ApiAuthData() when $default != null:
return $default(_that.user,_that.token);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiAuthData implements ApiAuthData {
  const _ApiAuthData({required this.user, required this.token});
  factory _ApiAuthData.fromJson(Map<String, dynamic> json) => _$ApiAuthDataFromJson(json);

@override final  ApiUser user;
@override final  ApiToken token;

/// Create a copy of ApiAuthData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiAuthDataCopyWith<_ApiAuthData> get copyWith => __$ApiAuthDataCopyWithImpl<_ApiAuthData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiAuthDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiAuthData&&(identical(other.user, user) || other.user == user)&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,token);

@override
String toString() {
  return 'ApiAuthData(user: $user, token: $token)';
}


}

/// @nodoc
abstract mixin class _$ApiAuthDataCopyWith<$Res> implements $ApiAuthDataCopyWith<$Res> {
  factory _$ApiAuthDataCopyWith(_ApiAuthData value, $Res Function(_ApiAuthData) _then) = __$ApiAuthDataCopyWithImpl;
@override @useResult
$Res call({
 ApiUser user, ApiToken token
});


@override $ApiUserCopyWith<$Res> get user;@override $ApiTokenCopyWith<$Res> get token;

}
/// @nodoc
class __$ApiAuthDataCopyWithImpl<$Res>
    implements _$ApiAuthDataCopyWith<$Res> {
  __$ApiAuthDataCopyWithImpl(this._self, this._then);

  final _ApiAuthData _self;
  final $Res Function(_ApiAuthData) _then;

/// Create a copy of ApiAuthData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? token = null,}) {
  return _then(_ApiAuthData(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ApiUser,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as ApiToken,
  ));
}

/// Create a copy of ApiAuthData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiUserCopyWith<$Res> get user {
  
  return $ApiUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of ApiAuthData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiTokenCopyWith<$Res> get token {
  
  return $ApiTokenCopyWith<$Res>(_self.token, (value) {
    return _then(_self.copyWith(token: value));
  });
}
}


/// @nodoc
mixin _$ApiAuthResponse {

 String get status; String get message; ApiAuthData get data;
/// Create a copy of ApiAuthResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiAuthResponseCopyWith<ApiAuthResponse> get copyWith => _$ApiAuthResponseCopyWithImpl<ApiAuthResponse>(this as ApiAuthResponse, _$identity);

  /// Serializes this ApiAuthResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiAuthResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'ApiAuthResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $ApiAuthResponseCopyWith<$Res>  {
  factory $ApiAuthResponseCopyWith(ApiAuthResponse value, $Res Function(ApiAuthResponse) _then) = _$ApiAuthResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, ApiAuthData data
});


$ApiAuthDataCopyWith<$Res> get data;

}
/// @nodoc
class _$ApiAuthResponseCopyWithImpl<$Res>
    implements $ApiAuthResponseCopyWith<$Res> {
  _$ApiAuthResponseCopyWithImpl(this._self, this._then);

  final ApiAuthResponse _self;
  final $Res Function(ApiAuthResponse) _then;

/// Create a copy of ApiAuthResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ApiAuthData,
  ));
}
/// Create a copy of ApiAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiAuthDataCopyWith<$Res> get data {
  
  return $ApiAuthDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ApiAuthResponse].
extension ApiAuthResponsePatterns on ApiAuthResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiAuthResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiAuthResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiAuthResponse value)  $default,){
final _that = this;
switch (_that) {
case _ApiAuthResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiAuthResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ApiAuthResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  String message,  ApiAuthData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiAuthResponse() when $default != null:
return $default(_that.status,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  String message,  ApiAuthData data)  $default,) {final _that = this;
switch (_that) {
case _ApiAuthResponse():
return $default(_that.status,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  String message,  ApiAuthData data)?  $default,) {final _that = this;
switch (_that) {
case _ApiAuthResponse() when $default != null:
return $default(_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiAuthResponse extends ApiAuthResponse {
  const _ApiAuthResponse({required this.status, required this.message, required this.data}): super._();
  factory _ApiAuthResponse.fromJson(Map<String, dynamic> json) => _$ApiAuthResponseFromJson(json);

@override final  String status;
@override final  String message;
@override final  ApiAuthData data;

/// Create a copy of ApiAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiAuthResponseCopyWith<_ApiAuthResponse> get copyWith => __$ApiAuthResponseCopyWithImpl<_ApiAuthResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiAuthResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiAuthResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'ApiAuthResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ApiAuthResponseCopyWith<$Res> implements $ApiAuthResponseCopyWith<$Res> {
  factory _$ApiAuthResponseCopyWith(_ApiAuthResponse value, $Res Function(_ApiAuthResponse) _then) = __$ApiAuthResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, ApiAuthData data
});


@override $ApiAuthDataCopyWith<$Res> get data;

}
/// @nodoc
class __$ApiAuthResponseCopyWithImpl<$Res>
    implements _$ApiAuthResponseCopyWith<$Res> {
  __$ApiAuthResponseCopyWithImpl(this._self, this._then);

  final _ApiAuthResponse _self;
  final $Res Function(_ApiAuthResponse) _then;

/// Create a copy of ApiAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_ApiAuthResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ApiAuthData,
  ));
}

/// Create a copy of ApiAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiAuthDataCopyWith<$Res> get data {
  
  return $ApiAuthDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
