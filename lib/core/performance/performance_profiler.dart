// lib/core/performance/performance_profiler.dart
/// Performance profiler for measuring and analyzing app performance.
///
/// Provides utilities for:
/// - Measuring frame times
/// - Tracking widget build times
/// - Profiling operations
/// - Performance metrics
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Performance profiler for measuring app performance.
class PerformanceProfiler {
  PerformanceProfiler._();

  static final PerformanceProfiler _instance = PerformanceProfiler._();
  static PerformanceProfiler get instance => _instance;

  /// Whether profiling is enabled.
  bool _enabled = false;

  /// Whether profiling is enabled.
  bool get enabled => _enabled;

  /// Enable or disable profiling.
  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Profile a function and return its result.
  ///
  /// Example:
  /// ```dart
  /// final result = PerformanceProfiler.profile('myOperation', () {
  ///   return expensiveOperation();
  /// });
  /// ```
  static T profile<T>(String name, T Function() operation) {
    if (!instance._enabled) {
      return operation();
    }

    final stopwatch = Stopwatch()..start();
    try {
      return operation();
    } finally {
      stopwatch.stop();
      instance._recordMetric(name, stopwatch.elapsedMicroseconds);
    }
  }

  /// Profile an async function and return its result.
  ///
  /// Example:
  /// ```dart
  /// final result = await PerformanceProfiler.profileAsync('myAsyncOperation', () async {
  ///   return await expensiveAsyncOperation();
  /// });
  /// ```
  static Future<T> profileAsync<T>(
    String name,
    Future<T> Function() operation,
  ) async {
    if (!instance._enabled) {
      return operation();
    }

    final stopwatch = Stopwatch()..start();
    try {
      return await operation();
    } finally {
      stopwatch.stop();
      instance._recordMetric(name, stopwatch.elapsedMicroseconds);
    }
  }

  /// Profile a widget build.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return PerformanceProfiler.profileWidget('MyWidget', () {
  ///     return Container(...);
  ///   });
  /// }
  /// ```
  static Widget profileWidget(String name, Widget Function() builder) {
    if (!instance._enabled) {
      return builder();
    }

    return _ProfiledWidget(name: name, builder: builder);
  }

  /// Start a frame timer.
  ///
  /// Returns a function that stops the timer and records the frame time.
  static VoidCallback startFrameTimer(String name) {
    if (!instance._enabled) {
      return () {};
    }

    final stopwatch = Stopwatch()..start();
    return () {
      stopwatch.stop();
      instance._recordMetric('$name (frame)', stopwatch.elapsedMicroseconds);
    };
  }

  /// Record a custom metric.
  static void recordMetric(String name, int microseconds) {
    if (instance._enabled) {
      instance._recordMetric(name, microseconds);
    }
  }

  /// Get all recorded metrics.
  Map<String, PerformanceMetric> get metrics => Map.unmodifiable(_metrics);

  /// Clear all recorded metrics.
  void clearMetrics() {
    _metrics.clear();
  }

  /// Get metrics for a specific name.
  PerformanceMetric? getMetric(String name) => _metrics[name];

  /// Get all metrics sorted by average time.
  List<PerformanceMetric> get sortedMetrics {
    final metrics = _metrics.values.toList();
    metrics.sort(
      (a, b) => b.averageMicroseconds.compareTo(a.averageMicroseconds),
    );
    return metrics;
  }

  /// Get a summary of all metrics.
  String get summary {
    if (_metrics.isEmpty) return 'No metrics recorded';

    final buffer = StringBuffer();
    buffer.writeln('Performance Metrics Summary:');
    buffer.writeln('===========================');

    final sorted = sortedMetrics;
    for (final metric in sorted) {
      buffer.writeln(
        '${metric.name}: '
        'avg=${metric.averageMicroseconds}μs '
        'min=${metric.minMicroseconds}μs '
        'max=${metric.maxMicroseconds}μs '
        'count=${metric.count}',
      );
    }

    return buffer.toString();
  }

  // Private methods

  final Map<String, PerformanceMetric> _metrics = {};

  void _recordMetric(String name, int microseconds) {
    final metric = _metrics.putIfAbsent(
      name,
      () => PerformanceMetric(name: name),
    );
    metric.addSample(microseconds);

    if (kDebugMode) {
      debugPrint('Performance: $name took $microsecondsμs');
    }
  }
}

/// A performance metric with statistics.
class PerformanceMetric {
  final String name;
  final List<int> _samples = [];

  PerformanceMetric({required this.name});

  /// Add a sample to the metric.
  void addSample(int microseconds) {
    _samples.add(microseconds);
  }

  /// The number of samples.
  int get count => _samples.length;

  /// The average time in microseconds.
  int get averageMicroseconds {
    if (_samples.isEmpty) return 0;
    return _samples.reduce((a, b) => a + b) ~/ _samples.length;
  }

  /// The minimum time in microseconds.
  int get minMicroseconds {
    if (_samples.isEmpty) return 0;
    return _samples.reduce((a, b) => a < b ? a : b);
  }

  /// The maximum time in microseconds.
  int get maxMicroseconds {
    if (_samples.isEmpty) return 0;
    return _samples.reduce((a, b) => a > b ? a : b);
  }

  /// The median time in microseconds.
  int get medianMicroseconds {
    if (_samples.isEmpty) return 0;
    final sorted = List<int>.from(_samples)..sort();
    final mid = sorted.length ~/ 2;
    if (sorted.length % 2 == 1) {
      return sorted[mid];
    } else {
      return (sorted[mid - 1] + sorted[mid]) ~/ 2;
    }
  }

  /// The 95th percentile time in microseconds.
  int get p95Microseconds {
    if (_samples.isEmpty) return 0;
    final sorted = List<int>.from(_samples)..sort();
    final index = (sorted.length * 0.95).floor().clamp(0, sorted.length - 1);
    return sorted[index];
  }

  /// The 99th percentile time in microseconds.
  int get p99Microseconds {
    if (_samples.isEmpty) return 0;
    final sorted = List<int>.from(_samples)..sort();
    final index = (sorted.length * 0.99).floor().clamp(0, sorted.length - 1);
    return sorted[index];
  }

  /// Convert to milliseconds.
  double get averageMilliseconds => averageMicroseconds / 1000.0;
  double get minMilliseconds => minMicroseconds / 1000.0;
  double get maxMilliseconds => maxMicroseconds / 1000.0;
  double get medianMilliseconds => medianMicroseconds / 1000.0;
  double get p95Milliseconds => p95Microseconds / 1000.0;
  double get p99Milliseconds => p99Microseconds / 1000.0;
}

/// A widget that profiles its build time.
class _ProfiledWidget extends StatefulWidget {
  final String name;
  final Widget Function() builder;

  const _ProfiledWidget({required this.name, required this.builder});

  @override
  State<_ProfiledWidget> createState() => _ProfiledWidgetState();
}

class _ProfiledWidgetState extends State<_ProfiledWidget> {
  @override
  Widget build(BuildContext context) {
    final stopwatch = Stopwatch()..start();
    final child = widget.builder();
    stopwatch.stop();

    PerformanceProfiler.recordMetric(
      'Widget: ${widget.name}',
      stopwatch.elapsedMicroseconds,
    );

    return child;
  }
}

/// Frame rate monitor for tracking app performance.
class FrameRateMonitor {
  FrameRateMonitor._();

  static final FrameRateMonitor _instance = FrameRateMonitor._();
  static FrameRateMonitor get instance => _instance;

  /// Whether monitoring is enabled.
  bool _enabled = false;

  /// Whether monitoring is enabled.
  bool get enabled => _enabled;

  /// Enable or disable monitoring.
  void setEnabled(bool enabled) {
    _enabled = enabled;
    if (enabled) {
      _startMonitoring();
    } else {
      _stopMonitoring();
    }
  }

  /// The current frame rate in frames per second.
  double get currentFPS => _currentFPS;

  /// The average frame rate in frames per second.
  double get averageFPS => _averageFPS;

  /// The minimum frame rate in frames per second.
  double get minFPS => _minFPS;

  /// The maximum frame rate in frames per second.
  double get maxFPS => _maxFPS;

  /// The number of dropped frames.
  int get droppedFrames => _droppedFrames;

  /// Clear all statistics.
  void clear() {
    _frameTimes.clear();
    _droppedFrames = 0;
    _minFPS = double.infinity;
    _maxFPS = 0;
    _averageFPS = 0;
    _currentFPS = 0;
  }

  // Private

  final List<int> _frameTimes = [];
  Timer? _timer;
  double _currentFPS = 0;
  double _averageFPS = 0;
  double _minFPS = double.infinity;
  double _maxFPS = 0;
  int _droppedFrames = 0;
  int _frameCount = 0;

  void _startMonitoring() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateStats();
    });

    SchedulerBinding.instance.addTimingsCallback(_onTimingsCallback);
  }

  void _stopMonitoring() {
    _timer?.cancel();
    _timer = null;
    SchedulerBinding.instance.removeTimingsCallback(_onTimingsCallback);
  }

  void _onTimingsCallback(List<FrameTiming> timings) {
    for (final timing in timings) {
      final frameTime = timing.totalSpan.inMicroseconds;
      _frameTimes.add(frameTime);

      // Count dropped frames (frames that took longer than 16.67ms)
      if (frameTime > 16667) {
        _droppedFrames++;
      }

      _frameCount++;
    }
  }

  void _updateStats() {
    if (_frameTimes.isEmpty) return;

    final avgFrameTime =
        _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
    _currentFPS = 1000000 / avgFrameTime;

    _averageFPS = _frameCount / _frameTimes.length * 1000000 / avgFrameTime;

    final minFrameTime = _frameTimes.reduce((a, b) => a < b ? a : b);
    final maxFrameTime = _frameTimes.reduce((a, b) => a > b ? a : b);

    _minFPS = 1000000 / maxFrameTime;
    _maxFPS = 1000000 / minFrameTime;

    _frameTimes.clear();

    if (kDebugMode) {
      debugPrint(
        'Frame Rate: ${_currentFPS.toStringAsFixed(1)} FPS '
        '(avg: ${_averageFPS.toStringAsFixed(1)}, '
        'min: ${_minFPS.toStringAsFixed(1)}, '
        'max: ${_maxFPS.toStringAsFixed(1)}, '
        'dropped: $_droppedFrames)',
      );
    }
  }
}

/// Memory monitor for tracking memory usage.
class MemoryMonitor {
  MemoryMonitor._();

  static final MemoryMonitor _instance = MemoryMonitor._();
  static MemoryMonitor get instance => _instance;

  /// Whether monitoring is enabled.
  bool _enabled = false;

  /// Whether monitoring is enabled.
  bool get enabled => _enabled;

  /// Enable or disable monitoring.
  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Get current memory usage in bytes.
  int get currentMemoryUsage => _currentMemoryUsage;

  /// Get peak memory usage in bytes.
  int get peakMemoryUsage => _peakMemoryUsage;

  /// Clear statistics.
  void clear() {
    _currentMemoryUsage = 0;
    _peakMemoryUsage = 0;
  }

  // Private

  int _currentMemoryUsage = 0;
  int _peakMemoryUsage = 0;

  /// Update memory usage (should be called periodically).
  void update() {
    if (!_enabled) return;

    // Note: This is a simplified implementation.
    // In a real app, you would use platform-specific APIs to get actual memory usage.
    // For web, you can use performance.memory
    // For mobile, you would need platform channels.

    if (kDebugMode) {
      debugPrint(
        'Memory Usage: ${_currentMemoryUsage ~/ 1024} KB '
        '(peak: ${_peakMemoryUsage ~/ 1024} KB)',
      );
    }
  }
}

/// Extensions for convenient profiling.
extension PerformanceProfilerExtensions on BuildContext {
  /// Profile a widget build.
  Widget profileWidget(String name, Widget Function() builder) {
    return PerformanceProfiler.profileWidget(name, builder);
  }
}
