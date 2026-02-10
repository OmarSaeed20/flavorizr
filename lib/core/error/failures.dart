// lib/core/error/failures.dart
/// Domain failures for the application.
///
/// This file defines all possible failure types that can occur
/// in the domain layer. Failures are used with the Either pattern
/// from dartz to represent error states.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Base class for all domain failures.
///
/// Failures represent error conditions in the domain layer.
/// They are used with the Either<Failure, T> pattern to handle
/// errors in a type-safe way.
@freezed
class Failure with _$Failure {
  /// Server failure - indicates a server-side error.
  const factory Failure.server({required String message, int? statusCode}) =
      ServerFailure;

  /// Network failure - indicates a network connectivity issue.
  const factory Failure.network({required String message}) = NetworkFailure;

  /// Validation failure - indicates invalid input data.
  const factory Failure.validation({
    required String message,
    Map<String, String>? fieldErrors,
  }) = ValidationFailure;

  /// Authentication failure - indicates auth-related errors.
  const factory Failure.auth({required String message}) = AuthFailure;

  /// Unauthorized failure - indicates missing or invalid credentials.
  const factory Failure.unauthorized({required String message}) =
      UnauthorizedFailure;

  /// Not found failure - indicates a resource was not found.
  const factory Failure.notFound({required String message}) = NotFoundFailure;

  /// Unknown failure - catch-all for unexpected errors.
  const factory Failure.unknown({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = UnknownFailure;

  /// Cache failure - indicates a cache-related error.
  const factory Failure.cache({required String message}) = CacheFailure;

  /// Timeout failure - indicates a request timed out.
  const factory Failure.timeout({required String message}) = TimeoutFailure;

  /// Permission failure - indicates missing permissions.
  const factory Failure.permission({required String message}) =
      PermissionFailure;

  /// Conflict failure - indicates a resource conflict.
  const factory Failure.conflict({required String message}) = ConflictFailure;

  /// Too many requests failure - indicates rate limiting.
  const factory Failure.tooManyRequests({required String message}) =
      TooManyRequestsFailure;

  /// Maintenance failure - indicates the service is under maintenance.
  const factory Failure.maintenance({required String message}) =
      MaintenanceFailure;

  /// Payment failure - indicates a payment-related error.
  const factory Failure.payment({required String message}) = PaymentFailure;

  /// Location failure - indicates a location-related error.
  const factory Failure.location({required String message}) = LocationFailure;

  /// File upload failure - indicates a file upload error.
  const factory Failure.fileUpload({required String message}) =
      FileUploadFailure;

  /// Verification failure - indicates a verification error.
  const factory Failure.verification({required String message}) =
      VerificationFailure;

  /// Rate limit failure - indicates rate limiting.
  const factory Failure.rateLimit({required String message, int? retryAfter}) =
      RateLimitFailure;

  /// Service unavailable failure - indicates the service is unavailable.
  const factory Failure.serviceUnavailable({required String message}) =
      ServiceUnavailableFailure;

  /// Bad request failure - indicates a bad request.
  const factory Failure.badRequest({
    required String message,
    Map<String, dynamic>? details,
  }) = BadRequestFailure;

  /// Custom failure - for application-specific errors.
  const factory Failure.custom({
    required String code,
    required String message,
    Map<String, dynamic>? data,
  }) = CustomFailure;

  const Failure._();

  /// Get the error message.
  @override
  String get message => when(
    server: (m, _) => m,
    network: (m) => m,
    validation: (m, _) => m,
    auth: (m) => m,
    unauthorized: (m) => m,
    notFound: (m) => m,
    unknown: (m, _, __) => m,
    cache: (m) => m,
    timeout: (m) => m,
    permission: (m) => m,
    conflict: (m) => m,
    tooManyRequests: (m) => m,
    maintenance: (m) => m,
    payment: (m) => m,
    location: (m) => m,
    fileUpload: (m) => m,
    verification: (m) => m,
    rateLimit: (m, _) => m,
    serviceUnavailable: (m) => m,
    badRequest: (m, _) => m,
    custom: (_, m, __) => m,
  );

  /// Check if this is a network-related failure.
  bool get isNetwork => this is NetworkFailure || this is TimeoutFailure;

  /// Check if this is an auth-related failure.
  bool get isAuth => this is AuthFailure || this is UnauthorizedFailure;

  /// Check if this is a validation failure.
  bool get isValidation => this is ValidationFailure;

  /// Check if this is a server error (5xx).
  bool get isServerError => this is ServerFailure;

  /// Check if this is a client error (4xx).
  bool get isClientError =>
      this is BadRequestFailure ||
      this is UnauthorizedFailure ||
      this is NotFoundFailure ||
      this is ConflictFailure ||
      this is TooManyRequestsFailure ||
      this is RateLimitFailure;

  /// Check if this failure is retryable.
  bool get isRetryable =>
      isNetwork ||
      this is TimeoutFailure ||
      this is ServiceUnavailableFailure ||
      this is TooManyRequestsFailure ||
      this is RateLimitFailure;
}
