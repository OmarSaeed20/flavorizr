// lib/core/shared/usecases/base_usecase.dart
/// Base use case for all use cases in the application.
///
/// This file provides a base class for all use cases following the
/// Clean Architecture pattern. Use cases encapsulate business logic
/// and are responsible for coordinating between repositories.
library;

import 'package:dartz/dartz.dart';
import 'package:fast_golden_taxi/core/error/failures.dart';

/// Base class for all use cases.
///
/// Use cases are single-purpose classes that contain business logic.
/// They take input parameters of T [Params] and return a result
/// of T [T] wrapped in an Either<Failure, T>.
///
/// Example:
/// ```dart
/// class LoginUseCase extends BaseUseCase<User, LoginParams> {
///   final AuthRepository _repository;
///
///   LoginUseCase(this._repository);
///
///   @override
///   Future<Either<Failure, User>> call(LoginParams params) async {
///     return await _repository.login(params);
///   }
/// }
/// ```
abstract class BaseUseCase<T, Params> {
  const BaseUseCase();

  /// Executes the use case with the given parameters.
  ///
  /// Returns [Right] with the result on success.
  /// Returns [Left] with a [Failure] on error.
  Future<Either<Failure, T>> call(Params params);
}

/// Base class for use cases that don't require parameters.
///
/// Use this when a use case doesn't need any input parameters.
/// The [NoParams] class can be used as a placeholder.
abstract class NoParamsUseCase<T> {
  const NoParamsUseCase();

  /// Executes the use case without parameters.
  ///
  /// Returns [Right] with the result on success.
  /// Returns [Left] with a [Failure] on error.
  Future<Either<Failure, T>> call();
}

/// Base class for synchronous use cases.
///
/// Use this for use cases that execute synchronously and don't
/// involve async operations like network calls or database queries.
abstract class SyncUseCase<T, Params> {
  const SyncUseCase();

  /// Executes the use case synchronously with the given parameters.
  ///
  /// Returns [Right] with the result on success.
  /// Returns [Left] with a [Failure] on error.
  Either<Failure, T> call(Params params);
}

/// Base class for synchronous use cases without parameters.
abstract class SyncNoParamsUseCase<T> {
  const SyncNoParamsUseCase();

  /// Executes the use case synchronously without parameters.
  ///
  /// Returns [Right] with the result on success.
  /// Returns [Left] with a [Failure] on error.
  Either<Failure, T> call();
}

/// Base class for stream-based use cases.
///
/// Use this for use cases that return a stream of data, such as
/// real-time updates from a database or WebSocket.
abstract class StreamUseCase<T, Params> {
  const StreamUseCase();

  /// Executes the use case and returns a stream of results.
  ///
  /// The stream emits [Right] with results on success.
  /// The stream emits [Left] with failures on error.
  Stream<Either<Failure, T>> call(Params params);
}

/// Placeholder class for use cases that don't require parameters.
///
/// Use this class when a use case extends [BaseUseCase] but doesn't
/// need any input parameters.
///
/// Example:
/// ```dart
/// class GetCurrentUserUseCase extends NoParamsUseCase<User> {
///   final UserRepository _repository;
///
///   GetCurrentUserUseCase(this._repository);
///
///   @override
///   Future<Either<Failure, User>> call() async {
///     return await _repository.getCurrentUser();
///   }
/// }
/// ```
class NoParams {
  /// Creates a NoParams instance.
  const NoParams();
}

/// Base class for use cases that can be cancelled.
///
/// Use this for long-running operations that might need to be
/// cancelled before completion.
abstract class CancellableUseCase<T, Params> {
  const CancellableUseCase();

  /// Executes the use case with the given parameters.
  ///
  /// Returns [Right] with the result on success.
  /// Returns [Left] with a [Failure] on error.
  Future<Either<Failure, T>> call(Params params);

  /// Cancels the use case execution.
  ///
  /// This should be called when the use case is no longer needed
  /// to free up resources and prevent unnecessary work.
  void cancel();
}

/// Base class for paginated use cases.
///
/// Use this for use cases that return data in pages/chunks.
abstract class PaginatedUseCase<T, Params> {
  const PaginatedUseCase();

  /// Executes the use case with the given parameters.
  ///
  /// Returns [Right] with a list of results on success.
  /// Returns [Left] with a [Failure] on error.
  Future<Either<Failure, List<T>>> call(Params params);

  /// Loads the next page of results.
  ///
  /// Returns [Right] with the next page of results on success.
  /// Returns [Left] with a [Failure] on error.
  Future<Either<Failure, List<T>>> loadNext(Params params);

  /// Checks if there are more pages available.
  ///
  /// Returns true if there are more pages to load.
  bool hasMore(Params params);
}

/// Base class for use cases with caching.
///
/// Use this for use cases that should cache results to improve
/// performance and reduce network calls.
abstract class CachedUseCase<T, Params> {
  const CachedUseCase();

  /// Executes the use case with the given parameters.
  ///
  /// If [forceRefresh] is true, bypasses the cache and fetches fresh data.
  /// Returns [Right] with the result on success.
  /// Returns [Left] with a [Failure] on error.
  Future<Either<Failure, T>> call(Params params, {bool forceRefresh = false});

  /// Clears the cached result for the given parameters.
  Future<void> clearCache(Params params);

  /// Clears all cached results.
  Future<void> clearAllCache();
}

/// Base class for use cases that support retry logic.
///
/// Use this for use cases that might fail temporarily and should
/// be retried automatically.
abstract class RetryableUseCase<T, Params> {
  const RetryableUseCase();

  /// Executes the use case with the given parameters.
  ///
  /// Returns [Right] with the result on success.
  /// Returns [Left] with a [Failure] on error.
  Future<Either<Failure, T>> call(Params params);

  /// Executes the use case with retry logic.
  ///
  /// [maxRetries] is the maximum number of retry attempts.
  /// [delay] is the delay between retry attempts in milliseconds.
  /// Returns [Right] with the result on success.
  /// Returns [Left] with a [Failure] on error after all retries fail.
  Future<Either<Failure, T>> callWithRetry(
    Params params, {
    int maxRetries = 3,
    int delay = 1000,
  });
}

/// Base class for use cases that need to track progress.
///
/// Use this for long-running operations where progress updates
/// are important for user experience.
abstract class ProgressUseCase<T, Params> {
  const ProgressUseCase();

  /// Executes the use case with the given parameters.
  ///
  /// Returns [Right] with the result on success.
  /// Returns [Left] with a [Failure] on error.
  Future<Either<Failure, T>> call(Params params);

  /// Gets the current progress of the operation.
  ///
  /// Returns a value between 0.0 and 1.0.
  double get progress;

  /// Stream of progress updates.
  ///
  /// Emits values between 0.0 and 1.0 as progress updates.
  Stream<double> get progressStream;
}
