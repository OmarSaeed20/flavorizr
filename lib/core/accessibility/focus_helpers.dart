// lib/core/accessibility/focus_helpers.dart
/// Focus management helpers for accessibility.
///
/// Provides utilities for managing focus and keyboard navigation.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Manages focus for accessibility.
class FocusHelper {
  /// Requests focus on a specific node.
  static void requestFocus(FocusNode node) {
    node.requestFocus();
  }

  /// Moves focus to the next focusable element.
  static void nextFocus(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  /// Moves focus to the previous focusable element.
  static void previousFocus(BuildContext context) {
    FocusScope.of(context).previousFocus();
  }

  /// Removes focus from the current element.
  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Returns true if any element in the tree has focus.
  static bool hasFocus(BuildContext context) {
    return FocusScope.of(context).hasFocus;
  }

  /// Returns the currently focused node.
  static FocusNode? currentFocus(BuildContext context) {
    return FocusScope.of(context).focusedChild;
  }

  /// Sets the focus traversal policy.
  static void setTraversalPolicy(
    BuildContext context,
    FocusTraversalPolicy policy,
  ) {
    // FocusScope.of(context).traversalPolicy = policy;
  }

  /// Requests focus on the first focusable widget.
  static void requestFirstFocus(BuildContext context) {
    FocusScope.of(context).autofocus(FocusNode());
  }

  /// Requests focus on the nearest focusable widget.
  static void requestNearestFocus(BuildContext context) {
    FocusScope.of(context).nearestScope.requestFocus();
  }
}

/// A widget that can be focused and navigated with keyboard.
class FocusableItem extends StatefulWidget {
  /// The child content.
  final Widget child;

  /// Callback when focused.
  final VoidCallback? onFocused;

  /// Callback when focus is lost.
  final VoidCallback? onUnfocused;

  /// Callback when Enter/Space is pressed.
  final VoidCallback? onActivate;

  /// Whether to show a focus indicator.
  final bool showFocusIndicator;

  /// Custom focus indicator decoration.
  final BoxDecoration? focusDecoration;

  /// Focus node to use (creates one if not provided).
  final FocusNode? focusNode;

  /// Whether the item should be focusable.
  final bool canRequestFocus;

  /// Whether the item should be skipped in focus traversal.
  final bool skipTraversal;

  const FocusableItem({
    super.key,
    required this.child,
    this.onFocused,
    this.onUnfocused,
    this.onActivate,
    this.showFocusIndicator = true,
    this.focusDecoration,
    this.focusNode,
    this.canRequestFocus = true,
    this.skipTraversal = false,
  });

  @override
  State<FocusableItem> createState() => _FocusableItemState();
}

class _FocusableItemState extends State<FocusableItem> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    final wasFocused = _isFocused;
    _isFocused = _focusNode.hasFocus;

    if (_isFocused && !wasFocused) {
      widget.onFocused?.call();
    } else if (!_isFocused && wasFocused) {
      widget.onUnfocused?.call();
    }

    setState(() {});
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.space) {
        widget.onActivate?.call();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultFocusDecoration = BoxDecoration(
      border: Border.all(color: theme.colorScheme.primary, width: 2),
      borderRadius: BorderRadius.circular(4),
    );

    return Focus(
      focusNode: _focusNode,
      canRequestFocus: widget.canRequestFocus,
      skipTraversal: widget.skipTraversal,
      onKeyEvent: _handleKeyEvent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: widget.showFocusIndicator && _isFocused
            ? widget.focusDecoration ?? defaultFocusDecoration
            : null,
        child: widget.child,
      ),
    );
  }
}

/// A widget that traps focus within its bounds.
///
/// Useful for modals and dialogs to prevent focus from escaping.
class FocusTrap extends StatelessWidget {
  /// The child content.
  final Widget child;

  /// Whether the trap is active.
  final bool active;

  const FocusTrap({super.key, required this.child, this.active = true});

  @override
  Widget build(BuildContext context) {
    if (!active) return child;

    return FocusTraversalGroup(
      policy: ReadingOrderTraversalPolicy(),
      child: child,
    );
  }
}

/// A widget that manages focus scope.
class FocusScopeWrapper extends StatelessWidget {
  /// The child content.
  final Widget child;

  /// Whether to autofocus the first child.
  final bool autofocus;

  /// Callback when focus changes.
  final ValueChanged<bool>? onFocusChange;

  const FocusScopeWrapper({
    super.key,
    required this.child,
    this.autofocus = false,
    this.onFocusChange,
  });

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      autofocus: autofocus,
      onFocusChange: onFocusChange,
      child: child,
    );
  }
}

/// A widget that provides keyboard shortcuts.
class KeyboardShortcuts extends StatelessWidget {
  /// The child content.
  final Widget child;

  /// Map of key bindings to callbacks.
  final Map<SingleActivator, VoidCallback> bindings;

  const KeyboardShortcuts({
    super.key,
    required this.child,
    required this.bindings,
  });

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: bindings,
      child: Focus(autofocus: true, child: child),
    );
  }
}

/// A widget that handles tab navigation.
class TabNavigationHandler extends StatelessWidget {
  /// The child content.
  final Widget child;

  /// Callback when tab is pressed.
  final VoidCallback? onTab;

  /// Callback when shift+tab is pressed.
  final VoidCallback? onShiftTab;

  const TabNavigationHandler({
    super.key,
    required this.child,
    this.onTab,
    this.onShiftTab,
  });

  @override
  Widget build(BuildContext context) {
    return KeyboardShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.tab): () {
          if (onTab != null) {
            onTab!();
          } else {
            FocusHelper.nextFocus(context);
          }
        },
        const SingleActivator(LogicalKeyboardKey.tab, shift: true): () {
          if (onShiftTab != null) {
            onShiftTab!();
          } else {
            FocusHelper.previousFocus(context);
          }
        },
      },
      child: child,
    );
  }
}

/// A widget that handles escape key.
class EscapeHandler extends StatelessWidget {
  /// The child content.
  final Widget child;

  /// Callback when escape is pressed.
  final VoidCallback? onEscape;

  const EscapeHandler({super.key, required this.child, this.onEscape});

  @override
  Widget build(BuildContext context) {
    return KeyboardShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () {
          onEscape?.call();
        },
      },
      child: child,
    );
  }
}

/// A widget that handles enter key.
class EnterHandler extends StatelessWidget {
  /// The child content.
  final Widget child;

  /// Callback when enter is pressed.
  final VoidCallback? onEnter;

  const EnterHandler({super.key, required this.child, this.onEnter});

  @override
  Widget build(BuildContext context) {
    return KeyboardShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter): () {
          onEnter?.call();
        },
      },
      child: child,
    );
  }
}

/// A widget that handles space key.
class SpaceHandler extends StatelessWidget {
  /// The child content.
  final Widget child;

  /// Callback when space is pressed.
  final VoidCallback? onSpace;

  const SpaceHandler({super.key, required this.child, this.onSpace});

  @override
  Widget build(BuildContext context) {
    return KeyboardShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.space): () {
          onSpace?.call();
        },
      },
      child: child,
    );
  }
}

/// A widget that handles arrow keys.
class ArrowKeyHandler extends StatelessWidget {
  /// The child content.
  final Widget child;

  /// Callback when up arrow is pressed.
  final VoidCallback? onUp;

  /// Callback when down arrow is pressed.
  final VoidCallback? onDown;

  /// Callback when left arrow is pressed.
  final VoidCallback? onLeft;

  /// Callback when right arrow is pressed.
  final VoidCallback? onRight;

  const ArrowKeyHandler({
    super.key,
    required this.child,
    this.onUp,
    this.onDown,
    this.onLeft,
    this.onRight,
  });

  @override
  Widget build(BuildContext context) {
    return KeyboardShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowUp): () {
          onUp?.call();
        },
        const SingleActivator(LogicalKeyboardKey.arrowDown): () {
          onDown?.call();
        },
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
          onLeft?.call();
        },
        const SingleActivator(LogicalKeyboardKey.arrowRight): () {
          onRight?.call();
        },
      },
      child: child,
    );
  }
}

/// A widget that provides focus management for a list.
class ListFocusManager extends StatefulWidget {
  /// The list of items.
  final List<Widget> children;

  /// Callback when an item is selected.
  final ValueChanged<int>? onItemSelected;

  /// Initial focused index.
  final int initialIndex;

  const ListFocusManager({
    super.key,
    required this.children,
    this.onItemSelected,
    this.initialIndex = 0,
  });

  @override
  State<ListFocusManager> createState() => _ListFocusManagerState();
}

class _ListFocusManagerState extends State<ListFocusManager> {
  late int _focusedIndex;
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    _focusedIndex = widget.initialIndex;
    _focusNodes.addAll(
      List.generate(widget.children.length, (_) => FocusNode()),
    );
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        if (_focusedIndex < widget.children.length - 1) {
          setState(() {
            _focusedIndex++;
          });
          _focusNodes[_focusedIndex].requestFocus();
        }
        break;
      case LogicalKeyboardKey.arrowUp:
        if (_focusedIndex > 0) {
          setState(() {
            _focusedIndex--;
          });
          _focusNodes[_focusedIndex].requestFocus();
        }
        break;
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.space:
        widget.onItemSelected?.call(_focusedIndex);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: _handleKeyEvent,
      child: ListView.builder(
        itemCount: widget.children.length,
        itemBuilder: (context, index) {
          return Focus(
            focusNode: _focusNodes[index],
            child: widget.children[index],
          );
        },
      ),
    );
  }
}

/// A widget that provides focus management for a grid.
class GridFocusManager extends StatefulWidget {
  /// The grid of items.
  final List<List<Widget>> children;

  /// Callback when an item is selected.
  final ValueChanged<Offset>? onItemSelected;

  /// Initial focused position.
  final Offset initialPosition;

  const GridFocusManager({
    super.key,
    required this.children,
    this.onItemSelected,
    this.initialPosition = Offset.zero,
  });

  @override
  State<GridFocusManager> createState() => _GridFocusManagerState();
}

class _GridFocusManagerState extends State<GridFocusManager> {
  late Offset _focusedPosition;
  late List<List<FocusNode>> _focusNodes;

  @override
  void initState() {
    super.initState();
    _focusedPosition = widget.initialPosition;
    _focusNodes = widget.children.map((row) {
      return row.map((_) => FocusNode()).toList();
    }).toList();
  }

  @override
  void dispose() {
    for (final row in _focusNodes) {
      for (final node in row) {
        node.dispose();
      }
    }
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final row = _focusedPosition.dy.toInt();
    final col = _focusedPosition.dx.toInt();

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        if (row < widget.children.length - 1) {
          setState(() {
            _focusedPosition = Offset(col.toDouble(), row + 1.toDouble());
          });
          _focusNodes[row + 1][col].requestFocus();
        }
        break;
      case LogicalKeyboardKey.arrowUp:
        if (row > 0) {
          setState(() {
            _focusedPosition = Offset(col.toDouble(), row - 1.toDouble());
          });
          _focusNodes[row - 1][col].requestFocus();
        }
        break;
      case LogicalKeyboardKey.arrowRight:
        if (col < widget.children[row].length - 1) {
          setState(() {
            _focusedPosition = Offset(col + 1.toDouble(), row.toDouble());
          });
          _focusNodes[row][col + 1].requestFocus();
        }
        break;
      case LogicalKeyboardKey.arrowLeft:
        if (col > 0) {
          setState(() {
            _focusedPosition = Offset(col - 1.toDouble(), row.toDouble());
          });
          _focusNodes[row][col - 1].requestFocus();
        }
        break;
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.space:
        widget.onItemSelected?.call(_focusedPosition);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: _handleKeyEvent,
      child: Column(
        children: widget.children.asMap().entries.map((rowEntry) {
          return Row(
            children: rowEntry.value.asMap().entries.map((colEntry) {
              return Focus(
                focusNode: _focusNodes[rowEntry.key][colEntry.key],
                child: colEntry.value,
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
