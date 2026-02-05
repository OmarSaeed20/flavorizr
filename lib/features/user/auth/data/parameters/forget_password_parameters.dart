import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';

/// Forget Password API parameters with builder pattern
/// Used for requesting password reset code
class ForgetPasswordParameters extends Parameters {
  final String phone;
  @override
  final CancelToken? cancelToken;

  const ForgetPasswordParameters({required this.phone, this.cancelToken});

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {'phone': phone};

  /// Create a builder for this parameters type
  ForgetPasswordParametersBuilder builder() =>
      ForgetPasswordParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ForgetPasswordParameters &&
        other.phone == phone &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode => phone.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'ForgetPasswordParameters(phone: $phone, cancelToken: $cancelToken)';
}

/// Builder for ForgetPasswordParameters
class ForgetPasswordParametersBuilder
    extends ParametersBuilder<ForgetPasswordParameters> {
  String? _phone;
  CancelToken? _cancelToken;

  ForgetPasswordParametersBuilder();

  /// Set phone number
  ForgetPasswordParametersBuilder withPhone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set cancel token
  @override
  ForgetPasswordParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build ForgetPasswordParameters
  @override
  ForgetPasswordParameters build() {
    if (_phone == null || _phone!.isEmpty) {
      throw ArgumentError('Phone is required');
    }
    return ForgetPasswordParameters(phone: _phone!, cancelToken: _cancelToken);
  }
}
