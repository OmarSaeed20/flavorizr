import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flavorizr/core/logger/app_logger.dart';
import 'package:flavorizr/core/network/interceptors/auth_interceptor.dart';
import 'package:flavorizr/core/network/interceptors/logging_interceptor.dart';
import 'package:flutter/foundation.dart';

/// API Client for making HTTP requests using Dio
class ApiClient {
  /// Factory constructor for DI
  factory ApiClient() => instance;

  ApiClient._internal() {
    _dio = Dio(_baseOptions);
    _setupInterceptors();
  }
  late final Dio _dio;
  static ApiClient? _instance;

  /// Base URL for API - configure based on environment
  static String baseUrl = const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com/v1',
  );

  /// Singleton instance getter
  static ApiClient get instance {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  /// Get the underlying Dio instance
  Dio get dio => _dio;

  /// Base options for all requests
  BaseOptions get _baseOptions => BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: ContentType.json.value,
    },
    validateStatus: (status) => status != null && status < 500,
  );

  /// Setup interceptors
  void _setupInterceptors() {
    _dio.interceptors.addAll([AuthInterceptor(), if (kDebugMode) LoggingInterceptor()]);
  }

  /// Update authorization token
  void setAuthToken(String? token) {
    if (token != null) {
      _dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    } else {
      _dio.options.headers.remove(HttpHeaders.authorizationHeader);
    }
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      AppLogger.e('GET $path failed', e, e.stackTrace);
      rethrow;
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      AppLogger.e('POST $path failed', e, e.stackTrace);
      rethrow;
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      AppLogger.e('PUT $path failed', e, e.stackTrace);
      rethrow;
    }
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      AppLogger.e('PATCH $path failed', e, e.stackTrace);
      rethrow;
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      AppLogger.e('DELETE $path failed', e, e.stackTrace);
      rethrow;
    }
  }

  /// Upload file using multipart form data
  Future<Response<T>> uploadFile<T>(
    String path, {
    required String filePath,
    required String fieldName,
    Map<String, dynamic>? additionalData,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        if (additionalData != null) ...additionalData,
      });

      return await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      AppLogger.e('Upload to $path failed', e, e.stackTrace);
      rethrow;
    }
  }

  /// Download file
  Future<Response> downloadFile(
    String url,
    String savePath, {
    void Function(int, int)? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      AppLogger.e('Download from $url failed', e, e.stackTrace);
      rethrow;
    }
  }

  /// Cancel all pending requests
  void cancelAllRequests([CancelToken? cancelToken]) {
    cancelToken?.cancel('Cancelled by user');
  }

  /// Clear all interceptors
  void clearInterceptors() {
    _dio.interceptors.clear();
  }

  /// Reset client
  static void reset() {
    _instance = null;
  }
}
