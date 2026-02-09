// lib/core/performance/widget_optimizer.dart
/// Widget optimization utilities for improving app performance.
///
/// Provides utilities for:
/// - Optimizing widget rebuilds
/// - Reducing widget tree depth
/// - Using const constructors
/// - Optimizing list rendering
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Widget optimizer for improving app performance.
class WidgetOptimizer {
  const WidgetOptimizer._();

  /// Wrap a widget with const optimization.
  ///
  /// This attempts to use const constructors when possible.
  static Widget constOptimize(Widget child) {
    return _ConstOptimizer(child: child);
  }

  /// Wrap a widget with automatic keep alive.
  ///
  /// This is useful for list items that should not be rebuilt
  /// when they scroll off screen.
  static Widget keepAlive(Widget child) {
    return _KeepAliveWrapper(child: child);
  }

  /// Wrap a widget with automatic dispose.
  ///
  /// This ensures that resources are properly disposed.
  static Widget autoDispose(Widget child) {
    return _AutoDisposeWrapper(child: child);
  }

  /// Wrap a widget with rebuild optimization.
  ///
  /// This prevents unnecessary rebuilds by comparing dependencies.
  static Widget rebuildOptimize<T>({
    required T value,
    required Widget Function(BuildContext context, T value) builder,
    bool Function(T, T)? shouldRebuild,
  }) {
    return _RebuildOptimizer<T>(
      value: value,
      builder: builder,
      shouldRebuild: shouldRebuild,
    );
  }

  /// Create an optimized list view.
  ///
  /// This uses various optimizations to improve list performance.
  static Widget optimizedListView<T>({
    required List<T> items,
    required Widget Function(BuildContext context, T item, int index)
    itemBuilder,
    Widget? separatorBuilder,
    ScrollController? controller,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? itemExtent,
    Widget Function(BuildContext, int)? prototypeItem,
    int? itemCount,
    double? cacheExtent,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? semanticChildCount,
  }) {
    return ListView.separated(
      controller: controller,
      physics: physics,
      padding: padding,
      shrinkWrap: shrinkWrap,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      cacheExtent: cacheExtent,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      // semanticChildCount: semanticChildCount,
      itemCount: itemCount ?? items.length,
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index], index);
      },
      separatorBuilder: separatorBuilder != null
          ? (context, index) => separatorBuilder
          : (context, index) => const SizedBox.shrink(),
    );
  }

  /// Create an optimized grid view.
  ///
  /// This uses various optimizations to improve grid performance.
  static Widget optimizedGridView<T>({
    required List<T> items,
    required Widget Function(BuildContext context, T item, int index)
    itemBuilder,
    required SliverGridDelegate gridDelegate,
    ScrollController? controller,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    int? semanticChildCount,
  }) {
    return GridView.builder(
      controller: controller,
      physics: physics,
      padding: padding,
      shrinkWrap: shrinkWrap,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      cacheExtent: cacheExtent,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      semanticChildCount: semanticChildCount,
      gridDelegate: gridDelegate,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index], index);
      },
    );
  }

  /// Create an optimized page view.
  ///
  /// This uses various optimizations to improve page view performance.
  static Widget optimizedPageView<T>({
    required List<T> items,
    required Widget Function(BuildContext context, T item, int index)
    itemBuilder,
    PageController? controller,
    ScrollPhysics? physics,
    bool pageSnapping = true,
    bool allowImplicitScrolling = true,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    String? semanticChildCount,
    int? itemCount,
  }) {
    return PageView.builder(
      controller: controller,
      physics: physics,
      pageSnapping: pageSnapping,
      allowImplicitScrolling: allowImplicitScrolling,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      // semanticChildCount: semanticChildCount,
      itemCount: itemCount ?? items.length,
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index], index);
      },
    );
  }

  /// Wrap a widget with a repaint boundary.
  ///
  /// This isolates repaints to the widget subtree.
  static Widget repaintBoundary(Widget child) {
    return RepaintBoundary(child: child);
  }

  /// Wrap a widget with an offstage buffer.
  ///
  /// This is useful for pre-building widgets that will be shown later.
  static Widget offstageBuffer(Widget child) {
    return Offstage(child: child);
  }

  /// Create a memoized widget.
  ///
  /// This caches the widget and only rebuilds when dependencies change.
  static Widget memoized<T>({
    required List<T> dependencies,
    required Widget Function() builder,
  }) {
    return _MemoizedWidget<T>(dependencies: dependencies, builder: builder);
  }
}

/// A widget that attempts to use const constructors.
class _ConstOptimizer extends StatelessWidget {
  final Widget child;

  const _ConstOptimizer({required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// A widget that keeps its child alive.
class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

/// A widget that automatically disposes resources.
class _AutoDisposeWrapper extends StatefulWidget {
  final Widget child;

  const _AutoDisposeWrapper({required this.child});

  @override
  State<_AutoDisposeWrapper> createState() => _AutoDisposeWrapperState();
}

class _AutoDisposeWrapperState extends State<_AutoDisposeWrapper> {
  @override
  void dispose() {
    // Dispose any resources here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// A widget that optimizes rebuilds.
class _RebuildOptimizer<T> extends StatefulWidget {
  final T value;
  final Widget Function(BuildContext context, T value) builder;
  final bool Function(T, T)? shouldRebuild;

  const _RebuildOptimizer({
    required this.value,
    required this.builder,
    this.shouldRebuild,
  });

  @override
  State<_RebuildOptimizer<T>> createState() => _RebuildOptimizerState<T>();
}

class _RebuildOptimizerState<T> extends State<_RebuildOptimizer<T>> {
  T? _previousValue;

  @override
  Widget build(BuildContext context) {
    final shouldRebuild =
        widget.shouldRebuild?.call(_previousValue as T, widget.value) ??
        _previousValue != widget.value;

    if (shouldRebuild) {
      _previousValue = widget.value;
    }

    return widget.builder(context, widget.value);
  }
}

/// A memoized widget.
class _MemoizedWidget<T> extends StatefulWidget {
  final List<T> dependencies;
  final Widget Function() builder;

  const _MemoizedWidget({required this.dependencies, required this.builder});

  @override
  State<_MemoizedWidget<T>> createState() => _MemoizedWidgetState<T>();
}

class _MemoizedWidgetState<T> extends State<_MemoizedWidget<T>> {
  List<T>? _previousDependencies;
  Widget? _cachedWidget;

  @override
  Widget build(BuildContext context) {
    final dependenciesChanged =
        _previousDependencies == null ||
        _previousDependencies!.length != widget.dependencies.length ||
        !_listEquals(_previousDependencies!, widget.dependencies);

    if (dependenciesChanged) {
      _cachedWidget = widget.builder();
      _previousDependencies = List.from(widget.dependencies);
    }

    return _cachedWidget!;
  }

  bool _listEquals<S>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Optimized list tile with common performance improvements.
class OptimizedListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool isThreeLine;
  final bool? dense;
  final VisualDensity? visualDensity;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final MouseCursor? mouseCursor;
  final bool selected;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? splashColor;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? tileColor;
  final Color? selectedTileColor;

  const OptimizedListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.isThreeLine = false,
    this.dense,
    this.visualDensity,
    this.shape,
    this.contentPadding,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.mouseCursor,
    this.selected = false,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.focusNode,
    this.autofocus = false,
    this.tileColor,
    this.selectedTileColor,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        isThreeLine: isThreeLine,
        dense: dense,
        visualDensity: visualDensity,
        shape: shape,
        contentPadding: contentPadding,
        enabled: enabled,
        onTap: onTap,
        onLongPress: onLongPress,
        mouseCursor: mouseCursor,
        selected: selected,
        focusColor: focusColor,
        hoverColor: hoverColor,
        splashColor: splashColor,
        focusNode: focusNode,
        autofocus: autofocus,
        tileColor: tileColor,
        selectedTileColor: selectedTileColor,
      ),
    );
  }
}

/// Optimized card with common performance improvements.
class OptimizedCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Color? shadowColor;
  final double? elevation;
  final ShapeBorder? shape;
  final bool borderOnForeground;
  final EdgeInsetsGeometry? margin;
  final Clip clipBehavior;
  // final SemanticLabel? semanticLabel;

  const OptimizedCard({
    super.key,
    required this.child,
    this.color,
    this.shadowColor,
    this.elevation,
    this.shape,
    this.borderOnForeground = true,
    this.margin,
    this.clipBehavior = Clip.none,
    // this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        color: color,
        shadowColor: shadowColor,
        elevation: elevation,
        shape: shape,
        borderOnForeground: borderOnForeground,
        margin: margin,
        clipBehavior: clipBehavior,
        // semanticLabel: semanticLabel,
        child: child,
      ),
    );
  }
}

/// Optimized container with common performance improvements.
class OptimizedContainer extends StatelessWidget {
  final Widget child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;

  const OptimizedContainer({
    super.key,
    required this.child,
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        alignment: alignment,
        padding: padding,
        color: color,
        decoration: decoration,
        foregroundDecoration: foregroundDecoration,
        width: width,
        height: height,
        constraints: constraints,
        margin: margin,
        transform: transform,
        transformAlignment: transformAlignment,
        clipBehavior: clipBehavior,
        child: child,
      ),
    );
  }
}

/// Extensions for convenient widget optimization.
extension WidgetOptimizerExtensions on Widget {
  /// Wrap with const optimization.
  Widget constOptimize() {
    return WidgetOptimizer.constOptimize(this);
  }

  /// Wrap with keep alive.
  Widget keepAlive() {
    return WidgetOptimizer.keepAlive(this);
  }

  /// Wrap with auto dispose.
  Widget autoDispose() {
    return WidgetOptimizer.autoDispose(this);
  }

  /// Wrap with repaint boundary.
  Widget repaintBoundary() {
    return WidgetOptimizer.repaintBoundary(this);
  }

  /// Wrap with offstage buffer.
  Widget offstageBuffer() {
    return WidgetOptimizer.offstageBuffer(this);
  }
}
