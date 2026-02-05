import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for updating driver settings.
///
/// Based on the FAST App API documentation for POST /driver/settings/update
@immutable
class UpdateDriverSettingsParameters extends Parameters {
  final bool? _isOnline;
  final bool? _isAvailable;
  final String? _language;
  final CancelToken? _cancelToken;

  const UpdateDriverSettingsParameters._({
    bool? isOnline,
    bool? isAvailable,
    String? language,
    CancelToken? cancelToken,
  }) : _isOnline = isOnline,
       _isAvailable = isAvailable,
       _language = language,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {
      if (_isOnline != null) 'is_online': _isOnline,
      if (_isAvailable != null) 'is_available': _isAvailable,
      if (_language != null) 'language': _language,
    };
  }

  bool? get isOnline => _isOnline;
  bool? get isAvailable => _isAvailable;
  String? get language => _language;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static UpdateDriverSettingsParametersBuilder builder() => UpdateDriverSettingsParametersBuilder();
}

/// Builder for UpdateDriverSettingsParameters
class UpdateDriverSettingsParametersBuilder
    extends ParametersBuilder<UpdateDriverSettingsParameters> {
  bool? _isOnline;
  bool? _isAvailable;
  String? _language;
  CancelToken? _cancelToken;

  /// Set the online status
  UpdateDriverSettingsParametersBuilder withIsOnline(bool isOnline) {
    _isOnline = isOnline;
    return this;
  }

  /// Set the availability status
  UpdateDriverSettingsParametersBuilder withIsAvailable(bool isAvailable) {
    _isAvailable = isAvailable;
    return this;
  }

  /// Set the language
  UpdateDriverSettingsParametersBuilder withLanguage(String language) {
    _language = language;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  UpdateDriverSettingsParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the UpdateDriverSettingsParameters
  @override
  UpdateDriverSettingsParameters build() {
    return UpdateDriverSettingsParameters._(
      isOnline: _isOnline,
      isAvailable: _isAvailable,
      language: _language,
      cancelToken: _cancelToken,
    );
  }
}
