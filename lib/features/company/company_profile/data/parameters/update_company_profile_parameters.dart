// lib/features/company/company_profile/data/parameters/update_company_profile_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Update Company Profile API parameters
///
/// Used to update company profile information.
/// Based on API_DOCUMENTATION.md
class UpdateCompanyProfileParameters extends Parameters {
  final String? name;
  final String? nickname;
  final String? email;
  final String? phone;
  final String? phoneIsoCode;
  final String? birthdate;
  final String? gender;
  final int? countryId;
  final int? governorateId;
  final String? address;
  final String? bio;
  @override
  final CancelToken? cancelToken;

  const UpdateCompanyProfileParameters({
    this.name,
    this.nickname,
    this.email,
    this.phone,
    this.phoneIsoCode,
    this.birthdate,
    this.gender,
    this.countryId,
    this.governorateId,
    this.address,
    this.bio,
    this.cancelToken,
  });

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (nickname != null) 'nickname': nickname,
    if (email != null) 'email': email,
    if (phone != null) 'phone': phone,
    if (phoneIsoCode != null) 'phone_iso_code': phoneIsoCode,
    if (birthdate != null) 'birthdate': birthdate,
    if (gender != null) 'gender': gender,
    if (countryId != null) 'country_id': countryId,
    if (governorateId != null) 'governorate_id': governorateId,
    if (address != null) 'address': address,
    if (bio != null) 'bio': bio,
  };

  /// Create a builder for this parameters type
  UpdateCompanyProfileParametersBuilder builder() => UpdateCompanyProfileParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdateCompanyProfileParameters &&
        other.name == name &&
        other.nickname == nickname &&
        other.email == email &&
        other.phone == phone &&
        other.phoneIsoCode == phoneIsoCode &&
        other.birthdate == birthdate &&
        other.gender == gender &&
        other.countryId == countryId &&
        other.governorateId == governorateId &&
        other.address == address &&
        other.bio == bio &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode =>
      name.hashCode ^
      nickname.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      phoneIsoCode.hashCode ^
      birthdate.hashCode ^
      gender.hashCode ^
      countryId.hashCode ^
      governorateId.hashCode ^
      address.hashCode ^
      bio.hashCode ^
      cancelToken.hashCode;

  @override
  String toString() =>
      'UpdateCompanyProfileParameters(name: $name, nickname: $nickname, email: $email, phone: $phone, phoneIsoCode: $phoneIsoCode, birthdate: $birthdate, gender: $gender, countryId: $countryId, governorateId: $governorateId, address: $address, bio: $bio, cancelToken: $cancelToken)';
}

/// Builder for UpdateCompanyProfileParameters
class UpdateCompanyProfileParametersBuilder
    extends ParametersBuilder<UpdateCompanyProfileParameters> {
  String? _name;
  String? _nickname;
  String? _email;
  String? _phone;
  String? _phoneIsoCode;
  String? _birthdate;
  String? _gender;
  int? _countryId;
  int? _governorateId;
  String? _address;
  String? _bio;
  CancelToken? _cancelToken;

  /// Set the company name
  UpdateCompanyProfileParametersBuilder name(String name) {
    _name = name;
    return this;
  }

  /// Set the company nickname
  UpdateCompanyProfileParametersBuilder nickname(String nickname) {
    _nickname = nickname;
    return this;
  }

  /// Set the email
  UpdateCompanyProfileParametersBuilder email(String email) {
    _email = email;
    return this;
  }

  /// Set the phone number
  UpdateCompanyProfileParametersBuilder phone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the phone ISO code
  UpdateCompanyProfileParametersBuilder phoneIsoCode(String phoneIsoCode) {
    _phoneIsoCode = phoneIsoCode;
    return this;
  }

  /// Set the birthdate
  UpdateCompanyProfileParametersBuilder birthdate(String birthdate) {
    _birthdate = birthdate;
    return this;
  }

  /// Set the gender
  UpdateCompanyProfileParametersBuilder gender(String gender) {
    _gender = gender;
    return this;
  }

  /// Set the country ID
  UpdateCompanyProfileParametersBuilder countryId(int countryId) {
    _countryId = countryId;
    return this;
  }

  /// Set the governorate ID
  UpdateCompanyProfileParametersBuilder governorateId(int governorateId) {
    _governorateId = governorateId;
    return this;
  }

  /// Set the address
  UpdateCompanyProfileParametersBuilder address(String address) {
    _address = address;
    return this;
  }

  /// Set the bio
  UpdateCompanyProfileParametersBuilder bio(String bio) {
    _bio = bio;
    return this;
  }

  /// Set the cancel token
  UpdateCompanyProfileParametersBuilder cancelToken(CancelToken cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ParametersBuilder<UpdateCompanyProfileParameters> withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  UpdateCompanyProfileParameters build() {
    return UpdateCompanyProfileParameters(
      name: _name,
      nickname: _nickname,
      email: _email,
      phone: _phone,
      phoneIsoCode: _phoneIsoCode,
      birthdate: _birthdate,
      gender: _gender,
      countryId: _countryId,
      governorateId: _governorateId,
      address: _address,
      bio: _bio,
      cancelToken: _cancelToken,
    );
  }
}
