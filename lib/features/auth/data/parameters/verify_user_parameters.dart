import 'package:dio/dio.dart';
import 'package:flavorizr/features/auth/data/parameters/base_parameters.dart';

/// Verify User API parameters with builder pattern
/// Used for verifying user account with OTP
class VerifyUserParameters extends Parameters {
  final String phone;
  final String code;
  @override
  final CancelToken? cancelToken;

  const VerifyUserParameters({required this.phone, required this.code, this.cancelToken});

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {'phone': phone, 'code': code};

  /// Create a builder for this parameters type
  VerifyUserParametersBuilder builder() => VerifyUserParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VerifyUserParameters &&
        other.phone == phone &&
        other.code == code &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode => phone.hashCode ^ code.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'VerifyUserParameters(phone: $phone, code: $code, cancelToken: $cancelToken)';
}

/// Builder for VerifyUserParameters
class VerifyUserParametersBuilder extends ParametersBuilder<VerifyUserParameters> {
  String? _phone;
  String? _code;
  CancelToken? _cancelToken;

  VerifyUserParametersBuilder();

  /// Set phone number
  VerifyUserParametersBuilder withPhone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set verification code
  VerifyUserParametersBuilder withCode(String code) {
    _code = code;
    return this;
  }

  /// Set cancel token
  @override
  VerifyUserParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build VerifyUserParameters
  @override
  VerifyUserParameters build() {
    if (_phone == null || _phone!.isEmpty) {
      throw ArgumentError('Phone is required');
    }
    if (_code == null || _code!.isEmpty) {
      throw ArgumentError('Verification code is required');
    }
    return VerifyUserParameters(phone: _phone!, code: _code!, cancelToken: _cancelToken);
  }
}
