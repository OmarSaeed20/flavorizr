import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flavorizr/core/logger/advanced_app_logger.dart';

import '/config/flavors.dart';
import '/core/network/interceptors/analytics_interceptor.dart'
    show AnalyticsInterceptor;
import '/core/network/interceptors/jwt_interceptor.dart' show JwtInterceptor;
import '/core/network/interceptors/performance_interceptor.dart'
    show PerformanceInterceptor;
import '/core/network/interceptors/retry_interceptor.dart'
    show RetryInterceptor;
import 'exception/dio_exception_handler.dart';
import 'exception/network_exceptions.dart';

class ApiClient {
  ApiClient._internal() {
    _dio = Dio();
    _setupDio();
  }

  ApiClient get instance => _instance ??= ApiClient._internal();

  static ApiClient? _instance;
  static Flavor _currentEnvironment = F.appFlavor;

  late final Dio _dio;
  CancelToken? _cancelToken;

  static void setEnvironment(Flavor environment) {
    _currentEnvironment = environment;
    _instance = null; // Reset instance to recreate with new environment
  }

  void _setupDio() {
    _dio.options = BaseOptions(
      baseUrl: _currentEnvironment.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add interceptors in order
    _dio.interceptors.addAll([
      // JWT Interceptor (should be first for auth)
      JwtInterceptor(dio: _dio),

      // Retry Interceptor
      RetryInterceptor(),

      // Performance Interceptor
      PerformanceInterceptor(),

      // Analytics Interceptor
      AnalyticsInterceptor(),

      // Logging Interceptor (should be last for complete logs)
      if (!_currentEnvironment.isProduction)
        AwesomeDioInterceptor(
          logger: (message) {
            // ignore: avoid_print
            print('🌐 HTTP: $message');
          },
        ),
    ]);
  }

  // GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      return response;
    } on DioException catch (e) {
      final networkException = await DioExceptionHandler.handleDioException(e);
      throw networkException;
    }
  }

  // POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      return response;
    } on DioException catch (e) {
      final networkException = await DioExceptionHandler.handleDioException(e);
      throw networkException;
    }
  }

  // PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      return response;
    } on DioException catch (e) {
      final networkException = await DioExceptionHandler.handleDioException(e);
      throw networkException;
    }
  }

  // DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      return response;
    } on DioException catch (e) {
      final networkException = await DioExceptionHandler.handleDioException(e);
      throw networkException;
    }
  }

  // PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      return response;
    } on DioException catch (e) {
      final networkException = await DioExceptionHandler.handleDioException(e);
      throw networkException;
    }
  }

  // File upload
  Future<Response<T>> uploadFile<T>(
    String path,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? additionalData,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        if (additionalData != null) ...additionalData,
      });

      final response = await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken ?? _cancelToken,
      );
      return response;
    } on DioException catch (e) {
      final networkException = await DioExceptionHandler.handleDioException(e);
      throw networkException;
    }
  }

  // Cancel requests
  void cancelRequests() {
    _cancelToken?.cancel('Request cancelled by user');
    _cancelToken = CancelToken();
  }

  // Create new cancel token
  CancelToken createCancelToken() {
    return CancelToken();
  }

  // Get current environment
  Flavor get currentEnvironment => _currentEnvironment;

  // Access underlying Dio instance if needed
  Dio get dio => _dio;

  // POST request
  Future<Response<T>> postTest<T>(
    String path, {
    required T Function(dynamic) dataParser,
    Map<String, dynamic> data = const {},
    Map<String, dynamic> queryParameters = const {},
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final extra = <String, dynamic>{};
    final query = <String, dynamic>{}..addAll(queryParameters);
    final headers = <String, dynamic>{}..removeWhere((k, v) => v == null);
    final data0 = <String, dynamic>{}..addAll(data);
    final options0 = _setStreamType<T>(
      Options(method: 'POST', headers: headers, extra: extra)
          .compose(_dio.options, path, queryParameters: query)
          .copyWith(
            baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              _currentEnvironment.baseUrl,
            ),
            data: data0,
          ),
    );
    final result = await _dio.fetch<Map<String, dynamic>>(options0);
    late Response<T> value;
    try {
      value = Response<T>(
        data: dataParser(result.data),
        requestOptions: result.requestOptions,
      );
    } on DioException catch (e) {
      final networkException = await DioExceptionHandler.handleDioException(e);
      throw networkException;
    } on Object catch (e, s) {
      await AppLogger.instance.logError(
        e.toString(),
        stackTrace: s.toString(),
        data: result.requestOptions.data as Map<String, dynamic>?,
      );
      value = Response<T>(
        headers: result.headers,
        extra: result.extra,
        requestOptions: result.requestOptions,
        statusMessage: 'An unexpected error occurred',
        statusCode: 0,
      );
      rethrow;
    }
    return value;
  }

  // Generic request method
  Future<Response<T>> request<T>({
    required String method,
    required String path,
    required T Function(dynamic) dataParser,
    dynamic data,
    Map<String, dynamic> queryParameters = const {},
    Map<String, dynamic> headers = const {},
    Map<String, dynamic> extra = const {},
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      // Check connectivity
      // final connectivityResult = await _connectivity.checkConnectivity();
      // if (connectivityResult.first == ConnectivityResult.none) {
      //   throw NetworkException(
      //     message: 'No internet connection',
      //     statusCode: 0,
      //     errorCode: 'NO_CONNECTION',
      //   );
      // }
     /*  final options0 = _setStreamType<T>(
        Options(method: method, headers: headers, extra: extra)
            .compose(_dio.options, path, queryParameters: queryParameters)
            .copyWith(
              baseUrl: _combineBaseUrls(
                _dio.options.baseUrl,
                _currentEnvironment.baseUrl,
              ),
              data: data,
            ),
      ); */
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method, headers: headers, extra: extra),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return Response<T>(
        data: dataParser(response.data),
        requestOptions: response.requestOptions,
        extra: response.extra,
        headers: response.headers,
        statusMessage: response.statusMessage,
        // message: 'Success',
        // success: true,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      // _logger.e('Dio error: ${e.message}', error: e, stackTrace: e.stackTrace);

      final networkException = NetworkException(
        message:
            (e.response?.data?['message'] as String?) ??
            e.message ??
            'Unknown error',
        statusCode: e.response?.statusCode ?? 0,
        errorCode: e.response?.data?['code'] as String?,
      );

      return Response<T>(
        requestOptions: e.requestOptions,
        statusMessage: networkException.message,
        statusCode: networkException.statusCode,
      );
      /* return Response<T>(
        message: networkException.message,
        success: false,
        statusCode: networkException.statusCode,
      ); */
    } catch (e) {
      // _logger.e('Unexpected error: $e', error: e, stackTrace: stackTrace);

      // return Response<T>(
      //   message: 'An unexpected error occurred',
      //   success: false,
      //   statusCode: 0,
      // );
      rethrow;
    }
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
