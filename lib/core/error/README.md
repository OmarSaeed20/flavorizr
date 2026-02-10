# Error Handling Module

The error handling module provides a comprehensive error management system with error types, error boundaries, and centralized error handling for the Fast Golden Taxi application.

## 📁 Directory Structure

```
lib/core/error/
├── error.dart              # Error types and exceptions
├── error_handler.dart      # Centralized error handler
└── error_boundary.dart     # Error boundary widget
```

## 🎯 Key Components

### 1. Error Types (`error.dart`)

Custom error types for different error scenarios.

**Features:**
- Network exceptions
- Authentication errors
- Validation errors
- Business logic errors
- Unknown errors

**Usage:**
```dart
// Throw custom errors
throw NetworkException('Failed to connect to server');
throw AuthException('Invalid credentials');
throw ValidationException('Email is required');

// Catch and handle errors
try {
  await apiClient.getData();
} on NetworkException catch (e) {
  // Handle network error
} on AuthException catch (e) {
  // Handle auth error
} catch (e) {
  // Handle unknown error
}
```

**Error Types:**
```dart
// Base exception
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });
}

// Network exception
class NetworkException extends AppException {
  final int? statusCode;

  NetworkException(
    String message, {
    this.statusCode,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}

// Auth exception
class AuthException extends AppException {
  AuthException(
    String message, {
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}

// Validation exception
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  ValidationException(
    String message, {
    this.fieldErrors,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}

// Business logic exception
class BusinessException extends AppException {
  BusinessException(
    String message, {
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}
```

### 2. ErrorHandler (`error_handler.dart`)

Centralized error handler for managing and reporting errors.

**Features:**
- Error logging
- Error reporting (Sentry, Crashlytics)
- User-friendly error messages
- Error recovery strategies
- Error analytics

**Usage:**
```dart
// Handle error
errorHandler.handleError(error, stackTrace);

// Handle error with custom message
errorHandler.handleError(
  error,
  stackTrace,
  message: 'Failed to load data',
);

// Handle error with recovery action
errorHandler.handleError(
  error,
  stackTrace,
  recoveryAction: () => loadData(),
);
```

**ErrorHandler:**
```dart
class ErrorHandler {
  final AppLogger logger;
  final AnalyticsService analytics;

  ErrorHandler({
    required this.logger,
    required this.analytics,
  });

  void handleError(
    dynamic error,
    StackTrace? stackTrace, {
    String? message,
    VoidCallback? recoveryAction,
    Map<String, dynamic>? context,
  }) {
    // Log error
    _logError(error, stackTrace, message, context);

    // Report to analytics
    _reportError(error, stackTrace, context);

    // Show user-friendly message
    _showErrorMessage(error, message, recoveryAction);
  }

  void _logError(
    dynamic error,
    StackTrace? stackTrace,
    String? message,
    Map<String, dynamic>? context,
  ) {
    logger.error(
      message ?? 'An error occurred',
      error: error,
      stackTrace: stackTrace,
      data: context,
    );
  }

  void _reportError(
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  ) {
    // Report to Sentry
    // Report to Crashlytics
    analytics.logError(error, stackTrace, context);
  }

  void _showErrorMessage(
    dynamic error,
    String? message,
    VoidCallback? recoveryAction,
  ) {
    // Show snackbar or dialog
    final userMessage = _getUserMessage(error, message);
    // Show UI
  }

  String _getUserMessage(dynamic error, String? customMessage) {
    if (error is AppException) {
      return error.message;
    }
    return customMessage ?? 'An unexpected error occurred';
  }
}
```

### 3. ErrorBoundary (`error_boundary.dart`)

Error boundary widget for catching and handling errors in widget tree.

**Features:**
- Catches errors in widget tree
- Displays error UI
- Provides recovery options
- Logs errors automatically

**Usage:**
```dart
ErrorBoundary(
  onError: (error, stackTrace) {
    // Custom error handling
  },
  child: MyWidget(),
);

// With custom error UI
ErrorBoundary(
  errorBuilder: (error, stackTrace) {
    return ErrorScreen(
      error: error,
      onRetry: () {
        // Retry action
      },
    );
  },
  child: MyWidget(),
);
```

**ErrorBoundary:**
```dart
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final void Function(Object error, StackTrace stackTrace)? onError;
  final Widget Function(Object error, StackTrace stackTrace)? errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.onError,
    this.errorBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(_error!, _stackTrace!);
      }
      return _DefaultErrorWidget(
        error: _error!,
        stackTrace: _stackTrace!,
        onRetry: () {
          setState(() {
            _error = null;
            _stackTrace = null;
          });
        },
      );
    }

    return ErrorWidget.builder = (details) {
      setState(() {
        _error = details.exception;
        _stackTrace = details.stack;
      });
      return const SizedBox.shrink();
    };

    return widget.child;
  }
}
```

## 🏗️ Architecture

### Error Handling Flow

```
1. Error occurs
2. Error caught
3. Error logged
4. Error reported
5. User notified
6. Recovery offered
```

### Error Types Hierarchy

```
AppException (base)
├── NetworkException
├── AuthException
├── ValidationException
└── BusinessException
```

## 📝 Best Practices

### 1. Use Custom Error Types

```dart
// Good
throw NetworkException('Failed to connect', statusCode: 500);

// Bad
throw Exception('Failed to connect');
```

### 2. Handle Errors Appropriately

```dart
// Good
try {
  await apiClient.getData();
} on NetworkException catch (e) {
  // Handle network error
  showNetworkError(e.message);
} on AuthException catch (e) {
  // Handle auth error
  navigateToLogin();
} catch (e) {
  // Handle unknown error
  showError('An unexpected error occurred');
}

// Bad
try {
  await apiClient.getData();
} catch (e) {
  print(e);
}
```

### 3. Use Error Boundaries

```dart
// Good
ErrorBoundary(
  child: MyWidget(),
);

// Bad
MyWidget()
```

### 4. Log All Errors

```dart
// Good
errorHandler.handleError(error, stackTrace);

// Bad
// Don't log errors
```

### 5. Provide Recovery Options

```dart
// Good
errorHandler.handleError(
  error,
  stackTrace,
  recoveryAction: () => retry(),
);

// Bad
errorHandler.handleError(error, stackTrace);
```

## 🔧 Usage Examples

### Throwing Custom Errors

```dart
class UserRepository {
  Future<User> getUser(String userId) async {
    try {
      final response = await apiClient.get('/users/$userId');

      if (response.statusCode == 404) {
        throw NetworkException(
          'User not found',
          statusCode: 404,
          code: 'USER_NOT_FOUND',
        );
      }

      if (response.statusCode == 401) {
        throw AuthException(
          'Unauthorized',
          code: 'UNAUTHORIZED',
        );
      }

      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkException(
        'Failed to fetch user',
        statusCode: e.response?.statusCode,
        originalError: e,
      );
    }
  }
}
```

### Handling Errors in Use Cases

```dart
class GetUserUseCase extends BaseUseCase<User, String> {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(String userId) async {
    try {
      final user = await repository.getUser(userId);
      return Right(user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
```

### Using Error Boundary

```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      errorBuilder: (error, stackTrace) {
        return ErrorScreen(
          title: 'Something went wrong',
          message: error.toString(),
          onRetry: () {
            // Retry action
          },
        );
      },
      child: Scaffold(
        body: MyComplexWidget(),
      ),
    );
  }
}
```

### Custom Error Screen

```dart
class ErrorScreen extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorScreen({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

### Error Handling in API Client

```dart
class ApiClient {
  final Dio dio;
  final ErrorHandler errorHandler;

  ApiClient({
    required this.dio,
    required this.errorHandler,
  });

  Future<T> get<T>(String path) async {
    try {
      final response = await dio.get<T>(path);
      return response.data!;
    } on DioException catch (e) {
      final error = _handleDioError(e);
      errorHandler.handleError(error, e.stackTrace);
      rethrow;
    }
  }

  AppException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          'Connection timeout',
          code: 'TIMEOUT',
          originalError: e,
        );
      case DioExceptionType.badResponse:
        return NetworkException(
          e.response?.statusMessage ?? 'Request failed',
          statusCode: e.response?.statusCode,
          originalError: e,
        );
      case DioExceptionType.cancel:
        return NetworkException(
          'Request cancelled',
          code: 'CANCELLED',
          originalError: e,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          'No internet connection',
          code: 'NO_INTERNET',
          originalError: e,
        );
      default:
        return NetworkException(
          'An unknown error occurred',
          originalError: e,
        );
    }
  }
}
```

## 🧪 Testing

### Testing Error Handling

```dart
test('GetUserUseCase should return NetworkFailure on network error', () async {
  final mockRepository = MockUserRepository();
  final useCase = GetUserUseCase(mockRepository);

  when(mockRepository.getUser('1')).thenThrow(
    NetworkException('Failed to connect', statusCode: 500),
  );

  final result = await useCase('1');

  expect(result.isLeft(), true);
  expect(result.fold((l) => l, (r) => null), isA<NetworkFailure>());
});
```

### Testing Error Boundary

```dart
testWidgets('ErrorBoundary should show error UI when error occurs', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ErrorBoundary(
        child: ErrorWidget(),
      ),
    ),
  );

  expect(find.text('Something went wrong'), findsOneWidget);
});
```

## 📚 Additional Resources

- [Flutter Error Handling](https://flutter.dev/docs/testing/errors)
- [Sentry Flutter](https://docs.sentry.io/platforms/flutter/)
- [Firebase Crashlytics](https://firebase.google.com/docs/crashlytics)

## 🤝 Contributing

When adding error handling:

1. Use appropriate error types
2. Log all errors
3. Provide user-friendly messages
4. Offer recovery options
5. Write tests

## 📄 License

This module is part of the Fast Golden Taxi project.