// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApiUserProfile {

 int get id; String get name; String? get nickname; String get phone; String? get email; String? get avatar; String get companyType; String? get country; String? get governorate; String? get birthdate; String? get gender; bool? get isVerified; bool? get isActive; String? get firebaseToken; double? get rating; int? get totalTrips;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of ApiUserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiUserProfileCopyWith<ApiUserProfile> get copyWith => _$ApiUserProfileCopyWithImpl<ApiUserProfile>(this as ApiUserProfile, _$identity);

  /// Serializes this ApiUserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiUserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.companyType, companyType) || other.companyType == companyType)&&(identical(other.country, country) || other.country == country)&&(identical(other.governorate, governorate) || other.governorate == governorate)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.firebaseToken, firebaseToken) || other.firebaseToken == firebaseToken)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalTrips, totalTrips) || other.totalTrips == totalTrips)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nickname,phone,email,avatar,companyType,country,governorate,birthdate,gender,isVerified,isActive,firebaseToken,rating,totalTrips,createdAt,updatedAt);

@override
String toString() {
  return 'ApiUserProfile(id: $id, name: $name, nickname: $nickname, phone: $phone, email: $email, avatar: $avatar, companyType: $companyType, country: $country, governorate: $governorate, birthdate: $birthdate, gender: $gender, isVerified: $isVerified, isActive: $isActive, firebaseToken: $firebaseToken, rating: $rating, totalTrips: $totalTrips, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ApiUserProfileCopyWith<$Res>  {
  factory $ApiUserProfileCopyWith(ApiUserProfile value, $Res Function(ApiUserProfile) _then) = _$ApiUserProfileCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? nickname, String phone, String? email, String? avatar, String companyType, String? country, String? governorate, String? birthdate, String? gender, bool? isVerified, bool? isActive, String? firebaseToken, double? rating, int? totalTrips,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$ApiUserProfileCopyWithImpl<$Res>
    implements $ApiUserProfileCopyWith<$Res> {
  _$ApiUserProfileCopyWithImpl(this._self, this._then);

  final ApiUserProfile _self;
  final $Res Function(ApiUserProfile) _then;

/// Create a copy of ApiUserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nickname = freezed,Object? phone = null,Object? email = freezed,Object? avatar = freezed,Object? companyType = null,Object? country = freezed,Object? governorate = freezed,Object? birthdate = freezed,Object? gender = freezed,Object? isVerified = freezed,Object? isActive = freezed,Object? firebaseToken = freezed,Object? rating = freezed,Object? totalTrips = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,companyType: null == companyType ? _self.companyType : companyType // ignore: cast_nullable_to_non_nullable
as String,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,governorate: freezed == governorate ? _self.governorate : governorate // ignore: cast_nullable_to_non_nullable
as String?,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,isVerified: freezed == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,firebaseToken: freezed == firebaseToken ? _self.firebaseToken : firebaseToken // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,totalTrips: freezed == totalTrips ? _self.totalTrips : totalTrips // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiUserProfile].
extension ApiUserProfilePatterns on ApiUserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiUserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiUserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiUserProfile value)  $default,){
final _that = this;
switch (_that) {
case _ApiUserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiUserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _ApiUserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? nickname,  String phone,  String? email,  String? avatar,  String companyType,  String? country,  String? governorate,  String? birthdate,  String? gender,  bool? isVerified,  bool? isActive,  String? firebaseToken,  double? rating,  int? totalTrips, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiUserProfile() when $default != null:
return $default(_that.id,_that.name,_that.nickname,_that.phone,_that.email,_that.avatar,_that.companyType,_that.country,_that.governorate,_that.birthdate,_that.gender,_that.isVerified,_that.isActive,_that.firebaseToken,_that.rating,_that.totalTrips,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? nickname,  String phone,  String? email,  String? avatar,  String companyType,  String? country,  String? governorate,  String? birthdate,  String? gender,  bool? isVerified,  bool? isActive,  String? firebaseToken,  double? rating,  int? totalTrips, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ApiUserProfile():
return $default(_that.id,_that.name,_that.nickname,_that.phone,_that.email,_that.avatar,_that.companyType,_that.country,_that.governorate,_that.birthdate,_that.gender,_that.isVerified,_that.isActive,_that.firebaseToken,_that.rating,_that.totalTrips,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? nickname,  String phone,  String? email,  String? avatar,  String companyType,  String? country,  String? governorate,  String? birthdate,  String? gender,  bool? isVerified,  bool? isActive,  String? firebaseToken,  double? rating,  int? totalTrips, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ApiUserProfile() when $default != null:
return $default(_that.id,_that.name,_that.nickname,_that.phone,_that.email,_that.avatar,_that.companyType,_that.country,_that.governorate,_that.birthdate,_that.gender,_that.isVerified,_that.isActive,_that.firebaseToken,_that.rating,_that.totalTrips,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiUserProfile implements ApiUserProfile {
  const _ApiUserProfile({required this.id, required this.name, this.nickname, required this.phone, this.email, this.avatar, required this.companyType, this.country, this.governorate, this.birthdate, this.gender, this.isVerified, this.isActive, this.firebaseToken, this.rating, this.totalTrips, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _ApiUserProfile.fromJson(Map<String, dynamic> json) => _$ApiUserProfileFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? nickname;
@override final  String phone;
@override final  String? email;
@override final  String? avatar;
@override final  String companyType;
@override final  String? country;
@override final  String? governorate;
@override final  String? birthdate;
@override final  String? gender;
@override final  bool? isVerified;
@override final  bool? isActive;
@override final  String? firebaseToken;
@override final  double? rating;
@override final  int? totalTrips;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of ApiUserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiUserProfileCopyWith<_ApiUserProfile> get copyWith => __$ApiUserProfileCopyWithImpl<_ApiUserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiUserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiUserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.companyType, companyType) || other.companyType == companyType)&&(identical(other.country, country) || other.country == country)&&(identical(other.governorate, governorate) || other.governorate == governorate)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.firebaseToken, firebaseToken) || other.firebaseToken == firebaseToken)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalTrips, totalTrips) || other.totalTrips == totalTrips)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nickname,phone,email,avatar,companyType,country,governorate,birthdate,gender,isVerified,isActive,firebaseToken,rating,totalTrips,createdAt,updatedAt);

@override
String toString() {
  return 'ApiUserProfile(id: $id, name: $name, nickname: $nickname, phone: $phone, email: $email, avatar: $avatar, companyType: $companyType, country: $country, governorate: $governorate, birthdate: $birthdate, gender: $gender, isVerified: $isVerified, isActive: $isActive, firebaseToken: $firebaseToken, rating: $rating, totalTrips: $totalTrips, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ApiUserProfileCopyWith<$Res> implements $ApiUserProfileCopyWith<$Res> {
  factory _$ApiUserProfileCopyWith(_ApiUserProfile value, $Res Function(_ApiUserProfile) _then) = __$ApiUserProfileCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? nickname, String phone, String? email, String? avatar, String companyType, String? country, String? governorate, String? birthdate, String? gender, bool? isVerified, bool? isActive, String? firebaseToken, double? rating, int? totalTrips,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$ApiUserProfileCopyWithImpl<$Res>
    implements _$ApiUserProfileCopyWith<$Res> {
  __$ApiUserProfileCopyWithImpl(this._self, this._then);

  final _ApiUserProfile _self;
  final $Res Function(_ApiUserProfile) _then;

/// Create a copy of ApiUserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nickname = freezed,Object? phone = null,Object? email = freezed,Object? avatar = freezed,Object? companyType = null,Object? country = freezed,Object? governorate = freezed,Object? birthdate = freezed,Object? gender = freezed,Object? isVerified = freezed,Object? isActive = freezed,Object? firebaseToken = freezed,Object? rating = freezed,Object? totalTrips = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ApiUserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,companyType: null == companyType ? _self.companyType : companyType // ignore: cast_nullable_to_non_nullable
as String,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,governorate: freezed == governorate ? _self.governorate : governorate // ignore: cast_nullable_to_non_nullable
as String?,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,isVerified: freezed == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,firebaseToken: freezed == firebaseToken ? _self.firebaseToken : firebaseToken // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,totalTrips: freezed == totalTrips ? _self.totalTrips : totalTrips // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ApiDriverProfile {

 int get id; String get name; String? get nickname; String get phone; String? get email; String? get avatar; String? get country; String? get governorate; String? get birthdate; String? get gender; bool? get isVerified; bool? get isActive; String? get vehicleType; String? get vehicleModel; String? get vehiclePlateNumber; String? get licenseNumber; double? get rating; int? get totalTrips; int? get totalReviews; bool? get isAvailable;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of ApiDriverProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiDriverProfileCopyWith<ApiDriverProfile> get copyWith => _$ApiDriverProfileCopyWithImpl<ApiDriverProfile>(this as ApiDriverProfile, _$identity);

  /// Serializes this ApiDriverProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiDriverProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.country, country) || other.country == country)&&(identical(other.governorate, governorate) || other.governorate == governorate)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.vehicleType, vehicleType) || other.vehicleType == vehicleType)&&(identical(other.vehicleModel, vehicleModel) || other.vehicleModel == vehicleModel)&&(identical(other.vehiclePlateNumber, vehiclePlateNumber) || other.vehiclePlateNumber == vehiclePlateNumber)&&(identical(other.licenseNumber, licenseNumber) || other.licenseNumber == licenseNumber)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalTrips, totalTrips) || other.totalTrips == totalTrips)&&(identical(other.totalReviews, totalReviews) || other.totalReviews == totalReviews)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,nickname,phone,email,avatar,country,governorate,birthdate,gender,isVerified,isActive,vehicleType,vehicleModel,vehiclePlateNumber,licenseNumber,rating,totalTrips,totalReviews,isAvailable,createdAt,updatedAt]);

@override
String toString() {
  return 'ApiDriverProfile(id: $id, name: $name, nickname: $nickname, phone: $phone, email: $email, avatar: $avatar, country: $country, governorate: $governorate, birthdate: $birthdate, gender: $gender, isVerified: $isVerified, isActive: $isActive, vehicleType: $vehicleType, vehicleModel: $vehicleModel, vehiclePlateNumber: $vehiclePlateNumber, licenseNumber: $licenseNumber, rating: $rating, totalTrips: $totalTrips, totalReviews: $totalReviews, isAvailable: $isAvailable, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ApiDriverProfileCopyWith<$Res>  {
  factory $ApiDriverProfileCopyWith(ApiDriverProfile value, $Res Function(ApiDriverProfile) _then) = _$ApiDriverProfileCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? nickname, String phone, String? email, String? avatar, String? country, String? governorate, String? birthdate, String? gender, bool? isVerified, bool? isActive, String? vehicleType, String? vehicleModel, String? vehiclePlateNumber, String? licenseNumber, double? rating, int? totalTrips, int? totalReviews, bool? isAvailable,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$ApiDriverProfileCopyWithImpl<$Res>
    implements $ApiDriverProfileCopyWith<$Res> {
  _$ApiDriverProfileCopyWithImpl(this._self, this._then);

  final ApiDriverProfile _self;
  final $Res Function(ApiDriverProfile) _then;

/// Create a copy of ApiDriverProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nickname = freezed,Object? phone = null,Object? email = freezed,Object? avatar = freezed,Object? country = freezed,Object? governorate = freezed,Object? birthdate = freezed,Object? gender = freezed,Object? isVerified = freezed,Object? isActive = freezed,Object? vehicleType = freezed,Object? vehicleModel = freezed,Object? vehiclePlateNumber = freezed,Object? licenseNumber = freezed,Object? rating = freezed,Object? totalTrips = freezed,Object? totalReviews = freezed,Object? isAvailable = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,governorate: freezed == governorate ? _self.governorate : governorate // ignore: cast_nullable_to_non_nullable
as String?,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,isVerified: freezed == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,vehicleType: freezed == vehicleType ? _self.vehicleType : vehicleType // ignore: cast_nullable_to_non_nullable
as String?,vehicleModel: freezed == vehicleModel ? _self.vehicleModel : vehicleModel // ignore: cast_nullable_to_non_nullable
as String?,vehiclePlateNumber: freezed == vehiclePlateNumber ? _self.vehiclePlateNumber : vehiclePlateNumber // ignore: cast_nullable_to_non_nullable
as String?,licenseNumber: freezed == licenseNumber ? _self.licenseNumber : licenseNumber // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,totalTrips: freezed == totalTrips ? _self.totalTrips : totalTrips // ignore: cast_nullable_to_non_nullable
as int?,totalReviews: freezed == totalReviews ? _self.totalReviews : totalReviews // ignore: cast_nullable_to_non_nullable
as int?,isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiDriverProfile].
extension ApiDriverProfilePatterns on ApiDriverProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiDriverProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiDriverProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiDriverProfile value)  $default,){
final _that = this;
switch (_that) {
case _ApiDriverProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiDriverProfile value)?  $default,){
final _that = this;
switch (_that) {
case _ApiDriverProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? nickname,  String phone,  String? email,  String? avatar,  String? country,  String? governorate,  String? birthdate,  String? gender,  bool? isVerified,  bool? isActive,  String? vehicleType,  String? vehicleModel,  String? vehiclePlateNumber,  String? licenseNumber,  double? rating,  int? totalTrips,  int? totalReviews,  bool? isAvailable, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiDriverProfile() when $default != null:
return $default(_that.id,_that.name,_that.nickname,_that.phone,_that.email,_that.avatar,_that.country,_that.governorate,_that.birthdate,_that.gender,_that.isVerified,_that.isActive,_that.vehicleType,_that.vehicleModel,_that.vehiclePlateNumber,_that.licenseNumber,_that.rating,_that.totalTrips,_that.totalReviews,_that.isAvailable,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? nickname,  String phone,  String? email,  String? avatar,  String? country,  String? governorate,  String? birthdate,  String? gender,  bool? isVerified,  bool? isActive,  String? vehicleType,  String? vehicleModel,  String? vehiclePlateNumber,  String? licenseNumber,  double? rating,  int? totalTrips,  int? totalReviews,  bool? isAvailable, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ApiDriverProfile():
return $default(_that.id,_that.name,_that.nickname,_that.phone,_that.email,_that.avatar,_that.country,_that.governorate,_that.birthdate,_that.gender,_that.isVerified,_that.isActive,_that.vehicleType,_that.vehicleModel,_that.vehiclePlateNumber,_that.licenseNumber,_that.rating,_that.totalTrips,_that.totalReviews,_that.isAvailable,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? nickname,  String phone,  String? email,  String? avatar,  String? country,  String? governorate,  String? birthdate,  String? gender,  bool? isVerified,  bool? isActive,  String? vehicleType,  String? vehicleModel,  String? vehiclePlateNumber,  String? licenseNumber,  double? rating,  int? totalTrips,  int? totalReviews,  bool? isAvailable, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ApiDriverProfile() when $default != null:
return $default(_that.id,_that.name,_that.nickname,_that.phone,_that.email,_that.avatar,_that.country,_that.governorate,_that.birthdate,_that.gender,_that.isVerified,_that.isActive,_that.vehicleType,_that.vehicleModel,_that.vehiclePlateNumber,_that.licenseNumber,_that.rating,_that.totalTrips,_that.totalReviews,_that.isAvailable,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiDriverProfile implements ApiDriverProfile {
  const _ApiDriverProfile({required this.id, required this.name, this.nickname, required this.phone, this.email, this.avatar, this.country, this.governorate, this.birthdate, this.gender, this.isVerified, this.isActive, this.vehicleType, this.vehicleModel, this.vehiclePlateNumber, this.licenseNumber, this.rating, this.totalTrips, this.totalReviews, this.isAvailable, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _ApiDriverProfile.fromJson(Map<String, dynamic> json) => _$ApiDriverProfileFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? nickname;
@override final  String phone;
@override final  String? email;
@override final  String? avatar;
@override final  String? country;
@override final  String? governorate;
@override final  String? birthdate;
@override final  String? gender;
@override final  bool? isVerified;
@override final  bool? isActive;
@override final  String? vehicleType;
@override final  String? vehicleModel;
@override final  String? vehiclePlateNumber;
@override final  String? licenseNumber;
@override final  double? rating;
@override final  int? totalTrips;
@override final  int? totalReviews;
@override final  bool? isAvailable;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of ApiDriverProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiDriverProfileCopyWith<_ApiDriverProfile> get copyWith => __$ApiDriverProfileCopyWithImpl<_ApiDriverProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiDriverProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiDriverProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.country, country) || other.country == country)&&(identical(other.governorate, governorate) || other.governorate == governorate)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.vehicleType, vehicleType) || other.vehicleType == vehicleType)&&(identical(other.vehicleModel, vehicleModel) || other.vehicleModel == vehicleModel)&&(identical(other.vehiclePlateNumber, vehiclePlateNumber) || other.vehiclePlateNumber == vehiclePlateNumber)&&(identical(other.licenseNumber, licenseNumber) || other.licenseNumber == licenseNumber)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalTrips, totalTrips) || other.totalTrips == totalTrips)&&(identical(other.totalReviews, totalReviews) || other.totalReviews == totalReviews)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,nickname,phone,email,avatar,country,governorate,birthdate,gender,isVerified,isActive,vehicleType,vehicleModel,vehiclePlateNumber,licenseNumber,rating,totalTrips,totalReviews,isAvailable,createdAt,updatedAt]);

@override
String toString() {
  return 'ApiDriverProfile(id: $id, name: $name, nickname: $nickname, phone: $phone, email: $email, avatar: $avatar, country: $country, governorate: $governorate, birthdate: $birthdate, gender: $gender, isVerified: $isVerified, isActive: $isActive, vehicleType: $vehicleType, vehicleModel: $vehicleModel, vehiclePlateNumber: $vehiclePlateNumber, licenseNumber: $licenseNumber, rating: $rating, totalTrips: $totalTrips, totalReviews: $totalReviews, isAvailable: $isAvailable, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ApiDriverProfileCopyWith<$Res> implements $ApiDriverProfileCopyWith<$Res> {
  factory _$ApiDriverProfileCopyWith(_ApiDriverProfile value, $Res Function(_ApiDriverProfile) _then) = __$ApiDriverProfileCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? nickname, String phone, String? email, String? avatar, String? country, String? governorate, String? birthdate, String? gender, bool? isVerified, bool? isActive, String? vehicleType, String? vehicleModel, String? vehiclePlateNumber, String? licenseNumber, double? rating, int? totalTrips, int? totalReviews, bool? isAvailable,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$ApiDriverProfileCopyWithImpl<$Res>
    implements _$ApiDriverProfileCopyWith<$Res> {
  __$ApiDriverProfileCopyWithImpl(this._self, this._then);

  final _ApiDriverProfile _self;
  final $Res Function(_ApiDriverProfile) _then;

/// Create a copy of ApiDriverProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nickname = freezed,Object? phone = null,Object? email = freezed,Object? avatar = freezed,Object? country = freezed,Object? governorate = freezed,Object? birthdate = freezed,Object? gender = freezed,Object? isVerified = freezed,Object? isActive = freezed,Object? vehicleType = freezed,Object? vehicleModel = freezed,Object? vehiclePlateNumber = freezed,Object? licenseNumber = freezed,Object? rating = freezed,Object? totalTrips = freezed,Object? totalReviews = freezed,Object? isAvailable = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ApiDriverProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,governorate: freezed == governorate ? _self.governorate : governorate // ignore: cast_nullable_to_non_nullable
as String?,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,isVerified: freezed == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,vehicleType: freezed == vehicleType ? _self.vehicleType : vehicleType // ignore: cast_nullable_to_non_nullable
as String?,vehicleModel: freezed == vehicleModel ? _self.vehicleModel : vehicleModel // ignore: cast_nullable_to_non_nullable
as String?,vehiclePlateNumber: freezed == vehiclePlateNumber ? _self.vehiclePlateNumber : vehiclePlateNumber // ignore: cast_nullable_to_non_nullable
as String?,licenseNumber: freezed == licenseNumber ? _self.licenseNumber : licenseNumber // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,totalTrips: freezed == totalTrips ? _self.totalTrips : totalTrips // ignore: cast_nullable_to_non_nullable
as int?,totalReviews: freezed == totalReviews ? _self.totalReviews : totalReviews // ignore: cast_nullable_to_non_nullable
as int?,isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
