// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_general.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApiAboutUs {

/// About us content/description
 String? get description;/// Company name
 String? get companyName;/// Company logo URL
 String? get logo;/// Contact email
 String? get email;/// Contact phone
 String? get phone;/// Website URL
 String? get website;/// Address
 String? get address;/// Social media links
 Map<String, String>? get socialMedia;
/// Create a copy of ApiAboutUs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiAboutUsCopyWith<ApiAboutUs> get copyWith => _$ApiAboutUsCopyWithImpl<ApiAboutUs>(this as ApiAboutUs, _$identity);

  /// Serializes this ApiAboutUs to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiAboutUs&&(identical(other.description, description) || other.description == description)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.website, website) || other.website == website)&&(identical(other.address, address) || other.address == address)&&const DeepCollectionEquality().equals(other.socialMedia, socialMedia));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,description,companyName,logo,email,phone,website,address,const DeepCollectionEquality().hash(socialMedia));

@override
String toString() {
  return 'ApiAboutUs(description: $description, companyName: $companyName, logo: $logo, email: $email, phone: $phone, website: $website, address: $address, socialMedia: $socialMedia)';
}


}

/// @nodoc
abstract mixin class $ApiAboutUsCopyWith<$Res>  {
  factory $ApiAboutUsCopyWith(ApiAboutUs value, $Res Function(ApiAboutUs) _then) = _$ApiAboutUsCopyWithImpl;
@useResult
$Res call({
 String? description, String? companyName, String? logo, String? email, String? phone, String? website, String? address, Map<String, String>? socialMedia
});




}
/// @nodoc
class _$ApiAboutUsCopyWithImpl<$Res>
    implements $ApiAboutUsCopyWith<$Res> {
  _$ApiAboutUsCopyWithImpl(this._self, this._then);

  final ApiAboutUs _self;
  final $Res Function(ApiAboutUs) _then;

/// Create a copy of ApiAboutUs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? description = freezed,Object? companyName = freezed,Object? logo = freezed,Object? email = freezed,Object? phone = freezed,Object? website = freezed,Object? address = freezed,Object? socialMedia = freezed,}) {
  return _then(_self.copyWith(
description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,socialMedia: freezed == socialMedia ? _self.socialMedia : socialMedia // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiAboutUs].
extension ApiAboutUsPatterns on ApiAboutUs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiAboutUs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiAboutUs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiAboutUs value)  $default,){
final _that = this;
switch (_that) {
case _ApiAboutUs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiAboutUs value)?  $default,){
final _that = this;
switch (_that) {
case _ApiAboutUs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? description,  String? companyName,  String? logo,  String? email,  String? phone,  String? website,  String? address,  Map<String, String>? socialMedia)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiAboutUs() when $default != null:
return $default(_that.description,_that.companyName,_that.logo,_that.email,_that.phone,_that.website,_that.address,_that.socialMedia);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? description,  String? companyName,  String? logo,  String? email,  String? phone,  String? website,  String? address,  Map<String, String>? socialMedia)  $default,) {final _that = this;
switch (_that) {
case _ApiAboutUs():
return $default(_that.description,_that.companyName,_that.logo,_that.email,_that.phone,_that.website,_that.address,_that.socialMedia);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? description,  String? companyName,  String? logo,  String? email,  String? phone,  String? website,  String? address,  Map<String, String>? socialMedia)?  $default,) {final _that = this;
switch (_that) {
case _ApiAboutUs() when $default != null:
return $default(_that.description,_that.companyName,_that.logo,_that.email,_that.phone,_that.website,_that.address,_that.socialMedia);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiAboutUs implements ApiAboutUs {
  const _ApiAboutUs({this.description, this.companyName, this.logo, this.email, this.phone, this.website, this.address, final  Map<String, String>? socialMedia}): _socialMedia = socialMedia;
  factory _ApiAboutUs.fromJson(Map<String, dynamic> json) => _$ApiAboutUsFromJson(json);

/// About us content/description
@override final  String? description;
/// Company name
@override final  String? companyName;
/// Company logo URL
@override final  String? logo;
/// Contact email
@override final  String? email;
/// Contact phone
@override final  String? phone;
/// Website URL
@override final  String? website;
/// Address
@override final  String? address;
/// Social media links
 final  Map<String, String>? _socialMedia;
/// Social media links
@override Map<String, String>? get socialMedia {
  final value = _socialMedia;
  if (value == null) return null;
  if (_socialMedia is EqualUnmodifiableMapView) return _socialMedia;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of ApiAboutUs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiAboutUsCopyWith<_ApiAboutUs> get copyWith => __$ApiAboutUsCopyWithImpl<_ApiAboutUs>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiAboutUsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiAboutUs&&(identical(other.description, description) || other.description == description)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.website, website) || other.website == website)&&(identical(other.address, address) || other.address == address)&&const DeepCollectionEquality().equals(other._socialMedia, _socialMedia));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,description,companyName,logo,email,phone,website,address,const DeepCollectionEquality().hash(_socialMedia));

@override
String toString() {
  return 'ApiAboutUs(description: $description, companyName: $companyName, logo: $logo, email: $email, phone: $phone, website: $website, address: $address, socialMedia: $socialMedia)';
}


}

/// @nodoc
abstract mixin class _$ApiAboutUsCopyWith<$Res> implements $ApiAboutUsCopyWith<$Res> {
  factory _$ApiAboutUsCopyWith(_ApiAboutUs value, $Res Function(_ApiAboutUs) _then) = __$ApiAboutUsCopyWithImpl;
@override @useResult
$Res call({
 String? description, String? companyName, String? logo, String? email, String? phone, String? website, String? address, Map<String, String>? socialMedia
});




}
/// @nodoc
class __$ApiAboutUsCopyWithImpl<$Res>
    implements _$ApiAboutUsCopyWith<$Res> {
  __$ApiAboutUsCopyWithImpl(this._self, this._then);

  final _ApiAboutUs _self;
  final $Res Function(_ApiAboutUs) _then;

/// Create a copy of ApiAboutUs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? description = freezed,Object? companyName = freezed,Object? logo = freezed,Object? email = freezed,Object? phone = freezed,Object? website = freezed,Object? address = freezed,Object? socialMedia = freezed,}) {
  return _then(_ApiAboutUs(
description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,socialMedia: freezed == socialMedia ? _self._socialMedia : socialMedia // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}


}


/// @nodoc
mixin _$ApiQuestion {

/// Question ID
 int get id;/// Question text
 String get question;/// Answer text
 String get answer;/// Question category (optional)
 String? get category;/// Order/priority
 int? get order;
/// Create a copy of ApiQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiQuestionCopyWith<ApiQuestion> get copyWith => _$ApiQuestionCopyWithImpl<ApiQuestion>(this as ApiQuestion, _$identity);

  /// Serializes this ApiQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.category, category) || other.category == category)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,answer,category,order);

@override
String toString() {
  return 'ApiQuestion(id: $id, question: $question, answer: $answer, category: $category, order: $order)';
}


}

/// @nodoc
abstract mixin class $ApiQuestionCopyWith<$Res>  {
  factory $ApiQuestionCopyWith(ApiQuestion value, $Res Function(ApiQuestion) _then) = _$ApiQuestionCopyWithImpl;
@useResult
$Res call({
 int id, String question, String answer, String? category, int? order
});




}
/// @nodoc
class _$ApiQuestionCopyWithImpl<$Res>
    implements $ApiQuestionCopyWith<$Res> {
  _$ApiQuestionCopyWithImpl(this._self, this._then);

  final ApiQuestion _self;
  final $Res Function(ApiQuestion) _then;

/// Create a copy of ApiQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? question = null,Object? answer = null,Object? category = freezed,Object? order = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiQuestion].
extension ApiQuestionPatterns on ApiQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiQuestion value)  $default,){
final _that = this;
switch (_that) {
case _ApiQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _ApiQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String question,  String answer,  String? category,  int? order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiQuestion() when $default != null:
return $default(_that.id,_that.question,_that.answer,_that.category,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String question,  String answer,  String? category,  int? order)  $default,) {final _that = this;
switch (_that) {
case _ApiQuestion():
return $default(_that.id,_that.question,_that.answer,_that.category,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String question,  String answer,  String? category,  int? order)?  $default,) {final _that = this;
switch (_that) {
case _ApiQuestion() when $default != null:
return $default(_that.id,_that.question,_that.answer,_that.category,_that.order);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiQuestion implements ApiQuestion {
  const _ApiQuestion({required this.id, required this.question, required this.answer, this.category, this.order});
  factory _ApiQuestion.fromJson(Map<String, dynamic> json) => _$ApiQuestionFromJson(json);

/// Question ID
@override final  int id;
/// Question text
@override final  String question;
/// Answer text
@override final  String answer;
/// Question category (optional)
@override final  String? category;
/// Order/priority
@override final  int? order;

/// Create a copy of ApiQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiQuestionCopyWith<_ApiQuestion> get copyWith => __$ApiQuestionCopyWithImpl<_ApiQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.category, category) || other.category == category)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,answer,category,order);

@override
String toString() {
  return 'ApiQuestion(id: $id, question: $question, answer: $answer, category: $category, order: $order)';
}


}

/// @nodoc
abstract mixin class _$ApiQuestionCopyWith<$Res> implements $ApiQuestionCopyWith<$Res> {
  factory _$ApiQuestionCopyWith(_ApiQuestion value, $Res Function(_ApiQuestion) _then) = __$ApiQuestionCopyWithImpl;
@override @useResult
$Res call({
 int id, String question, String answer, String? category, int? order
});




}
/// @nodoc
class __$ApiQuestionCopyWithImpl<$Res>
    implements _$ApiQuestionCopyWith<$Res> {
  __$ApiQuestionCopyWithImpl(this._self, this._then);

  final _ApiQuestion _self;
  final $Res Function(_ApiQuestion) _then;

/// Create a copy of ApiQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? question = null,Object? answer = null,Object? category = freezed,Object? order = freezed,}) {
  return _then(_ApiQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ApiPolicies {

/// Terms and conditions content
 String? get termsAndConditions;/// Privacy policy content
 String? get privacyPolicy;/// Refund policy content
 String? get refundPolicy;/// Last updated timestamp
 String? get lastUpdated;
/// Create a copy of ApiPolicies
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiPoliciesCopyWith<ApiPolicies> get copyWith => _$ApiPoliciesCopyWithImpl<ApiPolicies>(this as ApiPolicies, _$identity);

  /// Serializes this ApiPolicies to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiPolicies&&(identical(other.termsAndConditions, termsAndConditions) || other.termsAndConditions == termsAndConditions)&&(identical(other.privacyPolicy, privacyPolicy) || other.privacyPolicy == privacyPolicy)&&(identical(other.refundPolicy, refundPolicy) || other.refundPolicy == refundPolicy)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,termsAndConditions,privacyPolicy,refundPolicy,lastUpdated);

@override
String toString() {
  return 'ApiPolicies(termsAndConditions: $termsAndConditions, privacyPolicy: $privacyPolicy, refundPolicy: $refundPolicy, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class $ApiPoliciesCopyWith<$Res>  {
  factory $ApiPoliciesCopyWith(ApiPolicies value, $Res Function(ApiPolicies) _then) = _$ApiPoliciesCopyWithImpl;
@useResult
$Res call({
 String? termsAndConditions, String? privacyPolicy, String? refundPolicy, String? lastUpdated
});




}
/// @nodoc
class _$ApiPoliciesCopyWithImpl<$Res>
    implements $ApiPoliciesCopyWith<$Res> {
  _$ApiPoliciesCopyWithImpl(this._self, this._then);

  final ApiPolicies _self;
  final $Res Function(ApiPolicies) _then;

/// Create a copy of ApiPolicies
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? termsAndConditions = freezed,Object? privacyPolicy = freezed,Object? refundPolicy = freezed,Object? lastUpdated = freezed,}) {
  return _then(_self.copyWith(
termsAndConditions: freezed == termsAndConditions ? _self.termsAndConditions : termsAndConditions // ignore: cast_nullable_to_non_nullable
as String?,privacyPolicy: freezed == privacyPolicy ? _self.privacyPolicy : privacyPolicy // ignore: cast_nullable_to_non_nullable
as String?,refundPolicy: freezed == refundPolicy ? _self.refundPolicy : refundPolicy // ignore: cast_nullable_to_non_nullable
as String?,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiPolicies].
extension ApiPoliciesPatterns on ApiPolicies {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiPolicies value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiPolicies() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiPolicies value)  $default,){
final _that = this;
switch (_that) {
case _ApiPolicies():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiPolicies value)?  $default,){
final _that = this;
switch (_that) {
case _ApiPolicies() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? termsAndConditions,  String? privacyPolicy,  String? refundPolicy,  String? lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiPolicies() when $default != null:
return $default(_that.termsAndConditions,_that.privacyPolicy,_that.refundPolicy,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? termsAndConditions,  String? privacyPolicy,  String? refundPolicy,  String? lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _ApiPolicies():
return $default(_that.termsAndConditions,_that.privacyPolicy,_that.refundPolicy,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? termsAndConditions,  String? privacyPolicy,  String? refundPolicy,  String? lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _ApiPolicies() when $default != null:
return $default(_that.termsAndConditions,_that.privacyPolicy,_that.refundPolicy,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiPolicies implements ApiPolicies {
  const _ApiPolicies({this.termsAndConditions, this.privacyPolicy, this.refundPolicy, this.lastUpdated});
  factory _ApiPolicies.fromJson(Map<String, dynamic> json) => _$ApiPoliciesFromJson(json);

/// Terms and conditions content
@override final  String? termsAndConditions;
/// Privacy policy content
@override final  String? privacyPolicy;
/// Refund policy content
@override final  String? refundPolicy;
/// Last updated timestamp
@override final  String? lastUpdated;

/// Create a copy of ApiPolicies
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiPoliciesCopyWith<_ApiPolicies> get copyWith => __$ApiPoliciesCopyWithImpl<_ApiPolicies>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiPoliciesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiPolicies&&(identical(other.termsAndConditions, termsAndConditions) || other.termsAndConditions == termsAndConditions)&&(identical(other.privacyPolicy, privacyPolicy) || other.privacyPolicy == privacyPolicy)&&(identical(other.refundPolicy, refundPolicy) || other.refundPolicy == refundPolicy)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,termsAndConditions,privacyPolicy,refundPolicy,lastUpdated);

@override
String toString() {
  return 'ApiPolicies(termsAndConditions: $termsAndConditions, privacyPolicy: $privacyPolicy, refundPolicy: $refundPolicy, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$ApiPoliciesCopyWith<$Res> implements $ApiPoliciesCopyWith<$Res> {
  factory _$ApiPoliciesCopyWith(_ApiPolicies value, $Res Function(_ApiPolicies) _then) = __$ApiPoliciesCopyWithImpl;
@override @useResult
$Res call({
 String? termsAndConditions, String? privacyPolicy, String? refundPolicy, String? lastUpdated
});




}
/// @nodoc
class __$ApiPoliciesCopyWithImpl<$Res>
    implements _$ApiPoliciesCopyWith<$Res> {
  __$ApiPoliciesCopyWithImpl(this._self, this._then);

  final _ApiPolicies _self;
  final $Res Function(_ApiPolicies) _then;

/// Create a copy of ApiPolicies
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? termsAndConditions = freezed,Object? privacyPolicy = freezed,Object? refundPolicy = freezed,Object? lastUpdated = freezed,}) {
  return _then(_ApiPolicies(
termsAndConditions: freezed == termsAndConditions ? _self.termsAndConditions : termsAndConditions // ignore: cast_nullable_to_non_nullable
as String?,privacyPolicy: freezed == privacyPolicy ? _self.privacyPolicy : privacyPolicy // ignore: cast_nullable_to_non_nullable
as String?,refundPolicy: freezed == refundPolicy ? _self.refundPolicy : refundPolicy // ignore: cast_nullable_to_non_nullable
as String?,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ApiGeneralSettings {

/// App name
 String? get appName;/// App version
 String? get appVersion;/// App logo URL
 String? get appLogo;/// Support email
 String? get supportEmail;/// Support phone
 String? get supportPhone;/// Website URL
 String? get website;/// Currency code
 String? get currency;/// Currency symbol
 String? get currencySymbol;/// Default language
 String? get defaultLanguage;/// Available languages
 List<String>? get availableLanguages;/// Social media links
 Map<String, String>? get socialMedia;/// App store URL
 String? get appStoreUrl;/// Play store URL
 String? get playStoreUrl;/// Minimum required app version
 String? get minAppVersion;/// Force update flag
 bool get forceUpdate;/// Maintenance mode flag
 bool get maintenanceMode;/// Maintenance message
 String? get maintenanceMessage;
/// Create a copy of ApiGeneralSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiGeneralSettingsCopyWith<ApiGeneralSettings> get copyWith => _$ApiGeneralSettingsCopyWithImpl<ApiGeneralSettings>(this as ApiGeneralSettings, _$identity);

  /// Serializes this ApiGeneralSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiGeneralSettings&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.appLogo, appLogo) || other.appLogo == appLogo)&&(identical(other.supportEmail, supportEmail) || other.supportEmail == supportEmail)&&(identical(other.supportPhone, supportPhone) || other.supportPhone == supportPhone)&&(identical(other.website, website) || other.website == website)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.currencySymbol, currencySymbol) || other.currencySymbol == currencySymbol)&&(identical(other.defaultLanguage, defaultLanguage) || other.defaultLanguage == defaultLanguage)&&const DeepCollectionEquality().equals(other.availableLanguages, availableLanguages)&&const DeepCollectionEquality().equals(other.socialMedia, socialMedia)&&(identical(other.appStoreUrl, appStoreUrl) || other.appStoreUrl == appStoreUrl)&&(identical(other.playStoreUrl, playStoreUrl) || other.playStoreUrl == playStoreUrl)&&(identical(other.minAppVersion, minAppVersion) || other.minAppVersion == minAppVersion)&&(identical(other.forceUpdate, forceUpdate) || other.forceUpdate == forceUpdate)&&(identical(other.maintenanceMode, maintenanceMode) || other.maintenanceMode == maintenanceMode)&&(identical(other.maintenanceMessage, maintenanceMessage) || other.maintenanceMessage == maintenanceMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appName,appVersion,appLogo,supportEmail,supportPhone,website,currency,currencySymbol,defaultLanguage,const DeepCollectionEquality().hash(availableLanguages),const DeepCollectionEquality().hash(socialMedia),appStoreUrl,playStoreUrl,minAppVersion,forceUpdate,maintenanceMode,maintenanceMessage);

@override
String toString() {
  return 'ApiGeneralSettings(appName: $appName, appVersion: $appVersion, appLogo: $appLogo, supportEmail: $supportEmail, supportPhone: $supportPhone, website: $website, currency: $currency, currencySymbol: $currencySymbol, defaultLanguage: $defaultLanguage, availableLanguages: $availableLanguages, socialMedia: $socialMedia, appStoreUrl: $appStoreUrl, playStoreUrl: $playStoreUrl, minAppVersion: $minAppVersion, forceUpdate: $forceUpdate, maintenanceMode: $maintenanceMode, maintenanceMessage: $maintenanceMessage)';
}


}

/// @nodoc
abstract mixin class $ApiGeneralSettingsCopyWith<$Res>  {
  factory $ApiGeneralSettingsCopyWith(ApiGeneralSettings value, $Res Function(ApiGeneralSettings) _then) = _$ApiGeneralSettingsCopyWithImpl;
@useResult
$Res call({
 String? appName, String? appVersion, String? appLogo, String? supportEmail, String? supportPhone, String? website, String? currency, String? currencySymbol, String? defaultLanguage, List<String>? availableLanguages, Map<String, String>? socialMedia, String? appStoreUrl, String? playStoreUrl, String? minAppVersion, bool forceUpdate, bool maintenanceMode, String? maintenanceMessage
});




}
/// @nodoc
class _$ApiGeneralSettingsCopyWithImpl<$Res>
    implements $ApiGeneralSettingsCopyWith<$Res> {
  _$ApiGeneralSettingsCopyWithImpl(this._self, this._then);

  final ApiGeneralSettings _self;
  final $Res Function(ApiGeneralSettings) _then;

/// Create a copy of ApiGeneralSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appName = freezed,Object? appVersion = freezed,Object? appLogo = freezed,Object? supportEmail = freezed,Object? supportPhone = freezed,Object? website = freezed,Object? currency = freezed,Object? currencySymbol = freezed,Object? defaultLanguage = freezed,Object? availableLanguages = freezed,Object? socialMedia = freezed,Object? appStoreUrl = freezed,Object? playStoreUrl = freezed,Object? minAppVersion = freezed,Object? forceUpdate = null,Object? maintenanceMode = null,Object? maintenanceMessage = freezed,}) {
  return _then(_self.copyWith(
appName: freezed == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,appLogo: freezed == appLogo ? _self.appLogo : appLogo // ignore: cast_nullable_to_non_nullable
as String?,supportEmail: freezed == supportEmail ? _self.supportEmail : supportEmail // ignore: cast_nullable_to_non_nullable
as String?,supportPhone: freezed == supportPhone ? _self.supportPhone : supportPhone // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,currencySymbol: freezed == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String?,defaultLanguage: freezed == defaultLanguage ? _self.defaultLanguage : defaultLanguage // ignore: cast_nullable_to_non_nullable
as String?,availableLanguages: freezed == availableLanguages ? _self.availableLanguages : availableLanguages // ignore: cast_nullable_to_non_nullable
as List<String>?,socialMedia: freezed == socialMedia ? _self.socialMedia : socialMedia // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,appStoreUrl: freezed == appStoreUrl ? _self.appStoreUrl : appStoreUrl // ignore: cast_nullable_to_non_nullable
as String?,playStoreUrl: freezed == playStoreUrl ? _self.playStoreUrl : playStoreUrl // ignore: cast_nullable_to_non_nullable
as String?,minAppVersion: freezed == minAppVersion ? _self.minAppVersion : minAppVersion // ignore: cast_nullable_to_non_nullable
as String?,forceUpdate: null == forceUpdate ? _self.forceUpdate : forceUpdate // ignore: cast_nullable_to_non_nullable
as bool,maintenanceMode: null == maintenanceMode ? _self.maintenanceMode : maintenanceMode // ignore: cast_nullable_to_non_nullable
as bool,maintenanceMessage: freezed == maintenanceMessage ? _self.maintenanceMessage : maintenanceMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiGeneralSettings].
extension ApiGeneralSettingsPatterns on ApiGeneralSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiGeneralSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiGeneralSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiGeneralSettings value)  $default,){
final _that = this;
switch (_that) {
case _ApiGeneralSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiGeneralSettings value)?  $default,){
final _that = this;
switch (_that) {
case _ApiGeneralSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? appName,  String? appVersion,  String? appLogo,  String? supportEmail,  String? supportPhone,  String? website,  String? currency,  String? currencySymbol,  String? defaultLanguage,  List<String>? availableLanguages,  Map<String, String>? socialMedia,  String? appStoreUrl,  String? playStoreUrl,  String? minAppVersion,  bool forceUpdate,  bool maintenanceMode,  String? maintenanceMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiGeneralSettings() when $default != null:
return $default(_that.appName,_that.appVersion,_that.appLogo,_that.supportEmail,_that.supportPhone,_that.website,_that.currency,_that.currencySymbol,_that.defaultLanguage,_that.availableLanguages,_that.socialMedia,_that.appStoreUrl,_that.playStoreUrl,_that.minAppVersion,_that.forceUpdate,_that.maintenanceMode,_that.maintenanceMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? appName,  String? appVersion,  String? appLogo,  String? supportEmail,  String? supportPhone,  String? website,  String? currency,  String? currencySymbol,  String? defaultLanguage,  List<String>? availableLanguages,  Map<String, String>? socialMedia,  String? appStoreUrl,  String? playStoreUrl,  String? minAppVersion,  bool forceUpdate,  bool maintenanceMode,  String? maintenanceMessage)  $default,) {final _that = this;
switch (_that) {
case _ApiGeneralSettings():
return $default(_that.appName,_that.appVersion,_that.appLogo,_that.supportEmail,_that.supportPhone,_that.website,_that.currency,_that.currencySymbol,_that.defaultLanguage,_that.availableLanguages,_that.socialMedia,_that.appStoreUrl,_that.playStoreUrl,_that.minAppVersion,_that.forceUpdate,_that.maintenanceMode,_that.maintenanceMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? appName,  String? appVersion,  String? appLogo,  String? supportEmail,  String? supportPhone,  String? website,  String? currency,  String? currencySymbol,  String? defaultLanguage,  List<String>? availableLanguages,  Map<String, String>? socialMedia,  String? appStoreUrl,  String? playStoreUrl,  String? minAppVersion,  bool forceUpdate,  bool maintenanceMode,  String? maintenanceMessage)?  $default,) {final _that = this;
switch (_that) {
case _ApiGeneralSettings() when $default != null:
return $default(_that.appName,_that.appVersion,_that.appLogo,_that.supportEmail,_that.supportPhone,_that.website,_that.currency,_that.currencySymbol,_that.defaultLanguage,_that.availableLanguages,_that.socialMedia,_that.appStoreUrl,_that.playStoreUrl,_that.minAppVersion,_that.forceUpdate,_that.maintenanceMode,_that.maintenanceMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiGeneralSettings implements ApiGeneralSettings {
  const _ApiGeneralSettings({this.appName, this.appVersion, this.appLogo, this.supportEmail, this.supportPhone, this.website, this.currency, this.currencySymbol, this.defaultLanguage, final  List<String>? availableLanguages, final  Map<String, String>? socialMedia, this.appStoreUrl, this.playStoreUrl, this.minAppVersion, this.forceUpdate = false, this.maintenanceMode = false, this.maintenanceMessage}): _availableLanguages = availableLanguages,_socialMedia = socialMedia;
  factory _ApiGeneralSettings.fromJson(Map<String, dynamic> json) => _$ApiGeneralSettingsFromJson(json);

/// App name
@override final  String? appName;
/// App version
@override final  String? appVersion;
/// App logo URL
@override final  String? appLogo;
/// Support email
@override final  String? supportEmail;
/// Support phone
@override final  String? supportPhone;
/// Website URL
@override final  String? website;
/// Currency code
@override final  String? currency;
/// Currency symbol
@override final  String? currencySymbol;
/// Default language
@override final  String? defaultLanguage;
/// Available languages
 final  List<String>? _availableLanguages;
/// Available languages
@override List<String>? get availableLanguages {
  final value = _availableLanguages;
  if (value == null) return null;
  if (_availableLanguages is EqualUnmodifiableListView) return _availableLanguages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Social media links
 final  Map<String, String>? _socialMedia;
/// Social media links
@override Map<String, String>? get socialMedia {
  final value = _socialMedia;
  if (value == null) return null;
  if (_socialMedia is EqualUnmodifiableMapView) return _socialMedia;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

/// App store URL
@override final  String? appStoreUrl;
/// Play store URL
@override final  String? playStoreUrl;
/// Minimum required app version
@override final  String? minAppVersion;
/// Force update flag
@override@JsonKey() final  bool forceUpdate;
/// Maintenance mode flag
@override@JsonKey() final  bool maintenanceMode;
/// Maintenance message
@override final  String? maintenanceMessage;

/// Create a copy of ApiGeneralSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiGeneralSettingsCopyWith<_ApiGeneralSettings> get copyWith => __$ApiGeneralSettingsCopyWithImpl<_ApiGeneralSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiGeneralSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiGeneralSettings&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.appLogo, appLogo) || other.appLogo == appLogo)&&(identical(other.supportEmail, supportEmail) || other.supportEmail == supportEmail)&&(identical(other.supportPhone, supportPhone) || other.supportPhone == supportPhone)&&(identical(other.website, website) || other.website == website)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.currencySymbol, currencySymbol) || other.currencySymbol == currencySymbol)&&(identical(other.defaultLanguage, defaultLanguage) || other.defaultLanguage == defaultLanguage)&&const DeepCollectionEquality().equals(other._availableLanguages, _availableLanguages)&&const DeepCollectionEquality().equals(other._socialMedia, _socialMedia)&&(identical(other.appStoreUrl, appStoreUrl) || other.appStoreUrl == appStoreUrl)&&(identical(other.playStoreUrl, playStoreUrl) || other.playStoreUrl == playStoreUrl)&&(identical(other.minAppVersion, minAppVersion) || other.minAppVersion == minAppVersion)&&(identical(other.forceUpdate, forceUpdate) || other.forceUpdate == forceUpdate)&&(identical(other.maintenanceMode, maintenanceMode) || other.maintenanceMode == maintenanceMode)&&(identical(other.maintenanceMessage, maintenanceMessage) || other.maintenanceMessage == maintenanceMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appName,appVersion,appLogo,supportEmail,supportPhone,website,currency,currencySymbol,defaultLanguage,const DeepCollectionEquality().hash(_availableLanguages),const DeepCollectionEquality().hash(_socialMedia),appStoreUrl,playStoreUrl,minAppVersion,forceUpdate,maintenanceMode,maintenanceMessage);

@override
String toString() {
  return 'ApiGeneralSettings(appName: $appName, appVersion: $appVersion, appLogo: $appLogo, supportEmail: $supportEmail, supportPhone: $supportPhone, website: $website, currency: $currency, currencySymbol: $currencySymbol, defaultLanguage: $defaultLanguage, availableLanguages: $availableLanguages, socialMedia: $socialMedia, appStoreUrl: $appStoreUrl, playStoreUrl: $playStoreUrl, minAppVersion: $minAppVersion, forceUpdate: $forceUpdate, maintenanceMode: $maintenanceMode, maintenanceMessage: $maintenanceMessage)';
}


}

/// @nodoc
abstract mixin class _$ApiGeneralSettingsCopyWith<$Res> implements $ApiGeneralSettingsCopyWith<$Res> {
  factory _$ApiGeneralSettingsCopyWith(_ApiGeneralSettings value, $Res Function(_ApiGeneralSettings) _then) = __$ApiGeneralSettingsCopyWithImpl;
@override @useResult
$Res call({
 String? appName, String? appVersion, String? appLogo, String? supportEmail, String? supportPhone, String? website, String? currency, String? currencySymbol, String? defaultLanguage, List<String>? availableLanguages, Map<String, String>? socialMedia, String? appStoreUrl, String? playStoreUrl, String? minAppVersion, bool forceUpdate, bool maintenanceMode, String? maintenanceMessage
});




}
/// @nodoc
class __$ApiGeneralSettingsCopyWithImpl<$Res>
    implements _$ApiGeneralSettingsCopyWith<$Res> {
  __$ApiGeneralSettingsCopyWithImpl(this._self, this._then);

  final _ApiGeneralSettings _self;
  final $Res Function(_ApiGeneralSettings) _then;

/// Create a copy of ApiGeneralSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appName = freezed,Object? appVersion = freezed,Object? appLogo = freezed,Object? supportEmail = freezed,Object? supportPhone = freezed,Object? website = freezed,Object? currency = freezed,Object? currencySymbol = freezed,Object? defaultLanguage = freezed,Object? availableLanguages = freezed,Object? socialMedia = freezed,Object? appStoreUrl = freezed,Object? playStoreUrl = freezed,Object? minAppVersion = freezed,Object? forceUpdate = null,Object? maintenanceMode = null,Object? maintenanceMessage = freezed,}) {
  return _then(_ApiGeneralSettings(
appName: freezed == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,appLogo: freezed == appLogo ? _self.appLogo : appLogo // ignore: cast_nullable_to_non_nullable
as String?,supportEmail: freezed == supportEmail ? _self.supportEmail : supportEmail // ignore: cast_nullable_to_non_nullable
as String?,supportPhone: freezed == supportPhone ? _self.supportPhone : supportPhone // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,currencySymbol: freezed == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String?,defaultLanguage: freezed == defaultLanguage ? _self.defaultLanguage : defaultLanguage // ignore: cast_nullable_to_non_nullable
as String?,availableLanguages: freezed == availableLanguages ? _self._availableLanguages : availableLanguages // ignore: cast_nullable_to_non_nullable
as List<String>?,socialMedia: freezed == socialMedia ? _self._socialMedia : socialMedia // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,appStoreUrl: freezed == appStoreUrl ? _self.appStoreUrl : appStoreUrl // ignore: cast_nullable_to_non_nullable
as String?,playStoreUrl: freezed == playStoreUrl ? _self.playStoreUrl : playStoreUrl // ignore: cast_nullable_to_non_nullable
as String?,minAppVersion: freezed == minAppVersion ? _self.minAppVersion : minAppVersion // ignore: cast_nullable_to_non_nullable
as String?,forceUpdate: null == forceUpdate ? _self.forceUpdate : forceUpdate // ignore: cast_nullable_to_non_nullable
as bool,maintenanceMode: null == maintenanceMode ? _self.maintenanceMode : maintenanceMode // ignore: cast_nullable_to_non_nullable
as bool,maintenanceMessage: freezed == maintenanceMessage ? _self.maintenanceMessage : maintenanceMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
