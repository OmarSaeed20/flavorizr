import 'package:flavorizr/core/logger/advanced_app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A Riverpod observer that logs provider state changes in debug mode.
final class ProviderLogger extends ProviderObserver {
  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value, ProviderContainer container) {
    AppLogger.instance.logDebug('Provider added: ${provider.name ?? provider.runtimeType}');
  }

  @override
  void didDisposeProvider(ProviderBase<Object?> provider, ProviderContainer container) {
    AppLogger.instance.logDebug('Provider disposed: ${provider.name ?? provider.runtimeType}');
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    AppLogger.instance.logDebug(
      'Provider updated: ${provider.name ?? provider.runtimeType}',
      data: {'previousValue': previousValue?.toString(), 'newValue': newValue?.toString()},
    );
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    AppLogger.instance.logError(
      'Provider failed: ${provider.name ?? provider.runtimeType}',
      stackTrace: stackTrace.toString(),
      data: {'error': error.toString()},
    );
  }
}
