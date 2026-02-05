import 'package:flavorizr/core/network/api/models/api_user.dart';
import 'package:flavorizr/core/network/api/parameters/auth_parameters.dart';
import 'package:flavorizr/core/network/api_response.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/auth/data/parameters/refresh_token_parameters.dart';

/// Auth Repository Interface
/// Defines all authentication-related operations
abstract class AuthRepository {
  /// Login user with phone and password
  Future<ApiResult<ApiResponse<ApiAuthResponse>>> login(
    LoginParameters parameters,
  );

  /// Register a new user
  Future<ApiResult<ApiResponse<ApiAuthResponse>>> register(
    RegisterParameters parameters,
  );

  /// Logout current user
  Future<ApiResult<ApiResponse<void>>> logout(LogoutParameters parameters);

  /// Refresh authentication token
  Future<ApiResult<ApiResponse<ApiAuthResponse>>> refreshToken(
    RefreshTokenParameters parameters,
  );

  /// Verify user account with code
  Future<ApiResult<ApiResponse<ApiUser>>> verifyUser(
    VerifyUserParameters parameters,
  );

  /// Reset user password
  Future<ApiResult<ApiResponse<void>>> resetPassword(
    ResetPasswordParameters parameters,
  );

  /// Request password reset (forget password)
  Future<ApiResult<ApiResponse<void>>> forgetPassword(
    ForgetPasswordParameters parameters,
  );

  /// Request confirmation code
  Future<ApiResult<ApiResponse<void>>> confirmationCode(
    ConfirmationCodeParameters parameters,
  );
}
