import 'package:dio/dio.dart';

/// Base abstraction for all API parameters
/// Provides common interface for parameter classes
abstract class Parameters {
  const Parameters();

  /// Convert parameters to JSON for API request
  Map<String, dynamic> toJson();

  Map<String, dynamic> toQueryParameters() {
    return {};
  }

  /// Optional cancel token for request cancellation
  CancelToken? get cancelToken;
}

/// Base abstraction for all parameter builders
/// Provides generic builder pattern implementation
abstract class ParametersBuilder<T extends Parameters> {
  /// Build the parameters object
  T build();

  /// Set cancel token for request cancellation
  ParametersBuilder<T> withCancelToken(CancelToken? cancelToken);
}
