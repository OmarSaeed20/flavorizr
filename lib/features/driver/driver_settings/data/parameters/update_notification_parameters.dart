import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for updating driver notification preferences.
///
/// Based on the FAST App API documentation for POST /driver/settings/notifications
@immutable
class UpdateNotificationParameters extends Parameters {
  final bool? _notificationsEnabled;
  final bool? _emailNotifications;
  final bool? _smsNotifications;
  final bool? _pushNotifications;
  final CancelToken? _cancelToken;

  const UpdateNotificationParameters._({
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? smsNotifications,
    bool? pushNotifications,
    CancelToken? cancelToken,
  }) : _notificationsEnabled = notificationsEnabled,
       _emailNotifications = emailNotifications,
       _smsNotifications = smsNotifications,
       _pushNotifications = pushNotifications,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {
      if (_notificationsEnabled != null) 'notifications_enabled': _notificationsEnabled,
      if (_emailNotifications != null) 'email_notifications': _emailNotifications,
      if (_smsNotifications != null) 'sms_notifications': _smsNotifications,
      if (_pushNotifications != null) 'push_notifications': _pushNotifications,
    };
  }

  bool? get notificationsEnabled => _notificationsEnabled;
  bool? get emailNotifications => _emailNotifications;
  bool? get smsNotifications => _smsNotifications;
  bool? get pushNotifications => _pushNotifications;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static UpdateNotificationParametersBuilder builder() => UpdateNotificationParametersBuilder();
}

/// Builder for UpdateNotificationParameters
class UpdateNotificationParametersBuilder extends ParametersBuilder<UpdateNotificationParameters> {
  bool? _notificationsEnabled;
  bool? _emailNotifications;
  bool? _smsNotifications;
  bool? _pushNotifications;
  CancelToken? _cancelToken;

  /// Set notifications enabled
  UpdateNotificationParametersBuilder withNotificationsEnabled(bool notificationsEnabled) {
    _notificationsEnabled = notificationsEnabled;
    return this;
  }

  /// Set email notifications
  UpdateNotificationParametersBuilder withEmailNotifications(bool emailNotifications) {
    _emailNotifications = emailNotifications;
    return this;
  }

  /// Set SMS notifications
  UpdateNotificationParametersBuilder withSmsNotifications(bool smsNotifications) {
    _smsNotifications = smsNotifications;
    return this;
  }

  /// Set push notifications
  UpdateNotificationParametersBuilder withPushNotifications(bool pushNotifications) {
    _pushNotifications = pushNotifications;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  UpdateNotificationParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the UpdateNotificationParameters
  @override
  UpdateNotificationParameters build() {
    return UpdateNotificationParameters._(
      notificationsEnabled: _notificationsEnabled,
      emailNotifications: _emailNotifications,
      smsNotifications: _smsNotifications,
      pushNotifications: _pushNotifications,
      cancelToken: _cancelToken,
    );
  }
}
