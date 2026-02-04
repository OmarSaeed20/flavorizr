import 'dart:async';

import 'package:flavorizr/core/logger/advanced_app_logger.dart';
import 'package:flavorizr/core/network/exception/network_exceptions.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';

/// Base mixin for local data sources
/// Provides common functionality for local data operations
mixin BaseLocalDataSource {
  /// Get data from local storage
  /// Returns ApiResult with the data or an error
  Future<ApiResult<T>> getLocalData<T>({
    required String key,
    required Future<T?> Function() fetcher,
  }) async {
    try {
      final data = await fetcher();
      if (data == null) {
        return ApiResult.exception(const NotFoundException(message: 'Local data not found'));
      }
      return ApiResult.success(data);
    } catch (e, stackTrace) {
      e.logError('Error getting local data: $key', stackTrace: stackTrace.toString());
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace));
    }
  }

  /// Save data to local storage
  /// Returns ApiResult with success or error
  Future<ApiResult<T>> saveLocalData<T>({
    required String key,
    required T data,
    required Future<void> Function(T data) saver,
  }) async {
    try {
      await saver(data);
      return ApiResult.success(data);
    } catch (e, stackTrace) {
      e.logError('Error saving local data: $key', stackTrace: stackTrace.toString());
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace));
    }
  }

  /// Delete data from local storage
  /// Returns ApiResult with success or error
  Future<ApiResult<void>> deleteLocalData({
    required String key,
    required Future<void> Function() deleter,
  }) async {
    try {
      await deleter();
      return const ApiResult.success(null);
    } catch (e, stackTrace) {
      e.logError('Error deleting local data: $key', stackTrace: stackTrace.toString());
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace));
    }
  }

  /// Clear all local data
  /// Returns ApiResult with success or error
  Future<ApiResult<void>> clearAllLocalData({required Future<void> Function() clearer}) async {
    try {
      await clearer();
      return const ApiResult.success(null);
    } catch (e, stackTrace) {
      e.logError('Error clearing local data', stackTrace: stackTrace.toString());
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace));
    }
  }

  /// Check if local data exists
  /// Returns ApiResult with boolean result
  Future<ApiResult<bool>> hasLocalData({
    required String key,
    required Future<bool> Function() checker,
  }) async {
    try {
      final exists = await checker();
      return ApiResult.success(exists);
    } catch (e, stackTrace) {
      e.logError('Error checking local data: $key', stackTrace: stackTrace.toString());
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace));
    }
  }

  /// Get multiple items from local storage
  /// Returns ApiResult with list of items
  Future<ApiResult<List<T>>> getLocalDataList<T>({
    required String key,
    required Future<List<T>?> Function() fetcher,
  }) async {
    try {
      final data = await fetcher();
      if (data == null || data.isEmpty) {
        return const ApiResult.exception(NotFoundException(message: 'Local data list not found'));
      }
      return ApiResult.success(data);
    } catch (e, stackTrace) {
      e.logError('Error getting local data list: $key', stackTrace: stackTrace.toString());
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace));
    }
  }

  /// Save multiple items to local storage
  /// Returns ApiResult with success or error
  Future<ApiResult<void>> saveLocalDataList<T>({
    required String key,
    required List<T> data,
    required Future<void> Function(List<T> data) saver,
  }) async {
    try {
      await saver(data);
      return const ApiResult.success(null);
    } catch (e, stackTrace) {
      e.logError('Error saving local data list: $key', stackTrace: stackTrace.toString());
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace));
    }
  }
}
