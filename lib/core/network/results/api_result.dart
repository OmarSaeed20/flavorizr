// lib/core/network/results/api_result.dart
/// Result type for API operations.
///
/// This sealed class provides a type-safe way to handle API responses,
/// encapsulating both success and error states.
library;

import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_result.freezed.dart';

/// Result type for API operations.
///
/// This sealed class provides a type-safe way to handle API responses,
/// encapsulating both success and error states.
///
/// Usage:
/// ```dart
/// final result = await apiClient.get<User>('/users/1');
///
/// result.when(
///   success: (data) => print('User: ${data.name}'),
///   exception: (error) => print('Error: ${error.message}'),
/// );
/// ```
@freezed
class ApiResult<T> with _$ApiResult<T> {
  const ApiResult._();

  /// Represents a successful API operation with data.
  const factory ApiResult.success(T data) = Success<T>;

  /// Represents a failed API operation with an exception.
  const factory ApiResult.exception(NetworkException error) = Failure<T>;

  /// Returns true if the result is a success.
  bool get isSuccess => maybeWhen(success: (_) => true, orElse: () => false);

  /// Returns true if the result is a failure.
  bool get isFailure => !isSuccess;

  /// Returns the data if success, or null if failure.
  T? get dataOrNull => maybeWhen(success: (data) => data, orElse: () => null);

  /// Returns the error if failure, or null if success.
  NetworkException? get errorOrNull =>
      maybeWhen(exception: (error) => error, orElse: () => null);

  /// Returns the error if failure (alias for errorOrNull).
  NetworkException? get failure => errorOrNull;

  /// Creates a failure result from an exception.
  // static ApiResult<T> failure<T>(NetworkException error) => ApiResult.exception(error);

  /// Maps the success data to a new type.
  ///
  /// If this is a failure, the failure is propagated unchanged.
  ApiResult<R> map<R>(R Function(T data) mapper) {
    return when(
      success: (data) => ApiResult.success(mapper(data)),
      exception: ApiResult.exception,
    );
  }

  /// Maps the success data asynchronously to a new type.
  ///
  /// If this is a failure, the failure is propagated unchanged.
  Future<ApiResult<R>> mapAsync<R>(Future<R> Function(T data) mapper) async {
    return when(
      success: (data) async {
        try {
          final result = await mapper(data);
          return ApiResult.success(result);
        } catch (e, stack) {
          return ApiResult.exception(
            NetworkExceptionFactory.mapExceptionToFailure(e, stack),
          );
        }
      },
      exception: (error) async => ApiResult.exception(error),
    );
  }

  /// Executes the given function if this is a success.
  ///
  /// Returns this result unchanged.
  ApiResult<T> onSuccess(void Function(T data) action) {
    when(success: action, exception: (_) {});
    return this;
  }

  /// Executes the given function if this is a failure.
  ///
  /// Returns this result unchanged.
  ApiResult<T> onFailure(void Function(NetworkException error) action) {
    when(success: (_) {}, exception: action);
    return this;
  }

  /// Returns the data if success, or throws the error if failure.
  T get dataOrThrow {
    return when(success: (data) => data, exception: (error) => throw error);
  }

  /// Returns the data if success, or the provided default value if failure.
  T dataOrDefault(T defaultValue) {
    return dataOrNull ?? defaultValue;
  }

  /// Returns the data if success, or computes a default value if failure.
  T dataOrElse(T Function() defaultValue) {
    return dataOrNull ?? defaultValue();
  }
}
