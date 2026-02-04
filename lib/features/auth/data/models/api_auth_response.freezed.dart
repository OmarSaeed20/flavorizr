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
mixin _$ApiAuthResponse {

 bool get success; String get message; ApiUser? get user; String? get token; String? get refreshToken;@JsonKey(name: 'token_type') String? get tokenType;@JsonKey(name: 'expires_in') int? get expiresIn;@JsonKey(name: 'access_token') String? get accessToken;
/// Create a copy of ApiAuthResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiAuthResponseCopyWith<ApiAuthResponse> get copyWith => _$ApiAuthResponseCopyWithImpl<ApiAuthResponse>(this as ApiAuthResponse, _$identity);

  /// Serializes this ApiAuthResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiAuthResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.user, user) || other.user == user)&&(identical(other.token, token) || other.token == token)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.tokenType, tokenType) || other.tokenType == tokenType)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,user,token,refreshToken,tokenType,expiresIn,accessToken);

@override
String toString() {
  return 'ApiAuthResponse(success: $success, message: $message, user: $user, token: $token, refreshToken: $refreshToken, tokenType: $tokenType, expiresIn: $expiresIn, accessToken: $accessToken)';
}


}

/// @nodoc
abstract mixin class $ApiAuthResponseCopyWith<$Res>  {
  factory $ApiAuthResponseCopyWith(ApiAuthResponse value, $Res Function(ApiAuthResponse) _then) = _$ApiAuthResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String message, ApiUser? user, String? token, String? refreshToken,@JsonKey(name: 'token_type') String? tokenType,@JsonKey(name: 'expires_in') int? expiresIn,@JsonKey(name: 'access_token') String? accessToken
});


$ApiUserCopyWith<$Res>? get user;

}
/// @nodoc
class _$ApiAuthResponseCopyWithImpl<$Res>
    implements $ApiAuthResponseCopyWith<$Res> {
  _$ApiAuthResponseCopyWithImpl(this._self, this._then);

  final ApiAuthResponse _self;
  final $Res Function(ApiAuthResponse) _then;

/// Create a copy of ApiAuthResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? user = freezed,Object? token = freezed,Object? refreshToken = freezed,Object? tokenType = freezed,Object? expiresIn = freezed,Object? accessToken = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ApiUser?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,tokenType: freezed == tokenType ? _self.tokenType : tokenType // ignore: cast_nullable_to_non_nullable
as String?,expiresIn: freezed == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int?,accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ApiAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiUserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $ApiUserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  ApiUser? user,  String? token,  String? refreshToken, @JsonKey(name: 'token_type')  String? tokenType, @JsonKey(name: 'expires_in')  int? expiresIn, @JsonKey(name: 'access_token')  String? accessToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiAuthResponse() when $default != null:
return $default(_that.success,_that.message,_that.user,_that.token,_that.refreshToken,_that.tokenType,_that.expiresIn,_that.accessToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  ApiUser? user,  String? token,  String? refreshToken, @JsonKey(name: 'token_type')  String? tokenType, @JsonKey(name: 'expires_in')  int? expiresIn, @JsonKey(name: 'access_token')  String? accessToken)  $default,) {final _that = this;
switch (_that) {
case _ApiAuthResponse():
return $default(_that.success,_that.message,_that.user,_that.token,_that.refreshToken,_that.tokenType,_that.expiresIn,_that.accessToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  ApiUser? user,  String? token,  String? refreshToken, @JsonKey(name: 'token_type')  String? tokenType, @JsonKey(name: 'expires_in')  int? expiresIn, @JsonKey(name: 'access_token')  String? accessToken)?  $default,) {final _that = this;
switch (_that) {
case _ApiAuthResponse() when $default != null:
return $default(_that.success,_that.message,_that.user,_that.token,_that.refreshToken,_that.tokenType,_that.expiresIn,_that.accessToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiAuthResponse extends ApiAuthResponse {
  const _ApiAuthResponse({required this.success, required this.message, this.user, this.token, this.refreshToken, @JsonKey(name: 'token_type') this.tokenType, @JsonKey(name: 'expires_in') this.expiresIn, @JsonKey(name: 'access_token') this.accessToken}): super._();
  factory _ApiAuthResponse.fromJson(Map<String, dynamic> json) => _$ApiAuthResponseFromJson(json);

@override final  bool success;
@override final  String message;
@override final  ApiUser? user;
@override final  String? token;
@override final  String? refreshToken;
@override@JsonKey(name: 'token_type') final  String? tokenType;
@override@JsonKey(name: 'expires_in') final  int? expiresIn;
@override@JsonKey(name: 'access_token') final  String? accessToken;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiAuthResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.user, user) || other.user == user)&&(identical(other.token, token) || other.token == token)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.tokenType, tokenType) || other.tokenType == tokenType)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,user,token,refreshToken,tokenType,expiresIn,accessToken);

@override
String toString() {
  return 'ApiAuthResponse(success: $success, message: $message, user: $user, token: $token, refreshToken: $refreshToken, tokenType: $tokenType, expiresIn: $expiresIn, accessToken: $accessToken)';
}


}

/// @nodoc
abstract mixin class _$ApiAuthResponseCopyWith<$Res> implements $ApiAuthResponseCopyWith<$Res> {
  factory _$ApiAuthResponseCopyWith(_ApiAuthResponse value, $Res Function(_ApiAuthResponse) _then) = __$ApiAuthResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, ApiUser? user, String? token, String? refreshToken,@JsonKey(name: 'token_type') String? tokenType,@JsonKey(name: 'expires_in') int? expiresIn,@JsonKey(name: 'access_token') String? accessToken
});


@override $ApiUserCopyWith<$Res>? get user;

}
/// @nodoc
class __$ApiAuthResponseCopyWithImpl<$Res>
    implements _$ApiAuthResponseCopyWith<$Res> {
  __$ApiAuthResponseCopyWithImpl(this._self, this._then);

  final _ApiAuthResponse _self;
  final $Res Function(_ApiAuthResponse) _then;

/// Create a copy of ApiAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? user = freezed,Object? token = freezed,Object? refreshToken = freezed,Object? tokenType = freezed,Object? expiresIn = freezed,Object? accessToken = freezed,}) {
  return _then(_ApiAuthResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ApiUser?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,tokenType: freezed == tokenType ? _self.tokenType : tokenType // ignore: cast_nullable_to_non_nullable
as String?,expiresIn: freezed == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int?,accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ApiAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiUserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $ApiUserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
