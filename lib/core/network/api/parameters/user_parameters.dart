import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting user profile
@immutable
class GetProfileParameters extends Parameters {
  final CancelToken? _cancelToken;

  const GetProfileParameters._({CancelToken? cancelToken})
    : _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => const {};

  @override
  CancelToken? get cancelToken => _cancelToken;

  static GetProfileParametersBuilder builder() => GetProfileParametersBuilder();
}

/// Builder for GetProfileParameters
class GetProfileParametersBuilder
    extends ParametersBuilder<GetProfileParameters> {
  CancelToken? _cancelToken;

  /// Set the cancel token for request cancellation
  @override
  GetProfileParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetProfileParameters
  @override
  GetProfileParameters build() {
    return GetProfileParameters._(cancelToken: _cancelToken);
  }
}

/// Parameters for updating user profile
@immutable
class UpdateProfileParameters extends Parameters {
  final String? _name;
  final String? _nickname;
  final String? _email;
  final String? _avatar;
  final String? _country;
  final String? _governorate;
  final String? _birthdate;
  final String? _gender;
  final CancelToken? _cancelToken;

  const UpdateProfileParameters._({
    String? name,
    String? nickname,
    String? email,
    String? avatar,
    String? country,
    String? governorate,
    String? birthdate,
    String? gender,
    CancelToken? cancelToken,
  }) : _name = name,
       _nickname = nickname,
       _email = email,
       _avatar = avatar,
       _country = country,
       _governorate = governorate,
       _birthdate = birthdate,
       _gender = gender,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (_name != null) json['name'] = _name;
    if (_nickname != null) json['nickname'] = _nickname;
    if (_email != null) json['email'] = _email;
    if (_avatar != null) json['avatar'] = _avatar;
    if (_country != null) json['country'] = _country;
    if (_governorate != null) json['governorate'] = _governorate;
    if (_birthdate != null) json['birthdate'] = _birthdate;
    if (_gender != null) json['gender'] = _gender;
    return json;
  }

  String? get name => _name;
  String? get nickname => _nickname;
  String? get email => _email;
  String? get avatar => _avatar;
  String? get country => _country;
  String? get governorate => _governorate;
  String? get birthdate => _birthdate;
  String? get gender => _gender;
  @override
  CancelToken? get cancelToken => _cancelToken;

  static UpdateProfileParametersBuilder builder() =>
      UpdateProfileParametersBuilder();
}

/// Builder for UpdateProfileParameters
class UpdateProfileParametersBuilder
    extends ParametersBuilder<UpdateProfileParameters> {
  String? _name;
  String? _nickname;
  String? _email;
  String? _avatar;
  String? _country;
  String? _governorate;
  String? _birthdate;
  String? _gender;
  CancelToken? _cancelToken;

  /// Set the user's full name
  UpdateProfileParametersBuilder withName(String name) {
    _name = name;
    return this;
  }

  /// Set the user's nickname
  UpdateProfileParametersBuilder withNickname(String nickname) {
    _nickname = nickname;
    return this;
  }

  /// Set the user's email
  UpdateProfileParametersBuilder withEmail(String email) {
    _email = email;
    return this;
  }

  /// Set the user's avatar URL
  UpdateProfileParametersBuilder withAvatar(String avatar) {
    _avatar = avatar;
    return this;
  }

  /// Set the user's country
  UpdateProfileParametersBuilder withCountry(String country) {
    _country = country;
    return this;
  }

  /// Set the user's governorate or state
  UpdateProfileParametersBuilder withGovernorate(String governorate) {
    _governorate = governorate;
    return this;
  }

  /// Set the user's birthdate (format: YYYY-MM-DD)
  UpdateProfileParametersBuilder withBirthdate(String birthdate) {
    _birthdate = birthdate;
    return this;
  }

  /// Set the user's gender (male or female)
  UpdateProfileParametersBuilder withGender(String gender) {
    _gender = gender;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  UpdateProfileParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the UpdateProfileParameters
  @override
  UpdateProfileParameters build() {
    return UpdateProfileParameters._(
      name: _name,
      nickname: _nickname,
      email: _email,
      avatar: _avatar,
      country: _country,
      governorate: _governorate,
      birthdate: _birthdate,
      gender: _gender,
      cancelToken: _cancelToken,
    );
  }
}
