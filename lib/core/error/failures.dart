/* // lib/core/error/failures.dart
/// Base class for all failures in the domain layer.
///
/// Failures represent expected error conditions that are part of
/// the business logic. They are used with Either<Failure, Success>
/// pattern for explicit error handling.
///
/// Use failures for:
/// - Network errors
/// - Validation errors
/// - Business rule violations
/// - Permission errors
/// - Not found errors
abstract class Failure {
  const Failure({required this.message, this.code, this.exception, this.stackTrace});

  /// Human-readable error message for display.
  final String message;

  /// Optional error code for debugging and analytics.
  final String? code;

  /// Optional original exception for debugging.
  final Object? exception;

  /// Optional stack trace for debugging.
  final StackTrace? stackTrace;

  @override
  String toString() => 'Failure(message: $message, code: $code)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message && other.code == code;
  }

  @override
  int get hashCode => Object.hash(message, code);

  /// Converts failure to a user-friendly message.
  String get userMessage => message;

  /// Whether this failure should be reported to crash analytics.
  bool get shouldReport => true;

  /// Creates a map representation for logging.
  Map<String, dynamic> toMap() => {
    'type': runtimeType.toString(),
    'message': message,
    'code': code,
    'exception': exception?.toString(),
  };
}

// ==================== Network Failures ====================

/// Failure when no internet connection is available.
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.code = 'NETWORK_ERROR',
    super.exception,
    super.stackTrace,
  });

  @override
  bool get shouldReport => false;
}

/// Failure when server returns an error response.
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error occurred. Please try again later.',
    super.code = 'SERVER_ERROR',
    super.exception,
    super.stackTrace,
    this.statusCode,
  });

  /// HTTP status code if available.
  final int? statusCode;

  @override
  Map<String, dynamic> toMap() => {...super.toMap(), 'statusCode': statusCode};
}

/// Failure when request times out.
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Request timed out. Please try again.',
    super.code = 'TIMEOUT',
    super.exception,
    super.stackTrace,
  });

  @override
  bool get shouldReport => false;
}

/// Failure when connection is cancelled.
class CancelledFailure extends Failure {
  const CancelledFailure({
    super.message = 'Request was cancelled.',
    super.code = 'CANCELLED',
    super.exception,
    super.stackTrace,
  });

  @override
  bool get shouldReport => false;
}

/// Failure for bad request (400).
class BadRequestFailure extends Failure {
  const BadRequestFailure({
    super.message = 'Invalid request. Please check your input.',
    super.code = 'BAD_REQUEST',
    super.exception,
    super.stackTrace,
  });
}

/// Failure for rate limiting (429).
class RateLimitFailure extends Failure {
  const RateLimitFailure({
    super.message = 'Too many requests. Please wait and try again.',
    super.code = 'RATE_LIMIT',
    super.exception,
    super.stackTrace,
    this.retryAfter,
  });

  /// Time to wait before retrying (in seconds).
  final int? retryAfter;

  @override
  bool get shouldReport => false;

  @override
  Map<String, dynamic> toMap() => {...super.toMap(), 'retryAfter': retryAfter};
}

// ==================== Auth Failures ====================

/// Failure when user is not authenticated.
class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure({
    super.message = 'Please sign in to continue.',
    super.code = 'UNAUTHENTICATED',
    super.exception,
    super.stackTrace,
  });

  @override
  bool get shouldReport => false;
}

/// Failure when user doesn't have permission.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = "You don't have permission to perform this action.",
    super.code = 'UNAUTHORIZED',
    super.exception,
    super.stackTrace,
  });

  @override
  bool get shouldReport => false;
}

/// Failure when login credentials are invalid.
class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure({
    super.message = 'Invalid email or password.',
    super.code = 'INVALID_CREDENTIALS',
    super.exception,
    super.stackTrace,
  });

  @override
  bool get shouldReport => false;
}

/// Failure when session has expired.
class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure({
    super.message = 'Your session has expired. Please sign in again.',
    super.code = 'SESSION_EXPIRED',
    super.exception,
    super.stackTrace,
  });

  @override
  bool get shouldReport => false;
}

/// Failure when account is locked or disabled.
class AccountDisabledFailure extends Failure {
  const AccountDisabledFailure({
    super.message = 'Your account has been disabled. Please contact support.',
    super.code = 'ACCOUNT_DISABLED',
    super.exception,
    super.stackTrace,
  });
}

/// Failure when email is not verified.
class EmailNotVerifiedFailure extends Failure {
  const EmailNotVerifiedFailure({
    super.message = 'Please verify your email to continue.',
    super.code = 'EMAIL_NOT_VERIFIED',
    super.exception,
    super.stackTrace,
  });

  @override
  bool get shouldReport => false;
}

// ==================== Validation Failures ====================

/// Failure for input validation errors.
class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Please check your input and try again.',
    super.code = 'VALIDATION_ERROR',
    super.exception,
    super.stackTrace,
    this.fieldErrors,
  });

  /// Map of field names to error messages.
  final Map<String, List<String>>? fieldErrors;

  @override
  bool get shouldReport => false;

  @override
  Map<String, dynamic> toMap() => {...super.toMap(), 'fieldErrors': fieldErrors};

  /// Gets error for a specific field.
  String? getFieldError(String field) => fieldErrors?[field]?.firstOrNull;

  /// Gets all errors for a specific field.
  List<String> getFieldErrors(String field) => fieldErrors?[field] ?? [];

  /// Whether there are any field-specific errors.
  bool get hasFieldErrors => fieldErrors?.isNotEmpty ?? false;
}

// ==================== Data Failures ====================

/// Failure when requested data is not found.
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'The requested resource was not found.',
    super.code = 'NOT_FOUND',
    super.exception,
    super.stackTrace,
    this.resourceType,
    this.resourceId,
  });

  /// The type of resource that was not found.
  final String? resourceType;

  /// The ID of the resource that was not found.
  final String? resourceId;

  @override
  Map<String, dynamic> toMap() => {
    ...super.toMap(),
    'resourceType': resourceType,
    'resourceId': resourceId,
  };
}

/// Failure when there's a conflict (e.g., duplicate entry).
class ConflictFailure extends Failure {
  const ConflictFailure({
    super.message = 'A conflict occurred. The resource already exists.',
    super.code = 'CONFLICT',
    super.exception,
    super.stackTrace,
  });
}

/// Failure for local storage/cache errors.
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to access local storage.',
    super.code = 'CACHE_ERROR',
    super.exception,
    super.stackTrace,
  });
}

/// Failure when data parsing fails.
class ParseFailure extends Failure {
  const ParseFailure({
    super.message = 'Failed to process data.',
    super.code = 'PARSE_ERROR',
    super.exception,
    super.stackTrace,
  });
}

// ==================== Feature Failures ====================

/// Failure when a feature is disabled.
class FeatureDisabledFailure extends Failure {
  const FeatureDisabledFailure({
    super.message = 'This feature is currently unavailable.',
    super.code = 'FEATURE_DISABLED',
    super.exception,
    super.stackTrace,
    this.featureName,
  });

  /// The name of the disabled feature.
  final String? featureName;

  @override
  bool get shouldReport => false;

  @override
  Map<String, dynamic> toMap() => {...super.toMap(), 'featureName': featureName};
}

/// Failure when user needs to upgrade their plan.
class UpgradeRequiredFailure extends Failure {
  const UpgradeRequiredFailure({
    super.message = 'Please upgrade your plan to access this feature.',
    super.code = 'UPGRADE_REQUIRED',
    super.exception,
    super.stackTrace,
    this.requiredPlan,
  });

  /// The minimum required plan.
  final String? requiredPlan;

  @override
  bool get shouldReport => false;

  @override
  Map<String, dynamic> toMap() => {...super.toMap(), 'requiredPlan': requiredPlan};
}

/// Failure when maintenance is in progress.
class MaintenanceFailure extends Failure {
  const MaintenanceFailure({
    super.message = 'Service is under maintenance. Please try again later.',
    super.code = 'MAINTENANCE',
    super.exception,
    super.stackTrace,
    this.expectedEnd,
  });

  /// Expected end time for maintenance.
  final DateTime? expectedEnd;

  @override
  bool get shouldReport => false;

  @override
  Map<String, dynamic> toMap() => {...super.toMap(), 'expectedEnd': expectedEnd?.toIso8601String()};
}

// ==================== Permission Failures ====================

/// Failure when a permission is denied.
class PermissionDeniedFailure extends Failure {
  const PermissionDeniedFailure({
    super.message = 'Permission denied. Please grant the required permission.',
    super.code = 'PERMISSION_DENIED',
    super.exception,
    super.stackTrace,
    this.permission,
  });

  /// The permission that was denied.
  final String? permission;

  @override
  bool get shouldReport => false;

  @override
  Map<String, dynamic> toMap() => {...super.toMap(), 'permission': permission};
}

// ==================== Generic Failures ====================

/// Failure for unexpected errors.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred. Please try again.',
    super.code = 'UNEXPECTED_ERROR',
    super.exception,
    super.stackTrace,
  });
}

/// Failure when operation is not supported.
class UnsupportedFailure extends Failure {
  const UnsupportedFailure({
    super.message = 'This operation is not supported.',
    super.code = 'UNSUPPORTED',
    super.exception,
    super.stackTrace,
  });
}

/// Failure for platform-specific errors.
class PlatformFailure extends Failure {
  const PlatformFailure({
    super.message = 'A platform error occurred.',
    super.code = 'PLATFORM_ERROR',
    super.exception,
    super.stackTrace,
    this.platform,
  });

  /// The platform where the error occurred.
  final String? platform;

  @override
  Map<String, dynamic> toMap() => {...super.toMap(), 'platform': platform};
}
 */
