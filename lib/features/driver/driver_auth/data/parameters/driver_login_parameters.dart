import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for driver login.
@immutable
class DriverLoginParameters extends Parameters {
  final String _phone;
  final String _password;
  final String? _firebaseToken;
  final CancelToken? _cancelToken;

  const DriverLoginParameters._({
    required String phone,
    required String password,
    String? firebaseToken,
    CancelToken? cancelToken,
  }) : _phone = phone,
       _password = password,
       _firebaseToken = firebaseToken,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'phone': _phone, 'password': _password};
    if (_firebaseToken != null) {
      json['firebase_token'] = _firebaseToken;
    }
    return json;
  }

  String get phone => _phone;
  String get password => _password;
  String? get firebaseToken => _firebaseToken;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static DriverLoginParametersBuilder builder() => DriverLoginParametersBuilder();
}

/// Builder for DriverLoginParameters
class DriverLoginParametersBuilder extends ParametersBuilder<DriverLoginParameters> {
  String? _phone;
  String? _password;
  String? _firebaseToken;
  CancelToken? _cancelToken;

  /// Set the phone number
  DriverLoginParametersBuilder withPhone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set the password
  DriverLoginParametersBuilder withPassword(String password) {
    _password = password;
    return this;
  }

  /// Set the Firebase token (optional)
  DriverLoginParametersBuilder withFirebaseToken(String firebaseToken) {
    _firebaseToken = firebaseToken;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  DriverLoginParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the DriverLoginParameters
  @override
  DriverLoginParameters build() {
    if (_phone == null) {
      throw ArgumentError('Phone is required');
    }
    if (_password == null) {
      throw ArgumentError('Password is required');
    }
    return DriverLoginParameters._(
      phone: _phone!,
      password: _password!,
      firebaseToken: _firebaseToken,
      cancelToken: _cancelToken,
    );
  }
}
