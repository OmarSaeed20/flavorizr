import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/core/logger/app_logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Interceptor that handles authentication tokens
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip auth for public endpoints
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }

    try {
      final token = await _secureStorage.read(key: _accessTokenKey);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      AppLogger.e('Failed to read auth token', e);
    }

    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 - try to refresh token
    if (err.response?.statusCode == 401) {
      try {
        final refreshed = await _refreshToken(err.requestOptions);
        if (refreshed) {
          // Retry the original request
          final response = await _retryRequest(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (e) {
        AppLogger.e('Token refresh failed', e);
      }
    }

    handler.next(err);
  }

  bool _isPublicEndpoint(String path) {
    const publicEndpoints = [
      '/auth/login',
      '/auth/register',
      '/auth/google',
      '/auth/apple',
      '/auth/password/forgot',
      '/auth/magic-link/send',
    ];
    return publicEndpoints.any((endpoint) => path.contains(endpoint));
  }

  Future<bool> _refreshToken(RequestOptions options) async {
    try {
      final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
      if (refreshToken == null) return false;

      final dio = Dio(
        BaseOptions(baseUrl: options.baseUrl, connectTimeout: const Duration(seconds: 10)),
      );

      final response = await dio.post('/auth/token/refresh', data: {'refresh_token': refreshToken});

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];

        await _secureStorage.write(key: _accessTokenKey, value: newAccessToken);
        if (newRefreshToken != null) {
          await _secureStorage.write(key: _refreshTokenKey, value: newRefreshToken);
        }

        AppLogger.d('Token refreshed successfully');
        return true;
      }
    } catch (e) {
      AppLogger.e('Token refresh error', e);
    }
    return false;
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final token = await _secureStorage.read(key: _accessTokenKey);
    final options = Options(
      method: requestOptions.method,
      headers: {...requestOptions.headers, 'Authorization': 'Bearer $token'},
    );

    final dio = Dio(BaseOptions(baseUrl: requestOptions.baseUrl));

    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  /// Save tokens after successful authentication
  static Future<void> saveTokens({required String accessToken, String? refreshToken}) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  /// Clear all tokens (logout)
  static Future<void> clearTokens() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: _accessTokenKey);
    await storage.delete(key: _refreshTokenKey);
  }

  /// Get the current access token
  static Future<String?> getAccessToken() async {
    const storage = FlutterSecureStorage();
    return storage.read(key: _accessTokenKey);
  }
}
