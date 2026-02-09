import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for updating driver availability status.
@immutable
class UpdateAvailabilityStatusParameters extends Parameters {
  final bool _isAvailable;
  final CancelToken? _cancelToken;

  const UpdateAvailabilityStatusParameters._({
    required bool isAvailable,
    CancelToken? cancelToken,
  }) : _isAvailable = isAvailable,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {'is_available': _isAvailable};
  }

  bool get isAvailable => _isAvailable;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static UpdateAvailabilityStatusParametersBuilder builder() =>
      UpdateAvailabilityStatusParametersBuilder();
}

/// Builder for UpdateAvailabilityStatusParameters
class UpdateAvailabilityStatusParametersBuilder
    extends ParametersBuilder<UpdateAvailabilityStatusParameters> {
  bool? _isAvailable;
  CancelToken? _cancelToken;

  /// Set the availability status
  UpdateAvailabilityStatusParametersBuilder withIsAvailable(bool isAvailable) {
    _isAvailable = isAvailable;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  UpdateAvailabilityStatusParametersBuilder withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the UpdateAvailabilityStatusParameters
  @override
  UpdateAvailabilityStatusParameters build() {
    if (_isAvailable == null) {
      throw ArgumentError('Availability status is required');
    }
    return UpdateAvailabilityStatusParameters._(
      isAvailable: _isAvailable!,
      cancelToken: _cancelToken,
    );
  }
}
