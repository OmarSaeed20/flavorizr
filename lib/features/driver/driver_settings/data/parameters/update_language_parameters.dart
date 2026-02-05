import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for updating driver language preference.
///
/// Based on the FAST App API documentation for POST /driver/settings/language
@immutable
class UpdateLanguageParameters extends Parameters {
  final String _language;
  final CancelToken? _cancelToken;

  const UpdateLanguageParameters._({
    required String language,
    CancelToken? cancelToken,
  }) : _language = language,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {'language': _language};
  }

  String get language => _language;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static UpdateLanguageParametersBuilder builder() =>
      UpdateLanguageParametersBuilder();
}

/// Builder for UpdateLanguageParameters
class UpdateLanguageParametersBuilder
    extends ParametersBuilder<UpdateLanguageParameters> {
  String? _language;
  CancelToken? _cancelToken;

  /// Set the language
  UpdateLanguageParametersBuilder withLanguage(String language) {
    _language = language;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  UpdateLanguageParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the UpdateLanguageParameters
  @override
  UpdateLanguageParameters build() {
    if (_language == null) {
      throw ArgumentError('Language is required');
    }
    return UpdateLanguageParameters._(
      language: _language!,
      cancelToken: _cancelToken,
    );
  }
}
