# Network Exception Handling Architecture

## Overview

This document describes the network exception handling architecture implemented in the Fast Golden Taxi application. The system provides a robust, scalable, and maintainable approach to handling network errors across all layers of the application.

## Architecture Layers

### 1. Network Layer Exceptions
The base `NetworkException` class and its concrete implementations represent network-level errors. These exceptions are thrown by the data layer when network operations fail.

### 2. Domain Layer Failures
The `Failure` class in the domain layer represents business logic errors. Network exceptions are converted to domain failures using the `NetworkExceptionToFailure` extension.

### 3. Application Layer Integration
The `NetworkExceptionFactory` provides utilities for mapping various exception types to our domain-specific network exceptions.

## Exception Hierarchy

```dart
Exception
└── NetworkException (sealed)
    ├── NoInternetException
    ├── TimeoutException
    ├── ServerException
    ├── BadRequestException
    ├── UnauthorizedException
    ├── ForbiddenException
    ├── NotFoundException
    ├── ConflictException
    ├── ValidationException
    ├── RateLimitException
    ├── RequestCancelledException
    └── UnknownNetworkException
```

## Key Components

### NetworkException (Base Class)
A sealed class that serves as the foundation for all network exceptions. It ensures exhaustive handling and provides a consistent interface.

### Concrete Exception Classes
Each specific exception type represents a distinct network error condition:
- `NoInternetException` - Network connectivity issues
- `TimeoutException` - Request timeouts
- `ServerException` - Server-side errors (5xx)
- `BadRequestException` - Client errors (400)
- `UnauthorizedException` - Authentication failures (401)
- `ForbiddenException` - Authorization failures (403)
- `NotFoundException` - Missing resources (404)
- `ConflictException` - Resource conflicts (409)
- `ValidationException` - Data validation errors (422)
- `RateLimitException` - Rate limiting (429)
- `RequestCancelledException` - Cancelled requests
- `UnknownNetworkException` - Unexpected errors

### NetworkExceptionFactory
Provides factory methods for:
- Mapping various exception types to network exceptions
- Guarding async operations with automatic error handling
- Converting DioExceptions and other low-level exceptions

### ApiError
A utility class that provides factory methods for creating network exceptions in business logic layers without importing specific exception classes.

### NetworkExceptionToFailure Extension
Converts network exceptions to domain failures, bridging the gap between network and domain layers.

## Usage Patterns

### 1. Handling Network Calls
```dart
try {
  final result = await apiService.fetchData();
  return Right(result);
} on NetworkException catch (e) {
  return Left(e.toFailure());
}
```

### 2. Using the Guard Method
```dart
final result = await NetworkExceptionFactory.guard(() => apiService.fetchData());
if (result == null) {
  // Handle error
}
```

### 3. Creating API Errors in Business Logic
```dart
if (someCondition) {
  return Left(ApiError.validation(message: 'Invalid input'));
}
```

## Error Flow

1. Network operation fails and throws a low-level exception (DioException, SocketException, etc.)
2. NetworkExceptionFactory maps the exception to a domain-specific NetworkException
3. NetworkException is converted to a domain Failure using toFailure()
4. Failure is propagated through the application layers
5. UI handles the failure appropriately

## Best Practices

1. Always use the sealed class hierarchy for exhaustive error handling
2. Convert network exceptions to domain failures at the boundary between layers
3. Use ApiError factory methods for creating errors in business logic
4. Leverage the guard method for automatic error handling in async operations
5. Maintain consistency in error messages and status codes
6. Log errors appropriately using the ErrorHandler
7. Report critical errors to crash analytics in production

## Extensibility

The architecture is designed to be easily extensible:
- New exception types can be added by extending NetworkException
- Additional mapping logic can be added to NetworkExceptionFactory
- New failure types can be added to the Failure class
- Custom error handling can be implemented using the onError callback in guard methods

## Testing

Each exception type should have corresponding unit tests to ensure:
- Proper instantiation with correct parameters
- Correct conversion to domain failures
- Appropriate error messages and status codes
- Integration with the NetworkExceptionFactory mapping logic