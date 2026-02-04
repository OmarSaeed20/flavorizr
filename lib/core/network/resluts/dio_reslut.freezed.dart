// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dio_reslut.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiResult<T> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiResult<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ApiResult<$T>()';
}


}

/// @nodoc
class $ApiResultCopyWith<T,$Res>  {
$ApiResultCopyWith(ApiResult<T> _, $Res Function(ApiResult<T>) __);
}


/// Adds pattern-matching-related methods to [ApiResult].
extension ApiResultPatterns<T> on ApiResult<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ApiResultSuccess<T> value)?  success,TResult Function( ApiResultError<T> value)?  exception,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ApiResultSuccess() when success != null:
return success(_that);case ApiResultError() when exception != null:
return exception(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ApiResultSuccess<T> value)  success,required TResult Function( ApiResultError<T> value)  exception,}){
final _that = this;
switch (_that) {
case ApiResultSuccess():
return success(_that);case ApiResultError():
return exception(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ApiResultSuccess<T> value)?  success,TResult? Function( ApiResultError<T> value)?  exception,}){
final _that = this;
switch (_that) {
case ApiResultSuccess() when success != null:
return success(_that);case ApiResultError() when exception != null:
return exception(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( T data,  NetworkException? info)?  success,TResult Function( NetworkException exception)?  exception,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ApiResultSuccess() when success != null:
return success(_that.data,_that.info);case ApiResultError() when exception != null:
return exception(_that.exception);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( T data,  NetworkException? info)  success,required TResult Function( NetworkException exception)  exception,}) {final _that = this;
switch (_that) {
case ApiResultSuccess():
return success(_that.data,_that.info);case ApiResultError():
return exception(_that.exception);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( T data,  NetworkException? info)?  success,TResult? Function( NetworkException exception)?  exception,}) {final _that = this;
switch (_that) {
case ApiResultSuccess() when success != null:
return success(_that.data,_that.info);case ApiResultError() when exception != null:
return exception(_that.exception);case _:
  return null;

}
}

}

/// @nodoc


class ApiResultSuccess<T> extends ApiResult<T> {
  const ApiResultSuccess(this.data, [this.info]): super._();
  

 final  T data;
 final  NetworkException? info;

/// Create a copy of ApiResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiResultSuccessCopyWith<T, ApiResultSuccess<T>> get copyWith => _$ApiResultSuccessCopyWithImpl<T, ApiResultSuccess<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiResultSuccess<T>&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.info, info) || other.info == info));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),info);

@override
String toString() {
  return 'ApiResult<$T>.success(data: $data, info: $info)';
}


}

/// @nodoc
abstract mixin class $ApiResultSuccessCopyWith<T,$Res> implements $ApiResultCopyWith<T, $Res> {
  factory $ApiResultSuccessCopyWith(ApiResultSuccess<T> value, $Res Function(ApiResultSuccess<T>) _then) = _$ApiResultSuccessCopyWithImpl;
@useResult
$Res call({
 T data, NetworkException? info
});




}
/// @nodoc
class _$ApiResultSuccessCopyWithImpl<T,$Res>
    implements $ApiResultSuccessCopyWith<T, $Res> {
  _$ApiResultSuccessCopyWithImpl(this._self, this._then);

  final ApiResultSuccess<T> _self;
  final $Res Function(ApiResultSuccess<T>) _then;

/// Create a copy of ApiResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,Object? info = freezed,}) {
  return _then(ApiResultSuccess<T>(
freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as NetworkException?,
  ));
}


}

/// @nodoc


class ApiResultError<T> extends ApiResult<T> {
  const ApiResultError(this.exception): super._();
  

 final  NetworkException exception;

/// Create a copy of ApiResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiResultErrorCopyWith<T, ApiResultError<T>> get copyWith => _$ApiResultErrorCopyWithImpl<T, ApiResultError<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiResultError<T>&&(identical(other.exception, exception) || other.exception == exception));
}


@override
int get hashCode => Object.hash(runtimeType,exception);

@override
String toString() {
  return 'ApiResult<$T>.exception(exception: $exception)';
}


}

/// @nodoc
abstract mixin class $ApiResultErrorCopyWith<T,$Res> implements $ApiResultCopyWith<T, $Res> {
  factory $ApiResultErrorCopyWith(ApiResultError<T> value, $Res Function(ApiResultError<T>) _then) = _$ApiResultErrorCopyWithImpl;
@useResult
$Res call({
 NetworkException exception
});




}
/// @nodoc
class _$ApiResultErrorCopyWithImpl<T,$Res>
    implements $ApiResultErrorCopyWith<T, $Res> {
  _$ApiResultErrorCopyWithImpl(this._self, this._then);

  final ApiResultError<T> _self;
  final $Res Function(ApiResultError<T>) _then;

/// Create a copy of ApiResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? exception = null,}) {
  return _then(ApiResultError<T>(
null == exception ? _self.exception : exception // ignore: cast_nullable_to_non_nullable
as NetworkException,
  ));
}


}

// dart format on
