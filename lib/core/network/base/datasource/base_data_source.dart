import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flavorizr/core/logger/advanced_app_logger.dart';
import 'package:flavorizr/core/network/exception/network_exceptions.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:http_parser/http_parser.dart' as http_parser;

/// Base mixin for remote data sources
/// Provides common functionality for API calls using Dio
mixin BaseRemoteDataSource {
  /// Get the Dio instance for making HTTP requests
  /// This should be implemented by the class using this mixin
  Dio get dio;

  /// Base URL for API requests
  String get baseUrl;

  /// Default timeout duration
  Duration get defaultTimeout => const Duration(seconds: 30);

  /// Perform a GET request
  /// Returns ApiResult with the response data or an error
  Future<ApiResult<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic data)? decoder,
  }) async {
    try {
      final response = await dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      final data = decoder != null ? decoder(response.data) : response.data;
      return ApiResult.success(data as T);
    } on DioException catch (e) {
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e));
    } catch (e, stackTrace) {
      e.logError('GET request failed: $path', stackTrace: stackTrace.toString());
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace));
    }
  }

  /// Perform a POST request
  /// Returns ApiResult with the response data or an error
  Future<ApiResult<T>> post<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic data)? decoder,
  }) async {
    try {
      final response = await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      final decodedData = decoder != null ? decoder(response.data) : response.data;
      return ApiResult.success(decodedData as T);
    } on DioException catch (e) {
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e));
    } catch (e, stackTrace) {
      e.logError('POST request failed: $path', stackTrace: stackTrace.toString());
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace));
    }
  }

  /// Perform a PUT request
  /// Returns ApiResult with the response data or an error
  Future<ApiResult<T>> put<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic data)? decoder,
  }) async {
    try {
      final response = await dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      final decodedData = decoder != null ? decoder(response.data) : response.data;
      return ApiResult.success(decodedData as T);
    } on DioException catch (e) {
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e));
    } catch (e, stackTrace) {
      e.logError('PUT request failed: $path', stackTrace: stackTrace.toString());
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace));
    }
  }

  /// Perform a PATCH request
  /// Returns ApiResult with the response data or an error
  Future<ApiResult<T>> patch<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic data)? decoder,
  }) async {
    try {
      final response = await dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      final decodedData = decoder != null ? decoder(response.data) : response.data;
      return ApiResult.success(decodedData as T);
    } on DioException catch (e) {
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e));
    } catch (e, stackTrace) {
      e.logError('PATCH request failed: $path', stackTrace: stackTrace.toString());
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace));
    }
  }

  /// Perform a DELETE request
  /// Returns ApiResult with the response data or an error
  Future<ApiResult<T>> delete<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? decoder,
  }) async {
    try {
      final response = await dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      final decodedData = decoder != null ? decoder(response.data) : response.data;
      return ApiResult.success(decodedData as T);
    } on DioException catch (e) {
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e));
    } catch (e, stackTrace) {
      e.logError('DELETE request failed: $path', stackTrace: stackTrace.toString());
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace));
    }
  }

  /// Perform a multipart/form-data request (typically for file uploads)
  /// Returns ApiResult with the response data or an error
  Future<ApiResult<T>> upload<T>({
    required String path,
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic data)? decoder,
  }) async {
    try {
      final response = await dio.post<T>(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      final decodedData = decoder != null ? decoder(response.data) : response.data;
      return ApiResult.success(decodedData as T);
    } on DioException catch (e) {
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e));
    } catch (e, stackTrace) {
      e.logError('Upload request failed: $path', stackTrace: stackTrace.toString());
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace));
    }
  }

  /// Download a file from the server
  /// Returns ApiResult with the file path or an error
  Future<ApiResult<String>> download({
    required String urlPath,
    required String savePath,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      await dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return ApiResult.success(savePath);
    } on DioException catch (e) {
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e));
    } catch (e, stackTrace) {
      e.logError('Download failed: $urlPath', stackTrace: stackTrace.toString());
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace));
    }
  }

  /// Perform multiple requests concurrently
  /// Returns ApiResult with a list of responses or an error
  Future<ApiResult<List<T>>> fetchAll<T>({
    required List<Future<ApiResult<T>>> requests,
    bool failOnError = true,
  }) async {
    try {
      final results = await Future.wait(requests);

      if (failOnError) {
        final errors = results.whereType<ApiResultError<T>>().toList();
        if (errors.isNotEmpty) {
          return ApiResult.exception(errors.first.exception);
        }
      }

      final data = results.whereType<ApiResultSuccess<T>>().map((e) => e.data).toList();

      return ApiResult.success(data);
    } catch (e, stackTrace) {
      e.logError('fetchAll failed', stackTrace: stackTrace.toString());
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace));
    }
  }

  /// Retry a request with exponential backoff
  /// Returns ApiResult with the response data or an error
  Future<ApiResult<T>> retry<T>({
    required Future<ApiResult<T>> Function() request,
    int maxAttempts = 3,
    Duration initialDelay = const Duration(seconds: 1),
    double backoffFactor = 2.0,
    bool Function(NetworkException)? shouldRetry,
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (attempt < maxAttempts) {
      attempt++;
      final result = await request();

      if (result.isSuccess) {
        return result;
      }

      final error = result.error;
      if (error == null) {
        return result;
      }

      // Check if we should retry this error
      final shouldRetryError = shouldRetry?.call(error) ?? _defaultShouldRetry(error);

      if (!shouldRetryError || attempt >= maxAttempts) {
        return result;
      }

      // Wait before retrying
      await Future.delayed(delay);
      delay = Duration(milliseconds: (delay.inMilliseconds * backoffFactor).round());
    }

    return const ApiResult.exception(TimeoutException());
  }

  /// Default retry logic - retry on recoverable errors
  bool _defaultShouldRetry(NetworkException error) {
    return error is NoInternetException ||
        error is TimeoutException ||
        error is ServerException ||
        error is RateLimitException;
  }

  /// Create default options for requests
  Options createOptions({
    String? contentType,
    Map<String, dynamic>? headers,
    Duration? timeout,
    ResponseType? responseType,
  }) {
    return Options(
      contentType: contentType ?? Headers.jsonContentType,
      headers: headers,
      sendTimeout: timeout ?? defaultTimeout,
      receiveTimeout: timeout ?? defaultTimeout,
      responseType: responseType ?? ResponseType.json,
    );
  }

  /// Create multipart/form-data for file uploads
  FormData createFormData({required Map<String, dynamic> fields, List<FileInfo>? files}) {
    final formData = FormData();

    // Add text fields
    fields.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    // Add files
    if (files != null) {
      for (final file in files) {
        formData.files.add(
          MapEntry(
            file.field,
            MultipartFile.fromFileSync(
              file.path,
              filename: file.filename,
              contentType: file.contentType != null
                  ? http_parser.MediaType.parse(file.contentType!)
                  : null,
            ),
          ),
        );
      }
    }

    return formData;
  }
}

/// Helper class for file information in multipart requests
class FileInfo {
  const FileInfo({required this.field, required this.path, this.filename, this.contentType});

  final String field;
  final String path;
  final String? filename;
  final String? contentType;
}
