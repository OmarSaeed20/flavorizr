// lib/features/trip/data/parameters/base_parameters.dart
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

/// Base class for all parameters.
@immutable
abstract class Parameters {
  const Parameters();

  /// Converts parameters to JSON.
  Map<String, dynamic> toJson();

  /// Cancel token for cancelling requests.
  CancelToken? get cancelToken;

  /// Creates a builder for this parameters class.
  static ParametersBuilder<Parameters> get builder =>
      throw UnimplementedError();
}

/// Base builder class for parameters.
abstract class ParametersBuilder<T extends Parameters> {
  const ParametersBuilder();

  /// Sets the cancel token.
  ParametersBuilder<T> withCancelToken(CancelToken? cancelToken);

  /// Builds the parameters.
  T build();
}
