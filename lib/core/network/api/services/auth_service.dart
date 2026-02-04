/* import 'package:flavorizr/core/network/api/models/api_user.dart';
import 'package:flavorizr/core/network/api/parameters/auth_parameters.dart';
import 'package:flavorizr/core/network/api/repositories/auth_repository.dart';
import 'package:flavorizr/core/network/api_response.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Auth Service
/// Business logic layer for authentication operations
class AuthService {
  final AuthRepository _repository;
  final FlutterSecureStorage _secureStorage;

  AuthService({required AuthRepository repository, FlutterSecureStorage? secureStorage})
    : _repository = repository,
      _secureStorage = secureStorage ?? const FlutterSecureStorage();

  // Storage keys
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

  /// Login user with phone and password
  /// Returns NetworkResult with ApiAuthResponse on success
  Future<ApiResult<ApiResponse<ApiAuthResponse>>> login({
    required String phone,
    required String password,
    String? firebaseToken,
  }) async {
    final parameters = LoginParameters.builder()
        .withPhone(phone)
        .withPassword(password)
        .withFirebaseToken(firebaseToken)
        .build();

    final result = await _repository.login(parameters);

    result.when(
      success: (response) async {
        if (response.data != null) {
          await _saveAuthData(response.data!);
        }
      },
      error: (_) {},
    );

    return result;
  }

  /// Register a new user
  /// Returns NetworkResult with ApiAuthResponse on success
  Future<ApiResult<ApiResponse<ApiAuthResponse>>> register({
    required String companyType,
    required String name,
    String? nickname,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String country,
    required String governorate,
    required String birthdate,
    required String gender,
  }) async {
    final parameters = RegisterParameters.builder()
        .withCompanyType(companyType)
        .withName(name)
        .withNickname(nickname)
        .withPhone(phone)
        .withPassword(password)
        .withPasswordConfirmation(passwordConfirmation)
        .withCountry(country)
        .withGovernorate(governorate)
        .withBirthdate(birthdate)
        .withGender(gender)
        .build();

    final result = await _repository.register(parameters);

    result.when(
      success: (response) async {
        if (response.data != null) {
          await _saveAuthData(response.data!);
        }
      },
      error: (_) {},
    );

    return result;
  }

  /// Logout current user
  /// Returns NetworkResult with void on success
  Future<ApiResult<ApiResponse<void>>> logout() async {
    final parameters = LogoutParameters.builder().build();

    final result = await _repository.logout(parameters);

    // Clear auth data regardless of API call result
    await _clearAuthData();

    return result;
  }

  /// Refresh authentication token
  /// Returns NetworkResult with ApiAuthResponse on success
  Future<ApiResult<ApiResponse<ApiAuthResponse>>> refreshToken() async {
    final parameters = RefreshTokenParameters.builder().build();

    final result = await _repository.refreshToken(parameters);

    result.when(
      success: (response) async {
        if (response.data != null) {
          await _saveAuthData(response.data!);
        }
      },
      error: (_) {},
    );

    return result;
  }

  /// Verify user account with code
  /// Returns NetworkResult with ApiUser on success
  Future<ApiResult<ApiResponse<ApiUser>>> verifyUser({required String code}) async {
    final parameters = VerifyUserParameters.builder.withCode(code).build();

    return _repository.verifyUser(parameters);
  }

  /// Reset user password
  /// Returns NetworkResult with void on success
  Future<ApiResult<ApiResponse<void>>> resetPassword({
    required String phone,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    final parameters = ResetPasswordParameters.builder
        .withPhone(phone)
        .withCode(code)
        .withPassword(password)
        .withPasswordConfirmation(passwordConfirmation)
        .build();

    return _repository.resetPassword(parameters);
  }

  /// Request password reset (forget password)
  /// Returns NetworkResult with void on success
  Future<ApiResult<ApiResponse<void>>> forgetPassword({required String phone}) async {
    final parameters = ForgetPasswordParameters.builder.withPhone(phone).build();

    return _repository.forgetPassword(parameters);
  }

  /// Request confirmation code
  /// Returns NetworkResult with void on success
  Future<ApiResult<ApiResponse<void>>> confirmationCode({required String phone}) async {
    final parameters = ConfirmationCodeParameters.builder.withPhone(phone).build();

    return _repository.confirmationCode(parameters);
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Get the current auth token
  Future<String?> getToken() async {
    return _secureStorage.read(key: _tokenKey);
  }

  /// Get the current refresh token
  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: _refreshTokenKey);
  }

  /// Get the current user ID
  Future<String?> getUserId() async {
    return _secureStorage.read(key: _userIdKey);
  }

  /// Save authentication data to secure storage
  Future<void> _saveAuthData(ApiAuthResponse authResponse) async {
    await _secureStorage.write(key: _tokenKey, value: authResponse.token);
    if (authResponse.refreshToken != null) {
      await _secureStorage.write(key: _refreshTokenKey, value: authResponse.refreshToken);
    }
    await _secureStorage.write(key: _userIdKey, value: authResponse.user.id.toString());
  }

  /// Clear authentication data from secure storage
  Future<void> _clearAuthData() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _userIdKey);
  }
}
 */