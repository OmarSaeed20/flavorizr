import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Confirmation Code API parameters with builder pattern
/// Used for resending confirmation code
class ConfirmationCodeParameters extends Parameters {
  final String phone;
  @override
  final CancelToken? cancelToken;

  const ConfirmationCodeParameters({required this.phone, this.cancelToken});

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {'phone': phone};

  /// Create a builder for this parameters type
  ConfirmationCodeParametersBuilder builder() =>
      ConfirmationCodeParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConfirmationCodeParameters &&
        other.phone == phone &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode => phone.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'ConfirmationCodeParameters(phone: $phone, cancelToken: $cancelToken)';
}

/// Builder for ConfirmationCodeParameters
class ConfirmationCodeParametersBuilder
    extends ParametersBuilder<ConfirmationCodeParameters> {
  String? _phone;
  CancelToken? _cancelToken;

  ConfirmationCodeParametersBuilder();

  /// Set phone number
  ConfirmationCodeParametersBuilder withPhone(String phone) {
    _phone = phone;
    return this;
  }

  /// Set cancel token
  @override
  ConfirmationCodeParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build ConfirmationCodeParameters
  @override
  ConfirmationCodeParameters build() {
    if (_phone == null || _phone!.isEmpty) {
      throw ArgumentError('Phone is required');
    }
    return ConfirmationCodeParameters(
      phone: _phone!,
      cancelToken: _cancelToken,
    );
  }
}
