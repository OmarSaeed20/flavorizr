/* // lib/core/network/example/network_usage_example.dart
import 'package:fast_golden_taxi/core/network/exception/api_error.dart';
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/core/network/service/network_service_example.dart';

/// Example demonstrating how to use the network exception handling system.
///
/// This example shows:
/// - How to handle different types of network exceptions
/// - How to convert network exceptions to domain failures
/// - How to use the ApiError factory for business logic errors
/// - How to properly structure error handling in a repository
class NetworkUsageExample {
  final NetworkServiceExample _networkService = NetworkServiceExample();

  /// Example of fetching user data with proper error handling
  Future<ApiResult<User>> fetchUser(String userId) async {
    return _networkService.fetchData<User>('/users/$userId');
  }

  /// Example of creating a user with validation
  Future<ApiResult<User>> createUser(CreateUserRequest request) async {
    // Validate request locally first
    if (request.email.isEmpty || request.password.length < 8) {
      return ApiResult.exception(
        ApiError.validation(
          message: 'Invalid input data',
          errors: {
            if (request.email.isEmpty) 'email': ['Email is required'],
            if (request.password.length < 8) 'password': ['Password must be at least 8 characters'],
          },
        ),
      );
    }

    // Make network request
    return _networkService.postData<User>('/users', request.toJson());
  }

  /// Example of handling different error types in UI
  void handleUserResult(ApiResult<User> result) {
    result.when(
      success: (user, _) {
        // Handle successful user fetch
        print('User fetched successfully: ${user.name}');
      },
      exception: (error) {
        // Handle different error types
        _handleNetworkError(error);
      },
    );
  }

  /// Handle different network error types with appropriate UI responses
  void _handleNetworkError(NetworkException error) {
    // Convert to failure for domain logic if needed
    final failure = error.toFailure();

    switch (error) {
      case NoInternetException():
        // Show no internet message
        print('No internet connection. Please check your network.');
        break;

      case TimeoutException():
        // Show timeout message
        print('Request timed out. Please try again.');
        break;

      case UnauthorizedException():
        // Redirect to login
        print('Session expired. Please login again.');
        break;

      case ValidationException(:final errors):
        // Show validation errors
        if (errors != null) {
          errors.forEach((field, fieldErrors) {
            print('$field: ${fieldErrors.join(', ')}');
          });
        }
        break;

      case ServerException():
        // Show generic server error
        print('Server error. Please try again later.');
        break;

      case NotFoundException():
        // Show not found message
        print('User not found.');
        break;

      default:
        // Handle other errors
        print('An unexpected error occurred: ${error.message}');
    }
  }

  /// Example of guarded operation with custom error handling
  Future<ApiResult<bool>> updateUserProfile(String userId, ProfileUpdateRequest request) async {
    return NetworkExceptionFactory.guard<bool>(
      () async {
        final response = await _networkService.putData<bool>(
          '/users/$userId/profile',
          request.toJson(),
        );
        return response.when(success: (data, _) => data, exception: (error) => throw error);
      },
      context: 'Update User Profile',
      onError: (failure) {
        // Custom error handling logic
        print('Failed to update profile: ${failure.message}');
      },
    ).then(
      (value) => value != null
          ? ApiResult.success(value)
          : const ApiResult.exception(UnknownNetworkException(message: 'Failed to update profile')),
    );
  }
}

/// Example data models for the network usage example
class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}

class CreateUserRequest {
  final String name;
  final String email;
  final String password;

  CreateUserRequest({required this.name, required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'password': password};
  }
}

class ProfileUpdateRequest {
  final String displayName;
  final String bio;

  ProfileUpdateRequest({required this.displayName, required this.bio});

  Map<String, dynamic> toJson() {
    return {'displayName': displayName, 'bio': bio};
  }
}
 */
