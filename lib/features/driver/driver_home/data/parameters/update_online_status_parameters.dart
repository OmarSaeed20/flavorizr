import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for updating driver online status.
@immutable
class UpdateOnlineStatusParameters extends Parameters {
  final bool _isOnline;
  final CancelToken? _cancelToken;

  const UpdateOnlineStatusParameters._({
    required bool isOnline,
    CancelToken? cancelToken,
  }) : _isOnline = isOnline,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {'is_online': _isOnline};
  }

  bool get isOnline => _isOnline;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static UpdateOnlineStatusParametersBuilder builder() =>
      UpdateOnlineStatusParametersBuilder();
}

/// Builder for UpdateOnlineStatusParameters
class UpdateOnlineStatusParametersBuilder
    extends ParametersBuilder<UpdateOnlineStatusParameters> {
  bool? _isOnline;
  CancelToken? _cancelToken;

  /// Set the online status
  UpdateOnlineStatusParametersBuilder withIsOnline(bool isOnline) {
    _isOnline = isOnline;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  UpdateOnlineStatusParametersBuilder withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the UpdateOnlineStatusParameters
  @override
  UpdateOnlineStatusParameters build() {
    if (_isOnline == null) {
      throw ArgumentError('Online status is required');
    }
    return UpdateOnlineStatusParameters._(
      isOnline: _isOnline!,
      cancelToken: _cancelToken,
    );
  }
}
