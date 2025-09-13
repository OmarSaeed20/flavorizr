import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart' show JwtDecoder;
import '/core/network/token_storage.dart';

class JwtInterceptor extends Interceptor {
  JwtInterceptor({
    required Dio dio,
    String refreshEndpoint = '/auth/refresh',
  }) : _dio = dio,
       _refreshEndpoint = refreshEndpoint;
  final Dio _dio;
  final String _refreshEndpoint;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await TokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';

      // Check if token is about to expire
      if (JwtDecoder.isExpired(token)) {
        // Token expired, try to refresh
        try {
          final newToken = await _refreshToken();
          if (newToken != null) {
            options.headers['Authorization'] = 'Bearer $newToken';
          }
        } catch (e) {
          // Refresh failed, continue with expired token
          // or handle according to your auth flow
        }
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      try {
        // Retry the original request with new token
        final token =
            await _refreshToken(); //await TokenStorage.getAccessToken();
        if (token != null) {
          err.requestOptions.headers['Authorization'] = 'Bearer $token';
          final cloneReq = await _dio.request(
            err.requestOptions.path,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
            ),
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
          );
          handler.resolve(cloneReq);
          return;
        }
      } catch (e) {
        // Refresh failed, clear tokens and let the error propagate
        await TokenStorage.clearTokens();
      }
    }
    handler.next(err);
  }

  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null) throw Exception('No refresh token available');
      if (JwtDecoder.isExpired(refreshToken)) {
        throw Exception('Refresh token has expired!');
      }
      final response = await _dio.post(
        _refreshEndpoint,
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'Authorization': null}),
      );

      final newAccessToken = response.data['access_token'] as String?;
      final newRefreshToken = response.data['refresh_token'] as String?;

      await TokenStorage.saveTokens(
        accessToken: newAccessToken ,
        refreshToken: newRefreshToken,
      );
      return newAccessToken;
    } catch (e) {
      return null;
    }
  }
}
