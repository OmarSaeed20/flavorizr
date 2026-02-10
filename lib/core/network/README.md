# Network Layer

The network layer provides a robust, type-safe, and maintainable infrastructure for all HTTP and WebSocket communications in the Fast Golden Taxi application.

## 📁 Directory Structure

```
lib/core/network/
├── api/                    # API-specific models, repositories, services
│   ├── endpoints/         # API endpoint path constants
│   ├── models/            # Data models with JSON serialization
│   ├── parameters/        # Typed request parameter classes
│   ├── repositories/      # Repository implementations
│   └── services/          # Service layer
├── api_client.dart        # Main API client (Dio wrapper)
├── api_endpoints.dart     # API endpoint definitions
├── api_response.dart      # API response models
├── base/                  # Base classes for data sources and repositories
│   ├── datasource/       # Base data source mixins
│   └── repo/             # Base repository class
├── exception/             # Network exception types
│   ├── network_exceptions.dart      # Base exception classes and factory
│   ├── api_error.dart               # API error factory for business logic
│   └── network_exception_example.dart # Usage examples
├── interceptors/          # HTTP interceptors
│   ├── analytics_interceptor.dart
│   ├── auth_interceptor.dart
│   ├── logging_interceptor.dart
│   ├── performance_interceptor.dart
│   └── retry_interceptor.dart
├── network_info.dart      # Network connectivity checker
├── results/               # Result types (ApiResult)
│   ├── dio_reslut.dart
│   └── dio_reslut.freezed.dart
└── websocket/             # WebSocket client and manager
    ├── websocket.dart
    ├── websocket_client.dart
    ├── websocket_event_handler.dart
    └── websocket_manager.dart
```

## 🎯 Key Components

### 1. API Client (`api_client.dart`)

Singleton HTTP client wrapping Dio with pre-configured interceptors.

**Features:**
- Singleton pattern for consistent configuration
- Automatic auth token attachment
- Request/response logging
- Error handling and logging
- File upload/download support
- Request cancellation

**Usage:**
```dart
// Get singleton instance
final apiClient = ApiClient.instance;

// GET request
final response = await apiClient.get<User>('/users/123');

// POST request
final response = await apiClient.post<User>(
  '/users',
  data: {'name': 'John', 'email': 'john@example.com'},
);

// PUT request
final response = await apiClient.put<User>(
  '/users/123',
  data: {'name': 'John Doe'},
);

// DELETE request
final response = await apiClient.delete<void>('/users/123');

// Upload file
final response = await apiClient.uploadFile(
  '/upload',
  filePath: '/path/to/file.jpg',
  fieldName: 'file',
  onSendProgress: (sent, total) {
    print('Progress: ${(sent / total * 100).toStringAsFixed(0)}%');
  },
);

// Download file
final response = await apiClient.downloadFile(
  'https://example.com/file.pdf',
  '/path/to/save.pdf',
  onReceiveProgress: (received, total) {
    print('Progress: ${(received / total * 100).toStringAsFixed(0)}%');
  },
);
```

### 2. Exception Handling (`exception/`)

The network exception handling system provides a robust, scalable, and maintainable approach to handling network errors across all layers of the application.

#### NetworkException Hierarchy

The base `NetworkException` class and its concrete implementations represent network-level errors:

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

#### NetworkExceptionFactory

Provides factory methods for:
- Mapping various exception types to network exceptions
- Guarding async operations with automatic error handling
- Converting DioExceptions and other low-level exceptions

#### ApiError

A utility class that provides factory methods for creating network exceptions in business logic layers without importing specific exception classes.

**Usage:**
```dart
// In business logic
if (email.isEmpty) {
  return ApiResult.exception(
    ApiError.validation(
      message: 'Email is required',
      errors: {'email': ['Email field cannot be empty']},
    ),
  );
}

// Guarded operations
final result = await NetworkExceptionFactory.guard(() async {
  return await apiService.fetchData();
}, context: 'Fetch User Data');
```

### 2. Base Data Source (`base/datasource/`)

Mixins providing common functionality for remote and local data sources.

#### BaseRemoteDataSource

Mixin for remote data sources using Dio.

**Features:**
- Generic GET/POST/PUT/PATCH/DELETE methods
- Automatic error handling and mapping
- Request/response logging
- Progress callbacks for uploads/downloads
- Custom decoder support

**Usage:**
```dart
class UserRemoteDataSource with BaseRemoteDataSource {
  @override
  Dio get dio => ApiClient.instance.dio;

  @override
  String get baseUrl => AppConfig.instance.apiBaseUrl;

  Future<ApiResult<User>> getUser(String id) {
    return get<User>(
      path: '/users/$id',
      decoder: (data) => User.fromJson(data),
    );
  }

  Future<ApiResult<User>> createUser(CreateUserParams params) {
    return post<User>(
      path: '/users',
      data: params.toJson(),
      decoder: (data) => User.fromJson(data),
    );
  }

  Future<ApiResult<User>> updateUser(String id, UpdateUserParams params) {
    return put<User>(
      path: '/users/$id',
      data: params.toJson(),
      decoder: (data) => User.fromJson(data),
    );
  }

  Future<ApiResult<void>> deleteUser(String id) {
    return delete<void>(path: '/users/$id');
  }
}
```

#### BaseLocalDataSource

Mixin for local data sources using storage.

**Features:**
- Generic get/save/delete/clear methods
- Automatic error handling
- Type-safe operations

**Usage:**
```dart
class UserLocalDataSource with BaseLocalDataSource {
  final SharedPreferences _prefs;

  Future<ApiResult<User>> getUser(String key) {
    return getLocalData<User>(
      key: key,
      fetcher: () async {
        final json = _prefs.getString(key);
        if (json == null) return null;
        return User.fromJson(jsonDecode(json));
      },
    );
  }

  Future<ApiResult<User>> saveUser(String key, User user) {
    return saveLocalData<User>(
      key: key,
      data: user,
      saver: (data) async {
        await _prefs.setString(key, jsonEncode(data.toJson()));
      },
    );
  }

  Future<ApiResult<void>> deleteUser(String key) {
    return deleteLocalData(
      key: key,
      deleter: () async {
        await _prefs.remove(key);
      },
    );
  }
}
```

### 3. Base Repository (`base/repo/`)

Base class for repositories combining remote and local data sources.

**Features:**
- Connectivity checking
- Cache strategies (cache-first, network-first, etc.)
- Automatic error handling
- Request retry logic

**Cache Strategies:**
- `cacheFirst` - Try cache first, fallback to network
- `networkFirst` - Try network first, fallback to cache
- `cacheOnly` - Only use cache
- `networkOnly` - Only use network

**Usage:**
```dart
class UserRepository extends BaseRepository {
  final UserRemoteDataSource _remote;
  final UserLocalDataSource _local;

  @override
  NetworkInfo get networkInfo => NetworkInfo.instance;

  Future<ApiResult<User>> getUser(String id) async {
    // Try cache first, then network
    return fetchWithCache(
      cacheKey: 'user_$id',
      remoteFetcher: () => _remote.getUser(id),
      localFetcher: () => _local.getUser('user_$id'),
      cacheSaver: (user) => _local.saveUser('user_$id', user),
      strategy: CacheStrategy.cacheFirst,
      maxCacheAge: const Duration(hours: 1),
    );
  }

  Future<ApiResult<User>> refreshUser(String id) async {
    // Force network request
    return executeRemoteRequest(
      request: () => _remote.getUser(id),
    );
  }
}
```

### 4. Network Exceptions (`exception/`)

Typed network exceptions for better error handling.

**Exception Types:**
- `NoInternetException` - No internet connection
- `TimeoutException` - Request timeout
- `ServerException` - Server error (5xx)
- `BadRequestException` - Bad request (400)
- `UnauthorizedException` - Unauthorized (401)
- `ForbiddenException` - Forbidden (403)
- `NotFoundException` - Not found (404)
- `ConflictException` - Conflict (409)
- `ValidationException` - Validation failed (422)
- `RateLimitException` - Rate limit exceeded (429)
- `RequestCancelledException` - Request cancelled
- `UnknownNetworkException` - Unknown error

**Usage:**
```dart
try {
  final result = await repository.getUser(id);
  result.when(
    success: (user) => _displayUser(user),
    exception: (error) {
      switch (error) {
        case NoInternetException():
          _showNoInternetDialog();
        case UnauthorizedException():
          _navigateToLogin();
        case ValidationException():
          _showValidationErrors(error.errors);
        default:
          _showError(error.message);
      }
    },
  );
} catch (e) {
  _showError('Unexpected error: $e');
}
```

### 5. Interceptors (`interceptors/`)

HTTP interceptors for cross-cutting concerns.

#### AuthInterceptor

Attaches auth tokens and handles token refresh.

**Features:**
- Automatic Bearer token attachment
- Token refresh on 401 errors
- Public endpoint detection
- Secure token storage

**Usage:**
```dart
// Automatically configured in ApiClient
// No manual setup required
```

#### LoggingInterceptor

Logs all HTTP requests and responses.

**Features:**
- Request/response logging
- Header sanitization (sensitive data redacted)
- Body truncation for large payloads
- Error logging with stack traces

**Usage:**
```dart
// Automatically configured in ApiClient for debug mode
// No manual setup required
```

#### RetryInterceptor

Retries failed requests with exponential backoff.

**Features:**
- Configurable retry count
- Exponential backoff with jitter
- Retryable status codes (502, 503, 504, 408, 429)
- Timeout retry

**Usage:**
```dart
// Configure retry behavior
final interceptor = RetryInterceptor(
  maxRetries: 3,
  baseDelay: const Duration(milliseconds: 1000),
  retryableStatusCodes: [502, 503, 504, 408, 429],
);

// Add to Dio
dio.interceptors.add(interceptor);
```

#### AnalyticsInterceptor

Tracks API calls for analytics.

**Features:**
- Request start tracking
- Success/error tracking
- Response time measurement
- Custom event tracking

**Usage:**
```dart
// Automatically configured in ApiClient
// Integrates with your analytics service
```

#### PerformanceInterceptor

Measures API response times.

**Features:**
- Request duration tracking
- Success/failure tracking
- Performance metrics logging

**Usage:**
```dart
// Automatically configured in ApiClient
// Logs performance metrics in debug mode
```

### 6. ApiResult (`results/`)

Result type for handling API responses with explicit error handling.

**Features:**
- Type-safe success/error states
- Pattern matching with `when`, `maybeWhen`, `map`
- Async operations support
- Isolate computation support

**Usage:**
```dart
// Create result
final result = ApiResult.success(user);
final error = ApiResult.exception(NetworkException(...));

// Pattern matching
result.when(
  success: (data, info) => print('Success: $data'),
  exception: (error) => print('Error: $error'),
);

// Maybe when (with default)
result.maybeWhen(
  success: (data) => print('Success: $data'),
  orElse: () => print('Not success'),
);

// Map
final mapped = result.map(
  success: (data) => data.name,
  exception: (error) => 'Error',
);

// Check state
if (result.isSuccess) {
  print('Data: ${result.data}');
}

if (result.isError) {
  print('Error: ${result.error}');
}
```

### 7. WebSocket (`websocket/`)

WebSocket client for real-time communication.

**Features:**
- Auto-reconnection with exponential backoff
- Event-based message handling
- Connection state management
- Ping/pong for keep-alive
- Message queuing while disconnected

**Usage:**
```dart
// Create WebSocket client
final client = WebSocketClient(
  config: WebSocketConfig(
    url: 'wss://api.example.com/ws',
    initialReconnectDelay: 1000,
    maxReconnectDelay: 30000,
    maxReconnectAttempts: 10,
  ),
);

// Connect
await client.connect();

// Listen to events
client.events.listen((event) {
  switch (event.type) {
    case 'message':
      print('Message: ${event.data}');
      break;
    case 'typing':
      print('User typing: ${event.data['userId']}');
      break;
  }
});

// Send message
client.send({
  'type': 'message',
  'data': {'text': 'Hello'},
});

// Disconnect
await client.disconnect();
```

### 8. Network Info (`network_info.dart`)

Network connectivity checker.

**Features:**
- Real-time connectivity status
- Stream of connectivity changes
- Platform-specific detection

**Usage:**
```dart
// Check connectivity
final isConnected = await NetworkInfo.instance.isConnected;

// Listen to connectivity changes
NetworkInfo.instance.onConnectivityChanged.listen((results) {
  if (results.contains(ConnectivityResult.none)) {
    // No connection
  } else {
    // Connected
  }
});
```

## 🏗️ Architecture

### Layer Structure

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│    (Controllers, Pages, Widgets)    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│          Domain Layer               │
│    (Use Cases, Entities, Repos)     │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│          Data Layer                 │
│  (Remote Data Sources, Repos)       │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Network Layer               │
│  (API Client, Interceptors, WS)     │
└─────────────────────────────────────┘
```

### Request Flow

```
1. Presentation Layer calls Use Case
2. Use Case calls Repository
3. Repository checks connectivity
4. Repository calls Remote Data Source
5. Remote Data Source uses BaseRemoteDataSource
6. BaseRemoteDataSource uses API Client
7. API Client uses Dio with Interceptors
8. Interceptors process request/response
9. Response flows back through layers
10. Result is returned as ApiResult
```

## 📝 Best Practices

### 1. Always Use ApiResult

```dart
// Good
Future<ApiResult<User>> getUser(String id) async {
  return _remote.getUser(id);
}

// Bad
Future<User> getUser(String id) async {
  final response = await _remote.getUser(id);
  return response.data!; // Can throw
}
```

### 2. Handle All Error Cases

```dart
result.when(
  success: (data) => _handleSuccess(data),
  exception: (error) {
    switch (error) {
      case NoInternetException():
        _showNoInternetError();
      case UnauthorizedException():
        _navigateToLogin();
      case ValidationException():
        _showValidationErrors(error.errors);
      default:
        _showGenericError(error.message);
    }
  },
);
```

### 3. Use Typed Parameters

```dart
// Good
class GetUserParams {
  final String id;
  final bool includeProfile;

  GetUserParams({required this.id, this.includeProfile = false});
}

Future<ApiResult<User>> getUser(GetUserParams params) {
  return get<User>(
    path: '/users/${params.id}',
    queryParameters: {'include_profile': params.includeProfile},
  );
}

// Bad
Future<ApiResult<User>> getUser(String id, {bool includeProfile = false}) {
  return get<User>(
    path: '/users/$id',
    queryParameters: {'include_profile': includeProfile},
  );
}
```

### 4. Implement Caching

```dart
Future<ApiResult<User>> getUser(String id) {
  return fetchWithCache(
    cacheKey: 'user_$id',
    remoteFetcher: () => _remote.getUser(id),
    localFetcher: () => _local.getUser('user_$id'),
    cacheSaver: (user) => _local.saveUser('user_$id', user),
    strategy: CacheStrategy.cacheFirst,
    maxCacheAge: const Duration(hours: 1),
  );
}
```

### 5. Use Proper HTTP Methods

```dart
// GET - Retrieve data
Future<ApiResult<User>> getUser(String id) => get<User>(path: '/users/$id');

// POST - Create resource
Future<ApiResult<User>> createUser(CreateUserParams params) =>
  post<User>(path: '/users', data: params.toJson());

// PUT - Update entire resource
Future<ApiResult<User>> updateUser(String id, UpdateUserParams params) =>
  put<User>(path: '/users/$id', data: params.toJson());

// PATCH - Partial update
Future<ApiResult<User>> patchUser(String id, Map<String, dynamic> data) =>
  patch<User>(path: '/users/$id', data: data);

// DELETE - Remove resource
Future<ApiResult<void>> deleteUser(String id) =>
  delete<void>(path: '/users/$id');
```

## 🧪 Testing

### Unit Tests

```dart
test('UserRemoteDataSource should return user on success', () async {
  final mockDio = MockDio();
  final dataSource = UserRemoteDataSource();

  when(mockDio.get('/users/123')).thenAnswer(
    (_) async => Response(data: {'id': '123', 'name': 'John'}, statusCode: 200),
  );

  final result = await dataSource.getUser('123');

  expect(result.isSuccess, true);
  expect(result.data?.name, 'John');
});
```

### Integration Tests

```dart
test('UserRepository should fetch with cache', () async {
  final repository = UserRepository(
    remote: mockRemote,
    local: mockLocal,
  );

  final result = await repository.getUser('123');

  expect(result.isSuccess, true);
  verify(mockLocal.saveUser('user_123', any)).called(1);
});
```

## 🔧 Configuration

### API Client Configuration

```dart
// Base URL
static final String baseUrl = AppConfig.instance.apiBaseUrl;

// Timeouts
connectTimeout: const Duration(seconds: 30),
receiveTimeout: const Duration(seconds: 30),
sendTimeout: const Duration(seconds: 30),

// Headers
headers: {
  HttpHeaders.contentTypeHeader: ContentType.json.value,
  HttpHeaders.acceptHeader: ContentType.json.value,
},
```

### Interceptor Configuration

```dart
// Add interceptors in order
_dio.interceptors.addAll([
  AuthInterceptor(),
  LoggingInterceptor(),
  RetryInterceptor(),
  AnalyticsInterceptor(),
  PerformanceInterceptor(),
]);
```

## 📚 Additional Resources

- [Dio Documentation](https://pub.dev/packages/dio)
- [WebSocket Channel](https://pub.dev/packages/web_socket_channel)
- [Connectivity Plus](https://pub.dev/packages/connectivity_plus)
- [Freezed](https://pub.dev/packages/freezed)

## 🤝 Contributing

When adding new API endpoints:

1. Add endpoint constant to `api_endpoints.dart`
2. Create model in `api/models/`
3. Create parameter class in `api/parameters/`
4. Implement repository in `api/repositories/`
5. Add service layer if needed
6. Write tests
7. Update documentation

## 📄 License

This module is part of the Fast Golden Taxi project.