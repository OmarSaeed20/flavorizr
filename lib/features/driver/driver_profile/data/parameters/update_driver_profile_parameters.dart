import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for updating driver profile.
@immutable
class UpdateDriverProfileParameters extends Parameters {
  final String? _firstName;
  final String? _lastName;
  final String? _email;
  final String? _phone;
  final String? _profileImage;
  final String? _bio;
  final String? _address;
  final String? _city;
  final String? _country;
  final DateTime? _dateOfBirth;
  final String? _gender;
  final CancelToken? _cancelToken;

  const UpdateDriverProfileParameters._({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? profileImage,
    String? bio,
    String? address,
    String? city,
    String? country,
    DateTime? dateOfBirth,
    String? gender,
    CancelToken? cancelToken,
  })  : _firstName = firstName,
        _lastName = lastName,
        _email = email,
        _phone = phone,
        _profileImage = profileImage,
        _bio = bio,
        _address = address,
        _city = city,
        _country = country,
        _dateOfBirth = dateOfBirth,
        _gender = gender,
        _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {
      if (_firstName != null) 'first_name': _firstName,
      if (_lastName != null) 'last_name': _lastName,
      if (_email != null) 'email': _email,
      if (_phone != null) 'phone': _phone,
      if (_profileImage != null) 'profile_image': _profileImage,
      if (_bio != null) 'bio': _bio,
      if (_address != null) 'address': _address,
      if (_city != null) 'city': _city,
      if (_country != null) 'country': _country,
      if (_dateOfBirth != null) 'date_of_birth': _dateOfBirth!.toIso8601String(),
      if (_gender != null) 'gender': _gender,
    };
  }

  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get phone => _phone;
  String? get profileImage => _profileImage;
  String? get bio => _bio;
  String? get address => _address;
  String? get city => _city;
  String? get country => _country;
  DateTime? get dateOfBirth => _dateOfBirth;
  String? get gender => _gender;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static UpdateDriverProfileParametersBuilder builder() =>
      UpdateDriverProfileParametersBuilder();
}

/// Builder for UpdateDriverProfileParameters
class UpdateDriverProfileParametersBuilder
    extends ParametersBuilder<UpdateDriverProfileParameters> {
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phone;
  String? _profileImage;
  String? _bio;
  String? _address;
  String? _city;
  String? _country;
  DateTime? _dateOfBirth;
  String? _gender;
  CancelToken? _cancelToken;

  /// Set the first name
  UpdateDriverProfileParametersBuilder withFirstName(String firstName) {
    _firstName = firstName;
    return this;
  }

  /// Set the last name
  UpdateDriverProfileParametersBuilder withLastName(String lastName) {
    _lastName = lastName;
    return this;
  }

  /// Set the email
  UpdateDriverProfileParametersBuilder withEmail(String email) {
    _email = email;
    return this;
  }

  /// Set the phone
  UpdateDriverProfileParametersBuilder withPhone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the profile image
  UpdateDriverProfileParametersBuilder withProfileImage(String profileImage) {
    _profileImage = profileImage;
    return this;
  }

  /// Set the bio
  UpdateDriverProfileParametersBuilder withBio(String bio) {
    _bio = bio;
    return this;
  }

  /// Set the address
  UpdateDriverProfileParametersBuilder withAddress(String address) {
    _address = address;
    return this;
  }

  /// Set the city
  UpdateDriverProfileParametersBuilder withCity(String city) {
    _city = city;
    return this;
  }

  /// Set the country
  UpdateDriverProfileParametersBuilder withCountry(String country) {
    _country = country;
    return this;
  }

  /// Set the date of birth
  UpdateDriverProfileParametersBuilder withDateOfBirth(DateTime dateOfBirth) {
    _dateOfBirth = dateOfBirth;
    return this;
  }

  /// Set the gender
  UpdateDriverProfileParametersBuilder withGender(String gender) {
    _gender = gender;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  UpdateDriverProfileParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the UpdateDriverProfileParameters
  @override
  UpdateDriverProfileParameters build() {
    return UpdateDriverProfileParameters._(
      firstName: _firstName,
      lastName: _lastName,
      email: _email,
      phone: _phone,
      profileImage: _profileImage,
      bio: _bio,
      address: _address,
      city: _city,
      country: _country,
      dateOfBirth: _dateOfBirth,
      gender: _gender,
      cancelToken: _cancelToken,
    );
  }
}