// lib/core/performance/lazy_loading_service.dart
/// Lazy loading service for optimizing app performance.
///
/// Provides utilities for:
/// - Lazy loading widgets
/// - Deferred loading
/// - Code splitting
library;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Service for managing lazy loading of widgets and resources.
class LazyLoadingService {
  LazyLoadingService._();

  /// Creates a lazy-loaded widget that only builds when visible.
  ///
  /// This is useful for optimizing performance by only building widgets
  /// when they are actually visible on screen.
  static Widget lazy({
    required Widget Function() builder,
    Widget? placeholder,
    double threshold = 0.1,
  }) {
    return _LazyWidget(builder: builder, placeholder: placeholder, threshold: threshold);
  }

  /// Creates a lazy-loaded list builder.
  ///
  /// This is useful for long lists where you only want to build
  /// items that are currently visible.
  static Widget lazyList<T>({
    required List<T> items,
    required Widget Function(BuildContext context, T item, int index) itemBuilder,
    Widget? placeholder,
    double threshold = 0.1,
  }) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _LazyWidget(
          builder: () => itemBuilder(context, items[index], index),
          placeholder: placeholder,
          threshold: threshold,
        );
      },
    );
  }

  /// Creates a lazy-loaded grid builder.
  ///
  /// This is useful for grids where you only want to build
  /// items that are currently visible.
  static Widget lazyGrid<T>({
    required List<T> items,
    required Widget Function(BuildContext context, T item, int index) itemBuilder,
    required int crossAxisCount,
    Widget? placeholder,
    double threshold = 0.1,
    double mainAxisSpacing = 0,
    double crossAxisSpacing = 0,
    double childAspectRatio = 1.0,
  }) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _LazyWidget(
          builder: () => itemBuilder(context, items[index], index),
          placeholder: placeholder,
          threshold: threshold,
        );
      },
    );
  }

  /// Creates a lazy-loaded page view.
  ///
  /// This is useful for page views where you only want to build
  /// pages that are currently visible.
  static Widget lazyPageView<T>({
    required List<T> items,
    required Widget Function(BuildContext context, T item, int index) itemBuilder,
    Widget? placeholder,
    double threshold = 0.1,
    PageController? controller,
    ScrollPhysics? physics,
    bool allowImplicitScrolling = true,
  }) {
    return PageView.builder(
      controller: controller,
      physics: physics,
      allowImplicitScrolling: allowImplicitScrolling,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _LazyWidget(
          builder: () => itemBuilder(context, items[index], index),
          placeholder: placeholder,
          threshold: threshold,
        );
      },
    );
  }

  /// Creates a deferred widget that loads after a delay.
  ///
  /// This is useful for loading non-critical UI elements after
  /// the main content has loaded.
  static Widget deferred({
    required Widget Function() builder,
    Duration delay = const Duration(milliseconds: 300),
    Widget? placeholder,
  }) {
    return _DeferredWidget(builder: builder, delay: delay, placeholder: placeholder);
  }

  /// Creates a widget that loads only when the app is idle.
  ///
  /// This is useful for loading non-critical content during
  /// idle periods to improve perceived performance.
  static Widget idleLoad({required Widget Function() builder, Widget? placeholder}) {
    return _IdleLoadWidget(builder: builder, placeholder: placeholder);
  }
}

/// A widget that only builds when it becomes visible.
class _LazyWidget extends StatefulWidget {
  final Widget Function() builder;
  final Widget? placeholder;
  final double threshold;

  const _LazyWidget({required this.builder, this.placeholder, this.threshold = 0.1});

  @override
  State<_LazyWidget> createState() => _LazyWidgetState();
}

class _LazyWidgetState extends State<_LazyWidget> {
  bool _isLoaded = false;
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction >= widget.threshold && !_isVisible) {
          setState(() {
            _isVisible = true;
            _isLoaded = true;
          });
        }
      },
      child: _isLoaded ? widget.builder() : widget.placeholder ?? const SizedBox.shrink(),
    );
  }
}

/// A widget that loads after a delay.
class _DeferredWidget extends StatefulWidget {
  final Widget Function() builder;
  final Duration delay;
  final Widget? placeholder;

  const _DeferredWidget({required this.builder, required this.delay, this.placeholder});

  @override
  State<_DeferredWidget> createState() => _DeferredWidgetState();
}

class _DeferredWidgetState extends State<_DeferredWidget> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded ? widget.builder() : widget.placeholder ?? const SizedBox.shrink();
  }
}

/// A widget that loads during idle periods.
class _IdleLoadWidget extends StatefulWidget {
  final Widget Function() builder;
  final Widget? placeholder;

  const _IdleLoadWidget({required this.builder, this.placeholder});

  @override
  State<_IdleLoadWidget> createState() => _IdleLoadWidgetState();
}

class _IdleLoadWidgetState extends State<_IdleLoadWidget> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SchedulerBinding.instance.scheduleFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isLoaded = true;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded ? widget.builder() : widget.placeholder ?? const SizedBox.shrink();
  }
}

/// A widget that detects visibility changes.
class VisibilityDetector extends StatefulWidget {
  final Widget child;
  // @override
  // final Key key;
  final void Function(VisibilityInfo) onVisibilityChanged;

  const VisibilityDetector({
    super.key,
    required this.child,
    // required this.key,
    required this.onVisibilityChanged,
  });

  @override
  State<VisibilityDetector> createState() => _VisibilityDetectorState();
}

class _VisibilityDetectorState extends State<VisibilityDetector> {
  final GlobalKey _key = GlobalKey();
  bool _hasNotified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    if (!mounted) return;

    final RenderBox? renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    final double visibleTop = offset.dy;
    final double visibleBottom = offset.dy + size.height;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double visibleHeight = (visibleBottom - visibleTop).clamp(0.0, screenHeight);
    final double visibleFraction = visibleHeight / size.height;

    // Only notify if visibility has changed
    if (_hasNotified && visibleFraction == 0.0) {
      _hasNotified = false;
    } else if (!_hasNotified && visibleFraction > 0.0) {
      widget.onVisibilityChanged(
        VisibilityInfo(
          visibleFraction: visibleFraction,
          visibleBounds: Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height),
        ),
      );
      _hasNotified = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _checkVisibility();
        return false;
      },
      child: Container(key: _key, child: widget.child),
    );
  }
}

/// Information about widget visibility.
class VisibilityInfo {
  /// The fraction of the widget that is visible (0.0 to 1.0).
  final double visibleFraction;

  /// The bounds of the visible portion of the widget.
  final Rect visibleBounds;

  const VisibilityInfo({required this.visibleFraction, required this.visibleBounds});
}
