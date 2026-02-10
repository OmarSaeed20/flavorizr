import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for updating driver privacy settings.
///
/// Based on the FAST App API documentation for POST /driver/settings/privacy
@immutable
class UpdatePrivacyParameters extends Parameters {
  final bool? _showPhone;
  final bool? _showLocation;
  final bool? _allowRatings;
  final CancelToken? _cancelToken;

  const UpdatePrivacyParameters._({
    bool? showPhone,
    bool? showLocation,
    bool? allowRatings,
    CancelToken? cancelToken,
  }) : _showPhone = showPhone,
       _showLocation = showLocation,
       _allowRatings = allowRatings,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {
      if (_showPhone != null) 'show_phone': _showPhone,
      if (_showLocation != null) 'show_location': _showLocation,
      if (_allowRatings != null) 'allow_ratings': _allowRatings,
    };
  }

  bool? get showPhone => _showPhone;
  bool? get showLocation => _showLocation;
  bool? get allowRatings => _allowRatings;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static UpdatePrivacyParametersBuilder builder() =>
      UpdatePrivacyParametersBuilder();
}

/// Builder for UpdatePrivacyParameters
class UpdatePrivacyParametersBuilder
    extends ParametersBuilder<UpdatePrivacyParameters> {
  bool? _showPhone;
  bool? _showLocation;
  bool? _allowRatings;
  CancelToken? _cancelToken;

  /// Set show phone
  UpdatePrivacyParametersBuilder withShowPhone(bool showPhone) {
    _showPhone = showPhone;
    return this;
  }

  /// Set show location
  UpdatePrivacyParametersBuilder withShowLocation(bool showLocation) {
    _showLocation = showLocation;
    return this;
  }

  /// Set allow ratings
  UpdatePrivacyParametersBuilder withAllowRatings(bool allowRatings) {
    _allowRatings = allowRatings;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  UpdatePrivacyParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the UpdatePrivacyParameters
  @override
  UpdatePrivacyParameters build() {
    return UpdatePrivacyParameters._(
      showPhone: _showPhone,
      showLocation: _showLocation,
      allowRatings: _allowRatings,
      cancelToken: _cancelToken,
    );
  }
}
