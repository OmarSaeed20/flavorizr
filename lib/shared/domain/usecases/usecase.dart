// lib/shared/domain/usecases/usecase.dart
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';

/// Type alias for use case result handling.
typedef UseCaseResult<T> = Future<ApiResult<T>>;
typedef UseCaseStreamResult<T> = Stream<ApiResult<T>>;

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
  const UseCase();

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
  const StreamUseCase();

  /// Returns a stream of data.
  UseCaseStreamResult<T> call(Params params);
}
