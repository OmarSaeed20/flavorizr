// lib/core/performance/performance_monitor.dart
/// Performance monitoring service for tracking app performance metrics.
///
/// Provides utilities for:
/// - Monitoring app startup time
/// - Tracking frame rates
/// - Monitoring memory usage
/// - Recording performance events
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Performance monitoring service.
class PerformanceMonitor {
  PerformanceMonitor._();

  static final PerformanceMonitor _instance = PerformanceMonitor._();
  static PerformanceMonitor get instance => _instance;

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

  /// Initialize the performance monitor.
  Future<void> initialize() async {
    if (_enabled) {
      _startMonitoring();
    }
  }

  /// Record app startup time.
  void recordStartupTime(Duration duration) {
    if (!_enabled) return;

    _startupTime = duration;
    _events.add(
      PerformanceEvent(name: 'app_startup', timestamp: DateTime.now(), duration: duration),
    );

    if (kDebugMode) {
      debugPrint('Performance: App startup took ${duration.inMilliseconds}ms');
    }
  }

  /// Record a custom performance event.
  void recordEvent(String name, {Duration? duration, Map<String, dynamic>? metadata}) {
    if (!_enabled) return;

    _events.add(
      PerformanceEvent(
        name: name,
        timestamp: DateTime.now(),
        duration: duration,
        metadata: metadata,
      ),
    );

    if (kDebugMode) {
      debugPrint(
        'Performance: Event "$name" recorded${duration != null ? ' (${duration.inMilliseconds}ms)' : ''}',
      );
    }
  }

  /// Start a performance timer.
  ///
  /// Returns a function that stops the timer and records the duration.
  VoidCallback startTimer(String name) {
    if (!_enabled) {
      return () {};
    }

    final stopwatch = Stopwatch()..start();
    return () {
      stopwatch.stop();
      recordEvent(name, duration: stopwatch.elapsed);
    };
  }

  /// Get all recorded events.
  List<PerformanceEvent> get events => List.unmodifiable(_events);

  /// Get events by name.
  List<PerformanceEvent> getEventsByName(String name) {
    return _events.where((event) => event.name == name).toList();
  }

  /// Get the app startup time.
  Duration? get startupTime => _startupTime;

  /// Get the current frame rate.
  double get currentFPS => _frameRateMonitor.currentFPS;

  /// Get the average frame rate.
  double get averageFPS => _frameRateMonitor.averageFPS;

  /// Get the minimum frame rate.
  double get minFPS => _frameRateMonitor.minFPS;

  /// Get the maximum frame rate.
  double get maxFPS => _frameRateMonitor.maxFPS;

  /// Get the number of dropped frames.
  int get droppedFrames => _frameRateMonitor.droppedFrames;

  /// Get the current memory usage.
  int get currentMemoryUsage => _memoryMonitor.currentMemoryUsage;

  /// Get the peak memory usage.
  int get peakMemoryUsage => _memoryMonitor.peakMemoryUsage;

  /// Clear all recorded events.
  void clearEvents() {
    _events.clear();
    _startupTime = null;
  }

  /// Get a performance summary.
  PerformanceSummary get summary {
    return PerformanceSummary(
      startupTime: _startupTime,
      currentFPS: currentFPS,
      averageFPS: averageFPS,
      minFPS: minFPS,
      maxFPS: maxFPS,
      droppedFrames: droppedFrames,
      currentMemoryUsage: currentMemoryUsage,
      peakMemoryUsage: peakMemoryUsage,
      events: List.from(_events),
    );
  }

  /// Export performance data as JSON.
  Map<String, dynamic> exportToJson() {
    return summary.toJson();
  }

  // Private

  final List<PerformanceEvent> _events = [];
  Duration? _startupTime;
  final _FrameRateMonitor _frameRateMonitor = _FrameRateMonitor();
  final _MemoryMonitor _memoryMonitor = _MemoryMonitor();

  void _startMonitoring() {
    _frameRateMonitor.start();
    _memoryMonitor.start();
  }

  void _stopMonitoring() {
    _frameRateMonitor.stop();
    _memoryMonitor.stop();
  }
}

/// A performance event.
class PerformanceEvent {
  final String name;
  final DateTime timestamp;
  final Duration? duration;
  final Map<String, dynamic>? metadata;

  PerformanceEvent({required this.name, required this.timestamp, this.duration, this.metadata});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'timestamp': timestamp.toIso8601String(),
      'duration': duration?.inMilliseconds,
      'metadata': metadata,
    };
  }
}

/// A performance summary.
class PerformanceSummary {
  final Duration? startupTime;
  final double currentFPS;
  final double averageFPS;
  final double minFPS;
  final double maxFPS;
  final int droppedFrames;
  final int currentMemoryUsage;
  final int peakMemoryUsage;
  final List<PerformanceEvent> events;

  PerformanceSummary({
    this.startupTime,
    required this.currentFPS,
    required this.averageFPS,
    required this.minFPS,
    required this.maxFPS,
    required this.droppedFrames,
    required this.currentMemoryUsage,
    required this.peakMemoryUsage,
    required this.events,
  });

  Map<String, dynamic> toJson() {
    return {
      'startupTime': startupTime?.inMilliseconds,
      'currentFPS': currentFPS,
      'averageFPS': averageFPS,
      'minFPS': minFPS,
      'maxFPS': maxFPS,
      'droppedFrames': droppedFrames,
      'currentMemoryUsage': currentMemoryUsage,
      'peakMemoryUsage': peakMemoryUsage,
      'events': events.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'PerformanceSummary('
        'startupTime: ${startupTime?.inMilliseconds ?? 'N/A'}ms, '
        'currentFPS: ${currentFPS.toStringAsFixed(1)}, '
        'averageFPS: ${averageFPS.toStringAsFixed(1)}, '
        'minFPS: ${minFPS.toStringAsFixed(1)}, '
        'maxFPS: ${maxFPS.toStringAsFixed(1)}, '
        'droppedFrames: $droppedFrames, '
        'currentMemoryUsage: ${currentMemoryUsage ~/ 1024}KB, '
        'peakMemoryUsage: ${peakMemoryUsage ~/ 1024}KB, '
        'events: ${events.length})';
  }
}

/// Frame rate monitor.
class _FrameRateMonitor {
  _FrameRateMonitor();

  bool _isRunning = false;
  final List<int> _frameTimes = [];
  Timer? _timer;
  int _frameCount = 0;

  double _currentFPS = 0;
  double _averageFPS = 0;
  double _minFPS = double.infinity;
  double _maxFPS = 0;
  int _droppedFrames = 0;

  double get currentFPS => _currentFPS;
  double get averageFPS => _averageFPS;
  double get minFPS => _minFPS;
  double get maxFPS => _maxFPS;
  int get droppedFrames => _droppedFrames;

  void start() {
    if (_isRunning) return;
    _isRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateStats();
    });

    SchedulerBinding.instance.addTimingsCallback(_onTimingsCallback);
  }

  void stop() {
    if (!_isRunning) return;
    _isRunning = false;

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

    final avgFrameTime = _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
    _currentFPS = 1000000 / avgFrameTime;

    _averageFPS = _frameCount / _frameTimes.length * 1000000 / avgFrameTime;

    final minFrameTime = _frameTimes.reduce((a, b) => a < b ? a : b);
    final maxFrameTime = _frameTimes.reduce((a, b) => a > b ? a : b);

    _minFPS = 1000000 / maxFrameTime;
    _maxFPS = 1000000 / minFrameTime;

    _frameTimes.clear();
  }
}

/// Memory monitor.
class _MemoryMonitor {
  _MemoryMonitor();

  bool _isRunning = false;
  Timer? _timer;

  int _currentMemoryUsage = 0;
  int _peakMemoryUsage = 0;

  int get currentMemoryUsage => _currentMemoryUsage;
  int get peakMemoryUsage => _peakMemoryUsage;

  void start() {
    if (_isRunning) return;
    _isRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _updateMemoryUsage();
    });
  }

  void stop() {
    if (!_isRunning) return;
    _isRunning = false;

    _timer?.cancel();
    _timer = null;
  }

  void _updateMemoryUsage() {
    // Note: This is a simplified implementation.
    // In a real app, you would use platform-specific APIs to get actual memory usage.
    // For web, you can use performance.memory
    // For mobile, you would need platform channels.

    // Simulated memory usage for demonstration
    _currentMemoryUsage = 50 * 1024 * 1024; // 50 MB
    if (_currentMemoryUsage > _peakMemoryUsage) {
      _peakMemoryUsage = _currentMemoryUsage;
    }
  }
}

/// Performance monitor widget for displaying performance metrics.
class PerformanceMonitorWidget extends StatefulWidget {
  final Widget child;
  final bool showOverlay;

  const PerformanceMonitorWidget({super.key, required this.child, this.showOverlay = true});

  @override
  State<PerformanceMonitorWidget> createState() => _PerformanceMonitorWidgetState();
}

class _PerformanceMonitorWidgetState extends State<PerformanceMonitorWidget> {
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    if (widget.showOverlay) {
      _updateTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showOverlay && PerformanceMonitor.instance.enabled)
          Positioned(top: 8, right: 8, child: _PerformanceOverlay()),
      ],
    );
  }
}

/// Performance overlay widget.
class _PerformanceOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final monitor = PerformanceMonitor.instance;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMetric('FPS', monitor.currentFPS.toStringAsFixed(1)),
          _buildMetric('Avg FPS', monitor.averageFPS.toStringAsFixed(1)),
          _buildMetric('Min FPS', monitor.minFPS.toStringAsFixed(1)),
          _buildMetric('Max FPS', monitor.maxFPS.toStringAsFixed(1)),
          _buildMetric('Dropped', '${monitor.droppedFrames}'),
          _buildMetric(
            'Memory',
            '${(monitor.currentMemoryUsage / 1024 / 1024).toStringAsFixed(1)} MB',
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: const TextStyle(color: Colors.white70, fontSize: 10)),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// Extensions for convenient performance monitoring.
extension PerformanceMonitorExtensions on BuildContext {
  /// Start a performance timer.
  VoidCallback startPerformanceTimer(String name) {
    return PerformanceMonitor.instance.startTimer(name);
  }

  /// Record a performance event.
  void recordPerformanceEvent(String name, {Duration? duration, Map<String, dynamic>? metadata}) {
    PerformanceMonitor.instance.recordEvent(name, duration: duration, metadata: metadata);
  }
}
