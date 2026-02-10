// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_auth_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CompanyAuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompanyAuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompanyAuthState()';
}


}

/// @nodoc
class $CompanyAuthStateCopyWith<$Res>  {
$CompanyAuthStateCopyWith(CompanyAuthState _, $Res Function(CompanyAuthState) __);
}


/// Adds pattern-matching-related methods to [CompanyAuthState].
extension CompanyAuthStatePatterns on CompanyAuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Authenticated value)?  authenticated,TResult Function( _Unauthenticated value)?  unauthenticated,TResult Function( _Error value)?  error,TResult Function( _VerificationCodeSent value)?  verificationCodeSent,TResult Function( _PhoneVerified value)?  phoneVerified,TResult Function( _PasswordResetRequested value)?  passwordResetRequested,TResult Function( _PasswordReset value)?  passwordReset,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Authenticated() when authenticated != null:
return authenticated(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _Error() when error != null:
return error(_that);case _VerificationCodeSent() when verificationCodeSent != null:
return verificationCodeSent(_that);case _PhoneVerified() when phoneVerified != null:
return phoneVerified(_that);case _PasswordResetRequested() when passwordResetRequested != null:
return passwordResetRequested(_that);case _PasswordReset() when passwordReset != null:
return passwordReset(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Authenticated value)  authenticated,required TResult Function( _Unauthenticated value)  unauthenticated,required TResult Function( _Error value)  error,required TResult Function( _VerificationCodeSent value)  verificationCodeSent,required TResult Function( _PhoneVerified value)  phoneVerified,required TResult Function( _PasswordResetRequested value)  passwordResetRequested,required TResult Function( _PasswordReset value)  passwordReset,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Authenticated():
return authenticated(_that);case _Unauthenticated():
return unauthenticated(_that);case _Error():
return error(_that);case _VerificationCodeSent():
return verificationCodeSent(_that);case _PhoneVerified():
return phoneVerified(_that);case _PasswordResetRequested():
return passwordResetRequested(_that);case _PasswordReset():
return passwordReset(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Authenticated value)?  authenticated,TResult? Function( _Unauthenticated value)?  unauthenticated,TResult? Function( _Error value)?  error,TResult? Function( _VerificationCodeSent value)?  verificationCodeSent,TResult? Function( _PhoneVerified value)?  phoneVerified,TResult? Function( _PasswordResetRequested value)?  passwordResetRequested,TResult? Function( _PasswordReset value)?  passwordReset,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Authenticated() when authenticated != null:
return authenticated(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _Error() when error != null:
return error(_that);case _VerificationCodeSent() when verificationCodeSent != null:
return verificationCodeSent(_that);case _PhoneVerified() when phoneVerified != null:
return phoneVerified(_that);case _PasswordResetRequested() when passwordResetRequested != null:
return passwordResetRequested(_that);case _PasswordReset() when passwordReset != null:
return passwordReset(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  authenticated,TResult Function()?  unauthenticated,TResult Function( NetworkException error)?  error,TResult Function()?  verificationCodeSent,TResult Function()?  phoneVerified,TResult Function()?  passwordResetRequested,TResult Function()?  passwordReset,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Authenticated() when authenticated != null:
return authenticated();case _Unauthenticated() when unauthenticated != null:
return unauthenticated();case _Error() when error != null:
return error(_that.error);case _VerificationCodeSent() when verificationCodeSent != null:
return verificationCodeSent();case _PhoneVerified() when phoneVerified != null:
return phoneVerified();case _PasswordResetRequested() when passwordResetRequested != null:
return passwordResetRequested();case _PasswordReset() when passwordReset != null:
return passwordReset();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  authenticated,required TResult Function()  unauthenticated,required TResult Function( NetworkException error)  error,required TResult Function()  verificationCodeSent,required TResult Function()  phoneVerified,required TResult Function()  passwordResetRequested,required TResult Function()  passwordReset,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Authenticated():
return authenticated();case _Unauthenticated():
return unauthenticated();case _Error():
return error(_that.error);case _VerificationCodeSent():
return verificationCodeSent();case _PhoneVerified():
return phoneVerified();case _PasswordResetRequested():
return passwordResetRequested();case _PasswordReset():
return passwordReset();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  authenticated,TResult? Function()?  unauthenticated,TResult? Function( NetworkException error)?  error,TResult? Function()?  verificationCodeSent,TResult? Function()?  phoneVerified,TResult? Function()?  passwordResetRequested,TResult? Function()?  passwordReset,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Authenticated() when authenticated != null:
return authenticated();case _Unauthenticated() when unauthenticated != null:
return unauthenticated();case _Error() when error != null:
return error(_that.error);case _VerificationCodeSent() when verificationCodeSent != null:
return verificationCodeSent();case _PhoneVerified() when phoneVerified != null:
return phoneVerified();case _PasswordResetRequested() when passwordResetRequested != null:
return passwordResetRequested();case _PasswordReset() when passwordReset != null:
return passwordReset();case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends CompanyAuthState {
  const _Initial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompanyAuthState.initial()';
}


}




/// @nodoc


class _Loading extends CompanyAuthState {
  const _Loading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompanyAuthState.loading()';
}


}




/// @nodoc


class _Authenticated extends CompanyAuthState {
  const _Authenticated(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Authenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompanyAuthState.authenticated()';
}


}




/// @nodoc


class _Unauthenticated extends CompanyAuthState {
  const _Unauthenticated(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unauthenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompanyAuthState.unauthenticated()';
}


}




/// @nodoc


class _Error extends CompanyAuthState {
  const _Error(this.error): super._();
  

 final  NetworkException error;

/// Create a copy of CompanyAuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'CompanyAuthState.error(error: $error)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $CompanyAuthStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 NetworkException error
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of CompanyAuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_Error(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as NetworkException,
  ));
}


}

/// @nodoc


class _VerificationCodeSent extends CompanyAuthState {
  const _VerificationCodeSent(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerificationCodeSent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompanyAuthState.verificationCodeSent()';
}


}




/// @nodoc


class _PhoneVerified extends CompanyAuthState {
  const _PhoneVerified(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhoneVerified);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompanyAuthState.phoneVerified()';
}


}




/// @nodoc


class _PasswordResetRequested extends CompanyAuthState {
  const _PasswordResetRequested(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PasswordResetRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompanyAuthState.passwordResetRequested()';
}


}




/// @nodoc


class _PasswordReset extends CompanyAuthState {
  const _PasswordReset(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PasswordReset);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompanyAuthState.passwordReset()';
}


}




// dart format on
