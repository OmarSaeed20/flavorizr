// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Failure {

 String get message;
/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FailureCopyWith<Failure> get copyWith => _$FailureCopyWithImpl<Failure>(this as Failure, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Failure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $FailureCopyWith<$Res>  {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) _then) = _$FailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$FailureCopyWithImpl<$Res>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._self, this._then);

  final Failure _self;
  final $Res Function(Failure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Failure].
extension FailurePatterns on Failure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ServerFailure value)?  server,TResult Function( NetworkFailure value)?  network,TResult Function( ValidationFailure value)?  validation,TResult Function( AuthFailure value)?  auth,TResult Function( UnauthorizedFailure value)?  unauthorized,TResult Function( NotFoundFailure value)?  notFound,TResult Function( UnknownFailure value)?  unknown,TResult Function( CacheFailure value)?  cache,TResult Function( TimeoutFailure value)?  timeout,TResult Function( PermissionFailure value)?  permission,TResult Function( ConflictFailure value)?  conflict,TResult Function( TooManyRequestsFailure value)?  tooManyRequests,TResult Function( MaintenanceFailure value)?  maintenance,TResult Function( PaymentFailure value)?  payment,TResult Function( LocationFailure value)?  location,TResult Function( FileUploadFailure value)?  fileUpload,TResult Function( VerificationFailure value)?  verification,TResult Function( RateLimitFailure value)?  rateLimit,TResult Function( ServiceUnavailableFailure value)?  serviceUnavailable,TResult Function( BadRequestFailure value)?  badRequest,TResult Function( CustomFailure value)?  custom,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ServerFailure() when server != null:
return server(_that);case NetworkFailure() when network != null:
return network(_that);case ValidationFailure() when validation != null:
return validation(_that);case AuthFailure() when auth != null:
return auth(_that);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that);case NotFoundFailure() when notFound != null:
return notFound(_that);case UnknownFailure() when unknown != null:
return unknown(_that);case CacheFailure() when cache != null:
return cache(_that);case TimeoutFailure() when timeout != null:
return timeout(_that);case PermissionFailure() when permission != null:
return permission(_that);case ConflictFailure() when conflict != null:
return conflict(_that);case TooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests(_that);case MaintenanceFailure() when maintenance != null:
return maintenance(_that);case PaymentFailure() when payment != null:
return payment(_that);case LocationFailure() when location != null:
return location(_that);case FileUploadFailure() when fileUpload != null:
return fileUpload(_that);case VerificationFailure() when verification != null:
return verification(_that);case RateLimitFailure() when rateLimit != null:
return rateLimit(_that);case ServiceUnavailableFailure() when serviceUnavailable != null:
return serviceUnavailable(_that);case BadRequestFailure() when badRequest != null:
return badRequest(_that);case CustomFailure() when custom != null:
return custom(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ServerFailure value)  server,required TResult Function( NetworkFailure value)  network,required TResult Function( ValidationFailure value)  validation,required TResult Function( AuthFailure value)  auth,required TResult Function( UnauthorizedFailure value)  unauthorized,required TResult Function( NotFoundFailure value)  notFound,required TResult Function( UnknownFailure value)  unknown,required TResult Function( CacheFailure value)  cache,required TResult Function( TimeoutFailure value)  timeout,required TResult Function( PermissionFailure value)  permission,required TResult Function( ConflictFailure value)  conflict,required TResult Function( TooManyRequestsFailure value)  tooManyRequests,required TResult Function( MaintenanceFailure value)  maintenance,required TResult Function( PaymentFailure value)  payment,required TResult Function( LocationFailure value)  location,required TResult Function( FileUploadFailure value)  fileUpload,required TResult Function( VerificationFailure value)  verification,required TResult Function( RateLimitFailure value)  rateLimit,required TResult Function( ServiceUnavailableFailure value)  serviceUnavailable,required TResult Function( BadRequestFailure value)  badRequest,required TResult Function( CustomFailure value)  custom,}){
final _that = this;
switch (_that) {
case ServerFailure():
return server(_that);case NetworkFailure():
return network(_that);case ValidationFailure():
return validation(_that);case AuthFailure():
return auth(_that);case UnauthorizedFailure():
return unauthorized(_that);case NotFoundFailure():
return notFound(_that);case UnknownFailure():
return unknown(_that);case CacheFailure():
return cache(_that);case TimeoutFailure():
return timeout(_that);case PermissionFailure():
return permission(_that);case ConflictFailure():
return conflict(_that);case TooManyRequestsFailure():
return tooManyRequests(_that);case MaintenanceFailure():
return maintenance(_that);case PaymentFailure():
return payment(_that);case LocationFailure():
return location(_that);case FileUploadFailure():
return fileUpload(_that);case VerificationFailure():
return verification(_that);case RateLimitFailure():
return rateLimit(_that);case ServiceUnavailableFailure():
return serviceUnavailable(_that);case BadRequestFailure():
return badRequest(_that);case CustomFailure():
return custom(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ServerFailure value)?  server,TResult? Function( NetworkFailure value)?  network,TResult? Function( ValidationFailure value)?  validation,TResult? Function( AuthFailure value)?  auth,TResult? Function( UnauthorizedFailure value)?  unauthorized,TResult? Function( NotFoundFailure value)?  notFound,TResult? Function( UnknownFailure value)?  unknown,TResult? Function( CacheFailure value)?  cache,TResult? Function( TimeoutFailure value)?  timeout,TResult? Function( PermissionFailure value)?  permission,TResult? Function( ConflictFailure value)?  conflict,TResult? Function( TooManyRequestsFailure value)?  tooManyRequests,TResult? Function( MaintenanceFailure value)?  maintenance,TResult? Function( PaymentFailure value)?  payment,TResult? Function( LocationFailure value)?  location,TResult? Function( FileUploadFailure value)?  fileUpload,TResult? Function( VerificationFailure value)?  verification,TResult? Function( RateLimitFailure value)?  rateLimit,TResult? Function( ServiceUnavailableFailure value)?  serviceUnavailable,TResult? Function( BadRequestFailure value)?  badRequest,TResult? Function( CustomFailure value)?  custom,}){
final _that = this;
switch (_that) {
case ServerFailure() when server != null:
return server(_that);case NetworkFailure() when network != null:
return network(_that);case ValidationFailure() when validation != null:
return validation(_that);case AuthFailure() when auth != null:
return auth(_that);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that);case NotFoundFailure() when notFound != null:
return notFound(_that);case UnknownFailure() when unknown != null:
return unknown(_that);case CacheFailure() when cache != null:
return cache(_that);case TimeoutFailure() when timeout != null:
return timeout(_that);case PermissionFailure() when permission != null:
return permission(_that);case ConflictFailure() when conflict != null:
return conflict(_that);case TooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests(_that);case MaintenanceFailure() when maintenance != null:
return maintenance(_that);case PaymentFailure() when payment != null:
return payment(_that);case LocationFailure() when location != null:
return location(_that);case FileUploadFailure() when fileUpload != null:
return fileUpload(_that);case VerificationFailure() when verification != null:
return verification(_that);case RateLimitFailure() when rateLimit != null:
return rateLimit(_that);case ServiceUnavailableFailure() when serviceUnavailable != null:
return serviceUnavailable(_that);case BadRequestFailure() when badRequest != null:
return badRequest(_that);case CustomFailure() when custom != null:
return custom(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message,  int? statusCode)?  server,TResult Function( String message)?  network,TResult Function( String message,  Map<String, String>? fieldErrors)?  validation,TResult Function( String message)?  auth,TResult Function( String message)?  unauthorized,TResult Function( String message)?  notFound,TResult Function( String message,  Object? error,  StackTrace? stackTrace)?  unknown,TResult Function( String message)?  cache,TResult Function( String message)?  timeout,TResult Function( String message)?  permission,TResult Function( String message)?  conflict,TResult Function( String message)?  tooManyRequests,TResult Function( String message)?  maintenance,TResult Function( String message)?  payment,TResult Function( String message)?  location,TResult Function( String message)?  fileUpload,TResult Function( String message)?  verification,TResult Function( String message,  int? retryAfter)?  rateLimit,TResult Function( String message)?  serviceUnavailable,TResult Function( String message,  Map<String, dynamic>? details)?  badRequest,TResult Function( String code,  String message,  Map<String, dynamic>? data)?  custom,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ServerFailure() when server != null:
return server(_that.message,_that.statusCode);case NetworkFailure() when network != null:
return network(_that.message);case ValidationFailure() when validation != null:
return validation(_that.message,_that.fieldErrors);case AuthFailure() when auth != null:
return auth(_that.message);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that.message);case NotFoundFailure() when notFound != null:
return notFound(_that.message);case UnknownFailure() when unknown != null:
return unknown(_that.message,_that.error,_that.stackTrace);case CacheFailure() when cache != null:
return cache(_that.message);case TimeoutFailure() when timeout != null:
return timeout(_that.message);case PermissionFailure() when permission != null:
return permission(_that.message);case ConflictFailure() when conflict != null:
return conflict(_that.message);case TooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests(_that.message);case MaintenanceFailure() when maintenance != null:
return maintenance(_that.message);case PaymentFailure() when payment != null:
return payment(_that.message);case LocationFailure() when location != null:
return location(_that.message);case FileUploadFailure() when fileUpload != null:
return fileUpload(_that.message);case VerificationFailure() when verification != null:
return verification(_that.message);case RateLimitFailure() when rateLimit != null:
return rateLimit(_that.message,_that.retryAfter);case ServiceUnavailableFailure() when serviceUnavailable != null:
return serviceUnavailable(_that.message);case BadRequestFailure() when badRequest != null:
return badRequest(_that.message,_that.details);case CustomFailure() when custom != null:
return custom(_that.code,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message,  int? statusCode)  server,required TResult Function( String message)  network,required TResult Function( String message,  Map<String, String>? fieldErrors)  validation,required TResult Function( String message)  auth,required TResult Function( String message)  unauthorized,required TResult Function( String message)  notFound,required TResult Function( String message,  Object? error,  StackTrace? stackTrace)  unknown,required TResult Function( String message)  cache,required TResult Function( String message)  timeout,required TResult Function( String message)  permission,required TResult Function( String message)  conflict,required TResult Function( String message)  tooManyRequests,required TResult Function( String message)  maintenance,required TResult Function( String message)  payment,required TResult Function( String message)  location,required TResult Function( String message)  fileUpload,required TResult Function( String message)  verification,required TResult Function( String message,  int? retryAfter)  rateLimit,required TResult Function( String message)  serviceUnavailable,required TResult Function( String message,  Map<String, dynamic>? details)  badRequest,required TResult Function( String code,  String message,  Map<String, dynamic>? data)  custom,}) {final _that = this;
switch (_that) {
case ServerFailure():
return server(_that.message,_that.statusCode);case NetworkFailure():
return network(_that.message);case ValidationFailure():
return validation(_that.message,_that.fieldErrors);case AuthFailure():
return auth(_that.message);case UnauthorizedFailure():
return unauthorized(_that.message);case NotFoundFailure():
return notFound(_that.message);case UnknownFailure():
return unknown(_that.message,_that.error,_that.stackTrace);case CacheFailure():
return cache(_that.message);case TimeoutFailure():
return timeout(_that.message);case PermissionFailure():
return permission(_that.message);case ConflictFailure():
return conflict(_that.message);case TooManyRequestsFailure():
return tooManyRequests(_that.message);case MaintenanceFailure():
return maintenance(_that.message);case PaymentFailure():
return payment(_that.message);case LocationFailure():
return location(_that.message);case FileUploadFailure():
return fileUpload(_that.message);case VerificationFailure():
return verification(_that.message);case RateLimitFailure():
return rateLimit(_that.message,_that.retryAfter);case ServiceUnavailableFailure():
return serviceUnavailable(_that.message);case BadRequestFailure():
return badRequest(_that.message,_that.details);case CustomFailure():
return custom(_that.code,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message,  int? statusCode)?  server,TResult? Function( String message)?  network,TResult? Function( String message,  Map<String, String>? fieldErrors)?  validation,TResult? Function( String message)?  auth,TResult? Function( String message)?  unauthorized,TResult? Function( String message)?  notFound,TResult? Function( String message,  Object? error,  StackTrace? stackTrace)?  unknown,TResult? Function( String message)?  cache,TResult? Function( String message)?  timeout,TResult? Function( String message)?  permission,TResult? Function( String message)?  conflict,TResult? Function( String message)?  tooManyRequests,TResult? Function( String message)?  maintenance,TResult? Function( String message)?  payment,TResult? Function( String message)?  location,TResult? Function( String message)?  fileUpload,TResult? Function( String message)?  verification,TResult? Function( String message,  int? retryAfter)?  rateLimit,TResult? Function( String message)?  serviceUnavailable,TResult? Function( String message,  Map<String, dynamic>? details)?  badRequest,TResult? Function( String code,  String message,  Map<String, dynamic>? data)?  custom,}) {final _that = this;
switch (_that) {
case ServerFailure() when server != null:
return server(_that.message,_that.statusCode);case NetworkFailure() when network != null:
return network(_that.message);case ValidationFailure() when validation != null:
return validation(_that.message,_that.fieldErrors);case AuthFailure() when auth != null:
return auth(_that.message);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that.message);case NotFoundFailure() when notFound != null:
return notFound(_that.message);case UnknownFailure() when unknown != null:
return unknown(_that.message,_that.error,_that.stackTrace);case CacheFailure() when cache != null:
return cache(_that.message);case TimeoutFailure() when timeout != null:
return timeout(_that.message);case PermissionFailure() when permission != null:
return permission(_that.message);case ConflictFailure() when conflict != null:
return conflict(_that.message);case TooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests(_that.message);case MaintenanceFailure() when maintenance != null:
return maintenance(_that.message);case PaymentFailure() when payment != null:
return payment(_that.message);case LocationFailure() when location != null:
return location(_that.message);case FileUploadFailure() when fileUpload != null:
return fileUpload(_that.message);case VerificationFailure() when verification != null:
return verification(_that.message);case RateLimitFailure() when rateLimit != null:
return rateLimit(_that.message,_that.retryAfter);case ServiceUnavailableFailure() when serviceUnavailable != null:
return serviceUnavailable(_that.message);case BadRequestFailure() when badRequest != null:
return badRequest(_that.message,_that.details);case CustomFailure() when custom != null:
return custom(_that.code,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class ServerFailure extends Failure {
  const ServerFailure({required this.message, this.statusCode}): super._();
  

@override final  String message;
 final  int? statusCode;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerFailureCopyWith<ServerFailure> get copyWith => _$ServerFailureCopyWithImpl<ServerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,message,statusCode);

@override
String toString() {
  return 'Failure.server(message: $message, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $ServerFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ServerFailureCopyWith(ServerFailure value, $Res Function(ServerFailure) _then) = _$ServerFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, int? statusCode
});




}
/// @nodoc
class _$ServerFailureCopyWithImpl<$Res>
    implements $ServerFailureCopyWith<$Res> {
  _$ServerFailureCopyWithImpl(this._self, this._then);

  final ServerFailure _self;
  final $Res Function(ServerFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? statusCode = freezed,}) {
  return _then(ServerFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class NetworkFailure extends Failure {
  const NetworkFailure({required this.message}): super._();
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkFailureCopyWith<NetworkFailure> get copyWith => _$NetworkFailureCopyWithImpl<NetworkFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.network(message: $message)';
}


}

/// @nodoc
abstract mixin class $NetworkFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $NetworkFailureCopyWith(NetworkFailure value, $Res Function(NetworkFailure) _then) = _$NetworkFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$NetworkFailureCopyWithImpl<$Res>
    implements $NetworkFailureCopyWith<$Res> {
  _$NetworkFailureCopyWithImpl(this._self, this._then);

  final NetworkFailure _self;
  final $Res Function(NetworkFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(NetworkFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ValidationFailure extends Failure {
  const ValidationFailure({required this.message, final  Map<String, String>? fieldErrors}): _fieldErrors = fieldErrors,super._();
  

@override final  String message;
 final  Map<String, String>? _fieldErrors;
 Map<String, String>? get fieldErrors {
  final value = _fieldErrors;
  if (value == null) return null;
  if (_fieldErrors is EqualUnmodifiableMapView) return _fieldErrors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidationFailureCopyWith<ValidationFailure> get copyWith => _$ValidationFailureCopyWithImpl<ValidationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidationFailure&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._fieldErrors, _fieldErrors));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_fieldErrors));

@override
String toString() {
  return 'Failure.validation(message: $message, fieldErrors: $fieldErrors)';
}


}

/// @nodoc
abstract mixin class $ValidationFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ValidationFailureCopyWith(ValidationFailure value, $Res Function(ValidationFailure) _then) = _$ValidationFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, Map<String, String>? fieldErrors
});




}
/// @nodoc
class _$ValidationFailureCopyWithImpl<$Res>
    implements $ValidationFailureCopyWith<$Res> {
  _$ValidationFailureCopyWithImpl(this._self, this._then);

  final ValidationFailure _self;
  final $Res Function(ValidationFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? fieldErrors = freezed,}) {
  return _then(ValidationFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,fieldErrors: freezed == fieldErrors ? _self._fieldErrors : fieldErrors // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}


}

/// @nodoc


class AuthFailure extends Failure {
  const AuthFailure({required this.message}): super._();
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthFailureCopyWith<AuthFailure> get copyWith => _$AuthFailureCopyWithImpl<AuthFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.auth(message: $message)';
}


}

/// @nodoc
abstract mixin class $AuthFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $AuthFailureCopyWith(AuthFailure value, $Res Function(AuthFailure) _then) = _$AuthFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AuthFailureCopyWithImpl<$Res>
    implements $AuthFailureCopyWith<$Res> {
  _$AuthFailureCopyWithImpl(this._self, this._then);

  final AuthFailure _self;
  final $Res Function(AuthFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AuthFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required this.message}): super._();
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnauthorizedFailureCopyWith<UnauthorizedFailure> get copyWith => _$UnauthorizedFailureCopyWithImpl<UnauthorizedFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnauthorizedFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.unauthorized(message: $message)';
}


}

/// @nodoc
abstract mixin class $UnauthorizedFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $UnauthorizedFailureCopyWith(UnauthorizedFailure value, $Res Function(UnauthorizedFailure) _then) = _$UnauthorizedFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$UnauthorizedFailureCopyWithImpl<$Res>
    implements $UnauthorizedFailureCopyWith<$Res> {
  _$UnauthorizedFailureCopyWithImpl(this._self, this._then);

  final UnauthorizedFailure _self;
  final $Res Function(UnauthorizedFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(UnauthorizedFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class NotFoundFailure extends Failure {
  const NotFoundFailure({required this.message}): super._();
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotFoundFailureCopyWith<NotFoundFailure> get copyWith => _$NotFoundFailureCopyWithImpl<NotFoundFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotFoundFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.notFound(message: $message)';
}


}

/// @nodoc
abstract mixin class $NotFoundFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $NotFoundFailureCopyWith(NotFoundFailure value, $Res Function(NotFoundFailure) _then) = _$NotFoundFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$NotFoundFailureCopyWithImpl<$Res>
    implements $NotFoundFailureCopyWith<$Res> {
  _$NotFoundFailureCopyWithImpl(this._self, this._then);

  final NotFoundFailure _self;
  final $Res Function(NotFoundFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(NotFoundFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UnknownFailure extends Failure {
  const UnknownFailure({required this.message, this.error, this.stackTrace}): super._();
  

@override final  String message;
 final  Object? error;
 final  StackTrace? stackTrace;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownFailureCopyWith<UnknownFailure> get copyWith => _$UnknownFailureCopyWithImpl<UnknownFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownFailure&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'Failure.unknown(message: $message, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $UnknownFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $UnknownFailureCopyWith(UnknownFailure value, $Res Function(UnknownFailure) _then) = _$UnknownFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, Object? error, StackTrace? stackTrace
});




}
/// @nodoc
class _$UnknownFailureCopyWithImpl<$Res>
    implements $UnknownFailureCopyWith<$Res> {
  _$UnknownFailureCopyWithImpl(this._self, this._then);

  final UnknownFailure _self;
  final $Res Function(UnknownFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(UnknownFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error ,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class CacheFailure extends Failure {
  const CacheFailure({required this.message}): super._();
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CacheFailureCopyWith<CacheFailure> get copyWith => _$CacheFailureCopyWithImpl<CacheFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CacheFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.cache(message: $message)';
}


}

/// @nodoc
abstract mixin class $CacheFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $CacheFailureCopyWith(CacheFailure value, $Res Function(CacheFailure) _then) = _$CacheFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CacheFailureCopyWithImpl<$Res>
    implements $CacheFailureCopyWith<$Res> {
  _$CacheFailureCopyWithImpl(this._self, this._then);

  final CacheFailure _self;
  final $Res Function(CacheFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CacheFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TimeoutFailure extends Failure {
  const TimeoutFailure({required this.message}): super._();
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeoutFailureCopyWith<TimeoutFailure> get copyWith => _$TimeoutFailureCopyWithImpl<TimeoutFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeoutFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.timeout(message: $message)';
}


}

/// @nodoc
abstract mixin class $TimeoutFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $TimeoutFailureCopyWith(TimeoutFailure value, $Res Function(TimeoutFailure) _then) = _$TimeoutFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TimeoutFailureCopyWithImpl<$Res>
    implements $TimeoutFailureCopyWith<$Res> {
  _$TimeoutFailureCopyWithImpl(this._self, this._then);

  final TimeoutFailure _self;
  final $Res Function(TimeoutFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TimeoutFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PermissionFailure extends Failure {
  const PermissionFailure({required this.message}): super._();
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionFailureCopyWith<PermissionFailure> get copyWith => _$PermissionFailureCopyWithImpl<PermissionFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.permission(message: $message)';
}


}

/// @nodoc
abstract mixin class $PermissionFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $PermissionFailureCopyWith(PermissionFailure value, $Res Function(PermissionFailure) _then) = _$PermissionFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PermissionFailureCopyWithImpl<$Res>
    implements $PermissionFailureCopyWith<$Res> {
  _$PermissionFailureCopyWithImpl(this._self, this._then);

  final PermissionFailure _self;
  final $Res Function(PermissionFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PermissionFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ConflictFailure extends Failure {
  const ConflictFailure({required this.message}): super._();
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConflictFailureCopyWith<ConflictFailure> get copyWith => _$ConflictFailureCopyWithImpl<ConflictFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConflictFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.conflict(message: $message)';
}


}

/// @nodoc
abstract mixin class $ConflictFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ConflictFailureCopyWith(ConflictFailure value, $Res Function(ConflictFailure) _then) = _$ConflictFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ConflictFailureCopyWithImpl<$Res>
    implements $ConflictFailureCopyWith<$Res> {
  _$ConflictFailureCopyWithImpl(this._self, this._then);

  final ConflictFailure _self;
  final $Res Function(ConflictFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ConflictFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure({required this.message}): super._();
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TooManyRequestsFailureCopyWith<TooManyRequestsFailure> get copyWith => _$TooManyRequestsFailureCopyWithImpl<TooManyRequestsFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TooManyRequestsFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.tooManyRequests(message: $message)';
}


}

/// @nodoc
abstract mixin class $TooManyRequestsFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $TooManyRequestsFailureCopyWith(TooManyRequestsFailure value, $Res Function(TooManyRequestsFailure) _then) = _$TooManyRequestsFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TooManyRequestsFailureCopyWithImpl<$Res>
    implements $TooManyRequestsFailureCopyWith<$Res> {
  _$TooManyRequestsFailureCopyWithImpl(this._self, this._then);

  final TooManyRequestsFailure _self;
  final $Res Function(TooManyRequestsFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TooManyRequestsFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MaintenanceFailure extends Failure {
  const MaintenanceFailure({required this.message}): super._();
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaintenanceFailureCopyWith<MaintenanceFailure> get copyWith => _$MaintenanceFailureCopyWithImpl<MaintenanceFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenanceFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.maintenance(message: $message)';
}


}

/// @nodoc
abstract mixin class $MaintenanceFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $MaintenanceFailureCopyWith(MaintenanceFailure value, $Res Function(MaintenanceFailure) _then) = _$MaintenanceFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$MaintenanceFailureCopyWithImpl<$Res>
    implements $MaintenanceFailureCopyWith<$Res> {
  _$MaintenanceFailureCopyWithImpl(this._self, this._then);

  final MaintenanceFailure _self;
  final $Res Function(MaintenanceFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(MaintenanceFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PaymentFailure extends Failure {
  const PaymentFailure({required this.message}): super._();
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentFailureCopyWith<PaymentFailure> get copyWith => _$PaymentFailureCopyWithImpl<PaymentFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.payment(message: $message)';
}


}

/// @nodoc
abstract mixin class $PaymentFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $PaymentFailureCopyWith(PaymentFailure value, $Res Function(PaymentFailure) _then) = _$PaymentFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PaymentFailureCopyWithImpl<$Res>
    implements $PaymentFailureCopyWith<$Res> {
  _$PaymentFailureCopyWithImpl(this._self, this._then);

  final PaymentFailure _self;
  final $Res Function(PaymentFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PaymentFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LocationFailure extends Failure {
  const LocationFailure({required this.message}): super._();
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationFailureCopyWith<LocationFailure> get copyWith => _$LocationFailureCopyWithImpl<LocationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.location(message: $message)';
}


}

/// @nodoc
abstract mixin class $LocationFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $LocationFailureCopyWith(LocationFailure value, $Res Function(LocationFailure) _then) = _$LocationFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$LocationFailureCopyWithImpl<$Res>
    implements $LocationFailureCopyWith<$Res> {
  _$LocationFailureCopyWithImpl(this._self, this._then);

  final LocationFailure _self;
  final $Res Function(LocationFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(LocationFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class FileUploadFailure extends Failure {
  const FileUploadFailure({required this.message}): super._();
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileUploadFailureCopyWith<FileUploadFailure> get copyWith => _$FileUploadFailureCopyWithImpl<FileUploadFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileUploadFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.fileUpload(message: $message)';
}


}

/// @nodoc
abstract mixin class $FileUploadFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $FileUploadFailureCopyWith(FileUploadFailure value, $Res Function(FileUploadFailure) _then) = _$FileUploadFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$FileUploadFailureCopyWithImpl<$Res>
    implements $FileUploadFailureCopyWith<$Res> {
  _$FileUploadFailureCopyWithImpl(this._self, this._then);

  final FileUploadFailure _self;
  final $Res Function(FileUploadFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(FileUploadFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class VerificationFailure extends Failure {
  const VerificationFailure({required this.message}): super._();
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerificationFailureCopyWith<VerificationFailure> get copyWith => _$VerificationFailureCopyWithImpl<VerificationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerificationFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.verification(message: $message)';
}


}

/// @nodoc
abstract mixin class $VerificationFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $VerificationFailureCopyWith(VerificationFailure value, $Res Function(VerificationFailure) _then) = _$VerificationFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$VerificationFailureCopyWithImpl<$Res>
    implements $VerificationFailureCopyWith<$Res> {
  _$VerificationFailureCopyWithImpl(this._self, this._then);

  final VerificationFailure _self;
  final $Res Function(VerificationFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(VerificationFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RateLimitFailure extends Failure {
  const RateLimitFailure({required this.message, this.retryAfter}): super._();
  

@override final  String message;
 final  int? retryAfter;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RateLimitFailureCopyWith<RateLimitFailure> get copyWith => _$RateLimitFailureCopyWithImpl<RateLimitFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RateLimitFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.retryAfter, retryAfter) || other.retryAfter == retryAfter));
}


@override
int get hashCode => Object.hash(runtimeType,message,retryAfter);

@override
String toString() {
  return 'Failure.rateLimit(message: $message, retryAfter: $retryAfter)';
}


}

/// @nodoc
abstract mixin class $RateLimitFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $RateLimitFailureCopyWith(RateLimitFailure value, $Res Function(RateLimitFailure) _then) = _$RateLimitFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, int? retryAfter
});




}
/// @nodoc
class _$RateLimitFailureCopyWithImpl<$Res>
    implements $RateLimitFailureCopyWith<$Res> {
  _$RateLimitFailureCopyWithImpl(this._self, this._then);

  final RateLimitFailure _self;
  final $Res Function(RateLimitFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? retryAfter = freezed,}) {
  return _then(RateLimitFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,retryAfter: freezed == retryAfter ? _self.retryAfter : retryAfter // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class ServiceUnavailableFailure extends Failure {
  const ServiceUnavailableFailure({required this.message}): super._();
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceUnavailableFailureCopyWith<ServiceUnavailableFailure> get copyWith => _$ServiceUnavailableFailureCopyWithImpl<ServiceUnavailableFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceUnavailableFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.serviceUnavailable(message: $message)';
}


}

/// @nodoc
abstract mixin class $ServiceUnavailableFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ServiceUnavailableFailureCopyWith(ServiceUnavailableFailure value, $Res Function(ServiceUnavailableFailure) _then) = _$ServiceUnavailableFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ServiceUnavailableFailureCopyWithImpl<$Res>
    implements $ServiceUnavailableFailureCopyWith<$Res> {
  _$ServiceUnavailableFailureCopyWithImpl(this._self, this._then);

  final ServiceUnavailableFailure _self;
  final $Res Function(ServiceUnavailableFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ServiceUnavailableFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class BadRequestFailure extends Failure {
  const BadRequestFailure({required this.message, final  Map<String, dynamic>? details}): _details = details,super._();
  

@override final  String message;
 final  Map<String, dynamic>? _details;
 Map<String, dynamic>? get details {
  final value = _details;
  if (value == null) return null;
  if (_details is EqualUnmodifiableMapView) return _details;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BadRequestFailureCopyWith<BadRequestFailure> get copyWith => _$BadRequestFailureCopyWithImpl<BadRequestFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadRequestFailure&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._details, _details));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_details));

@override
String toString() {
  return 'Failure.badRequest(message: $message, details: $details)';
}


}

/// @nodoc
abstract mixin class $BadRequestFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $BadRequestFailureCopyWith(BadRequestFailure value, $Res Function(BadRequestFailure) _then) = _$BadRequestFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, Map<String, dynamic>? details
});




}
/// @nodoc
class _$BadRequestFailureCopyWithImpl<$Res>
    implements $BadRequestFailureCopyWith<$Res> {
  _$BadRequestFailureCopyWithImpl(this._self, this._then);

  final BadRequestFailure _self;
  final $Res Function(BadRequestFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? details = freezed,}) {
  return _then(BadRequestFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self._details : details // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

/// @nodoc


class CustomFailure extends Failure {
  const CustomFailure({required this.code, required this.message, final  Map<String, dynamic>? data}): _data = data,super._();
  

 final  String code;
@override final  String message;
 final  Map<String, dynamic>? _data;
 Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomFailureCopyWith<CustomFailure> get copyWith => _$CustomFailureCopyWithImpl<CustomFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomFailure&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,code,message,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'Failure.custom(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $CustomFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $CustomFailureCopyWith(CustomFailure value, $Res Function(CustomFailure) _then) = _$CustomFailureCopyWithImpl;
@override @useResult
$Res call({
 String code, String message, Map<String, dynamic>? data
});




}
/// @nodoc
class _$CustomFailureCopyWithImpl<$Res>
    implements $CustomFailureCopyWith<$Res> {
  _$CustomFailureCopyWithImpl(this._self, this._then);

  final CustomFailure _self;
  final $Res Function(CustomFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? data = freezed,}) {
  return _then(CustomFailure(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
