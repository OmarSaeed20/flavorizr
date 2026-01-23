// lib/shared/domain/usecases/usecase.dart
import 'package:flavorizr/core/error/failures.dart';

/// Type alias for use case result handling.
typedef UseCaseResult<T> = Future<({T? data, Failure? failure})>;

/// Base interface for all use cases.
///
/// Use cases represent single business actions and should:
/// - Have a single responsibility
/// - Be named with a verb (e.g., LoginUseCase, CreatePostUseCase)
/// - Return a result tuple for explicit error handling
/// - Be easily testable
///
/// Type parameters:
/// - [T] - The success return type
/// - [Params] - The input parameters type (use [NoParams] if none needed)
abstract class UseCase<T, Params> {
  /// Executes the use case with the given parameters.
  UseCaseResult<T> call(Params params);
}

/// Use this when a use case doesn't require any parameters.
class NoParams {
  const NoParams();
}

/// Base interface for stream-based use cases.
///
/// Use for real-time data like chat messages or notifications.
abstract class StreamUseCase<T, Params> {
  /// Returns a stream of data.
  Stream<({T? data, Failure? failure})> call(Params params);
}

/// Helper extension for working with use case results.
extension UseCaseResultExtension<T> on ({T? data, Failure? failure}) {
  /// Returns true if the result is successful.
  bool get isSuccess => failure == null && data != null;

  /// Returns true if the result is a failure.
  bool get isFailure => failure != null;

  /// Maps the success value to another type.
  ({R? data, Failure? failure}) map<R>(R Function(T data) mapper) {
    if (isSuccess) {
      return (data: mapper(data as T), failure: null);
    }
    return (data: null, failure: failure);
  }

  /// Handles both success and failure cases.
  R fold<R>(R Function(Failure failure) onFailure, R Function(T data) onSuccess) {
    if (isFailure) {
      return onFailure(failure!);
    }
    return onSuccess(data as T);
  }
}

/// Helper class to create results easily.
class Result {
  /// Creates a success result.
  static ({T? data, Failure? failure}) success<T>(T data) {
    return (data: data, failure: null);
  }

  /// Creates a failure result.
  static ({T? data, Failure? failure}) failure<T>(Failure failure) {
    return (data: null, failure: failure);
  }
}
