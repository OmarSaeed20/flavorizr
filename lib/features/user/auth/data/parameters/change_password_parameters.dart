import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';

/// Change Password API parameters with builder pattern
/// Used for changing current user's password
class ChangePasswordParameters extends Parameters {
  final String currentPassword;
  final String newPassword;
  @override
  final CancelToken? cancelToken;

  const ChangePasswordParameters({
    required this.currentPassword,
    required this.newPassword,
    this.cancelToken,
  });

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {
    'current_password': currentPassword,
    'new_password': newPassword,
  };

  /// Create a builder for this parameters type
 static ChangePasswordParametersBuilder builder() => ChangePasswordParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChangePasswordParameters &&
        other.currentPassword == currentPassword &&
        other.newPassword == newPassword &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode =>
      currentPassword.hashCode ^ newPassword.hashCode ^ cancelToken.hashCode;

  @override
  String toString() =>
      'ChangePasswordParameters(currentPassword: ****, newPassword: ****, cancelToken: $cancelToken)';
}

/// Builder for ChangePasswordParameters
class ChangePasswordParametersBuilder extends ParametersBuilder<ChangePasswordParameters> {
  String? _currentPassword;
  String? _newPassword;
  CancelToken? _cancelToken;

  ChangePasswordParametersBuilder();

  /// Set current password
  ChangePasswordParametersBuilder withCurrentPassword(String currentPassword) {
    _currentPassword = currentPassword;
    return this;
  }

  /// Set new password
  ChangePasswordParametersBuilder withNewPassword(String newPassword) {
    _newPassword = newPassword;
    return this;
  }

  /// Set cancel token
  @override
  ChangePasswordParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the parameters object
  @override
  ChangePasswordParameters build() {
    return ChangePasswordParameters(
      currentPassword: _currentPassword!,
      newPassword: _newPassword!,
      cancelToken: _cancelToken,
    );
  }
}