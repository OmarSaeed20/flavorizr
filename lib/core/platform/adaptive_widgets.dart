// lib/core/platform/adaptive_widgets.dart
/// Adaptive widgets that adapt to the current platform.
///
/// Provides widgets that automatically use the appropriate style
/// for iOS, Android, Web, and Desktop platforms.
library;

import 'package:fast_golden_taxi/core/platform/platform_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// An adaptive button that uses the appropriate style for the platform.
class AdaptiveButton extends StatelessWidget {
  /// Button text.
  final String text;

  /// Callback when pressed.
  final VoidCallback? onPressed;

  /// Whether this is a primary/filled button.
  final bool isPrimary;

  /// Whether this is a destructive action.
  final bool isDestructive;

  /// Optional leading icon.
  final IconData? icon;

  const AdaptiveButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformService.usesCupertinoDesign) {
      return _buildCupertinoButton(context);
    }
    return _buildMaterialButton(context);
  }

  Widget _buildCupertinoButton(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    Color? color;

    if (isDestructive) {
      color = CupertinoColors.systemRed;
    } else if (isPrimary) {
      color = theme.primaryColor;
    }

    return CupertinoButton(
      onPressed: onPressed,
      color: isPrimary ? color : null,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: _buildChild(isIOS: true),
    );
  }

  Widget _buildMaterialButton(BuildContext context) {
    if (isPrimary) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDestructive ? Theme.of(context).colorScheme.error : null,
          foregroundColor: isDestructive ? Theme.of(context).colorScheme.onError : null,
        ),
        child: _buildChild(isIOS: false),
      );
    }

    if (isDestructive) {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
        child: _buildChild(isIOS: false),
      );
    }

    return TextButton(onPressed: onPressed, child: _buildChild(isIOS: false));
  }

  Widget _buildChild({required bool isIOS}) {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isIOS ? 18 : 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }
    return Text(text);
  }
}

/// An adaptive dialog that uses the platform-specific style.
class AdaptiveDialog {
  /// Shows a platform-adaptive alert dialog.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? content,
    required List<AdaptiveDialogAction> actions,
  }) {
    if (PlatformService.usesCupertinoDesign) {
      return showCupertinoDialog<T>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: content != null ? Text(content) : null,
          actions: actions
              .map(
                (action) => CupertinoDialogAction(
                  onPressed: () {
                    action.onPressed?.call();
                    Navigator.of(context).pop(action.value);
                  },
                  isDefaultAction: action.isDefault,
                  isDestructiveAction: action.isDestructive,
                  child: Text(action.text),
                ),
              )
              .toList(),
        ),
      );
    }

    return showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content != null ? Text(content) : null,
        actions: actions
            .map(
              (action) => TextButton(
                onPressed: () {
                  action.onPressed?.call();
                  Navigator.of(context).pop(action.value);
                },
                style: TextButton.styleFrom(
                  foregroundColor: action.isDestructive
                      ? Theme.of(context).colorScheme.error
                      : null,
                ),
                child: Text(action.text),
              ),
            )
            .toList(),
      ),
    );
  }

  /// Shows a platform-adaptive confirmation dialog.
  static Future<bool> confirm({
    required BuildContext context,
    required String title,
    String? content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) async {
    final result = await show<bool>(
      context: context,
      title: title,
      content: content,
      actions: [
        AdaptiveDialogAction(text: cancelText, value: false),
        AdaptiveDialogAction(
          text: confirmText,
          value: true,
          isDefault: true,
          isDestructive: isDestructive,
        ),
      ],
    );

    return result ?? false;
  }

  /// Shows a platform-adaptive alert dialog.
  static Future<void> alert({
    required BuildContext context,
    required String title,
    String? content,
    String buttonText = 'OK',
  }) async {
    await show<void>(
      context: context,
      title: title,
      content: content,
      actions: [AdaptiveDialogAction(text: buttonText, isDefault: true)],
    );
  }

  /// Shows a platform-adaptive input dialog.
  static Future<String?> input({
    required BuildContext context,
    required String title,
    String? hint,
    String? initialValue,
    String confirmText = 'OK',
    String cancelText = 'Cancel',
    bool obscureText = false,
  }) async {
    final controller = TextEditingController(text: initialValue);

    if (PlatformService.usesCupertinoDesign) {
      return showCupertinoDialog<String>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: CupertinoTextField(
              controller: controller,
              placeholder: hint,
              obscureText: obscureText,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(cancelText),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(confirmText),
              onPressed: () => Navigator.of(context).pop(controller.text),
            ),
          ],
        ),
      );
    }

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: hint),
          obscureText: obscureText,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(cancelText)),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result;
  }
}

/// An action for adaptive dialogs.
class AdaptiveDialogAction<T> {
  /// Action text.
  final String text;

  /// Value to return when selected.
  final T? value;

  /// Whether this is the default action.
  final bool isDefault;

  /// Whether this is a destructive action.
  final bool isDestructive;

  /// Callback when pressed.
  final VoidCallback? onPressed;

  const AdaptiveDialogAction({
    required this.text,
    this.value,
    this.isDefault = false,
    this.isDestructive = false,
    this.onPressed,
  });
}

/// An adaptive loading indicator.
class AdaptiveLoadingIndicator extends StatelessWidget {
  /// Size of the indicator.
  final double size;

  /// Color of the indicator.
  final Color? color;

  const AdaptiveLoadingIndicator({super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    if (PlatformService.usesCupertinoDesign) {
      return CupertinoActivityIndicator(radius: size / 2, color: color);
    }

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: color != null ? AlwaysStoppedAnimation<Color>(color!) : null,
      ),
    );
  }
}

/// An adaptive switch.
class AdaptiveSwitch extends StatelessWidget {
  /// Current value.
  final bool value;

  /// Callback when value changes.
  final ValueChanged<bool>? onChanged;

  /// Active color.
  final Color? activeColor;

  const AdaptiveSwitch({super.key, required this.value, this.onChanged, this.activeColor});

  @override
  Widget build(BuildContext context) {
    if (PlatformService.usesCupertinoDesign) {
      return CupertinoSwitch(value: value, onChanged: onChanged, activeTrackColor: activeColor);
    }

    return Switch(value: value, onChanged: onChanged, activeThumbColor: activeColor);
  }
}

/// An adaptive slider.
class AdaptiveSlider extends StatelessWidget {
  /// Current value.
  final double value;

  /// Callback when value changes.
  final ValueChanged<double>? onChanged;

  /// Minimum value.
  final double min;

  /// Maximum value.
  final double max;

  /// Number of divisions.
  final int? divisions;

  /// Active color.
  final Color? activeColor;

  const AdaptiveSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformService.usesCupertinoDesign) {
      return CupertinoSlider(
        value: value,
        onChanged: onChanged,
        min: min,
        max: max,
        divisions: divisions,
        activeColor: activeColor,
      );
    }

    return Slider(
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
      divisions: divisions,
      activeColor: activeColor,
    );
  }
}

/// An adaptive progress indicator.
class AdaptiveProgressIndicator extends StatelessWidget {
  /// Progress value (0.0 to 1.0).
  final double? value;

  /// Color of the indicator.
  final Color? color;

  const AdaptiveProgressIndicator({super.key, this.value, this.color});

  @override
  Widget build(BuildContext context) {
    if (PlatformService.usesCupertinoDesign) {
      // if (value != null) {
      //   return CupertinoProgressIndicator(
      //     value: value,
      //     color: color,
      //   );
      // }
      return const CupertinoActivityIndicator();
    }

    if (value != null) {
      return LinearProgressIndicator(value: value, color: color);
    }

    return CircularProgressIndicator.adaptive(
      valueColor: color != null ? AlwaysStoppedAnimation<Color>(color!) : null,
    );
  }
}

/// An adaptive checkbox.
class AdaptiveCheckbox extends StatelessWidget {
  /// Current value.
  final bool value;

  /// Callback when value changes.
  final ValueChanged<bool?>? onChanged;

  /// Active color.
  final Color? activeColor;

  const AdaptiveCheckbox({super.key, required this.value, this.onChanged, this.activeColor});

  @override
  Widget build(BuildContext context) {
    if (PlatformService.usesCupertinoDesign) {
      return CupertinoCheckbox(value: value, onChanged: onChanged, activeColor: activeColor);
    }

    return Checkbox(
      value: value,
      onChanged: (newValue) => onChanged?.call(newValue ?? false),
      activeColor: activeColor,
    );
  }
}

/// An adaptive radio button.
class AdaptiveRadio<T> extends StatelessWidget {
  /// Current value.
  final T value;

  /// Group value.
  final T? groupValue;

  /// Callback when value changes.
  final ValueChanged<T?>? onChanged;

  /// Active color.
  final Color? activeColor;

  const AdaptiveRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformService.usesCupertinoDesign) {
      return CupertinoRadio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: activeColor,
      );
    }

    return Radio<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: activeColor,
    );
  }
}

/// An adaptive segmented control.
class AdaptiveSegmentedControl<T> extends StatelessWidget {
  /// Current selected value.
  final T? groupValue;

  /// Callback when value changes.
  final ValueChanged<T> onValueChanged;

  /// Map of values to their labels.
  final Map<T, Widget> children;

  const AdaptiveSegmentedControl({
    super.key,
    required this.groupValue,
    required this.onValueChanged,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    // if (PlatformService.usesCupertinoDesign) {
    //   return CupertinoSegmentedControl<T>(
    //     groupValue: groupValue,
    //     onValueChanged: onValueChanged,
    //     children: children,
    //   );
    // }

    return SegmentedButton<T>(
      segments: children.entries
          .map((entry) => ButtonSegment(value: entry.key, label: entry.value))
          .toList(),
      selected: groupValue != null ? {groupValue as T} : {},
      onSelectionChanged: (Set<T> newSelection) {
        if (newSelection.isNotEmpty) {
          onValueChanged.call(newSelection.first);
        }
      },
    );
  }
}

/// An adaptive app bar that adapts to the platform.
class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Title widget or text.
  final Widget? title;

  /// Leading widget.
  final Widget? leading;

  /// Actions.
  final List<Widget>? actions;

  /// Whether to automatically add back button.
  final bool automaticallyImplyLeading;

  /// Background color.
  final Color? backgroundColor;

  /// Whether the app bar is transparent.
  final bool transparent;

  /// Elevation.
  final double? elevation;

  /// Center title.
  final bool? centerTitle;

  const AdaptiveAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.transparent = false,
    this.elevation,
    this.centerTitle,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformService.usesCupertinoDesign) {
      return CupertinoNavigationBar(
        middle: title,
        leading: leading,
        trailing: actions != null && actions!.isNotEmpty
            ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
            : null,
        backgroundColor: transparent ? Colors.transparent : backgroundColor,
        border: transparent ? const Border() : null,
      );
    }

    return AppBar(
      title: title,
      leading: leading,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: transparent ? Colors.transparent : backgroundColor,
      elevation: transparent ? 0 : elevation,
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// An adaptive scaffold that adapts to the platform.
class AdaptiveScaffold extends StatelessWidget {
  /// App bar.
  final PreferredSizeWidget? appBar;

  /// Body content.
  final Widget body;

  /// Bottom navigation bar.
  final Widget? bottomNavigationBar;

  /// Floating action button.
  final Widget? floatingActionButton;

  /// Drawer.
  final Widget? drawer;

  /// End drawer.
  final Widget? endDrawer;

  /// Whether to use safe area.
  final bool safeArea;

  const AdaptiveScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.drawer,
    this.endDrawer,
    this.safeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
      endDrawer: endDrawer,
    );

    if (safeArea) {
      return SafeArea(child: content);
    }

    return content;
  }
}

/// An adaptive bottom sheet.
class AdaptiveBottomSheet {
  /// Shows a platform-adaptive bottom sheet.
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
  }) {
    if (PlatformService.usesCupertinoDesign) {
      return showCupertinoModalPopup<T>(context: context, builder: builder);
    }

    return showModalBottomSheet<T>(
      context: context,
      // builder: builder,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) => DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: builder(context),
      ),
    );
  }
}

/// An adaptive list tile.
class AdaptiveListTile extends StatelessWidget {
  /// Leading widget.
  final Widget? leading;

  /// Title widget.
  final Widget? title;

  /// Subtitle widget.
  final Widget? subtitle;

  /// Trailing widget.
  final Widget? trailing;

  /// Callback when tapped.
  final VoidCallback? onTap;

  /// Callback when long pressed.
  final VoidCallback? onLongPress;

  /// Whether the tile is selected.
  final bool selected;

  const AdaptiveListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformService.usesCupertinoDesign) {
      return CupertinoListTile(
        leading: leading,
        title: title ?? const SizedBox.shrink(),
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
        backgroundColor: selected ? CupertinoColors.systemGrey6.resolveFrom(context) : null,
      );
    }

    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      onLongPress: onLongPress,
      selected: selected,
    );
  }
}

/// An adaptive divider.
class AdaptiveDivider extends StatelessWidget {
  /// Height of the divider.
  final double? height;

  /// Thickness of the divider.
  final double? thickness;

  /// Color of the divider.
  final Color? color;

  const AdaptiveDivider({super.key, this.height, this.thickness, this.color});

  @override
  Widget build(BuildContext context) {
    if (PlatformService.usesCupertinoDesign) {
      return Container(
        height: height ?? 0.5,
        color: color ?? CupertinoColors.separator.resolveFrom(context),
      );
    }

    return Divider(height: height, thickness: thickness, color: color);
  }
}

/// An adaptive icon button.
class AdaptiveIconButton extends StatelessWidget {
  /// Icon to display.
  final IconData icon;

  /// Callback when pressed.
  final VoidCallback? onPressed;

  /// Icon size.
  final double? iconSize;

  /// Color of the icon.
  final Color? color;

  /// Tooltip text.
  final String? tooltip;

  const AdaptiveIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconSize,
    this.color,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformService.usesCupertinoDesign) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Icon(icon, size: iconSize, color: color),
      );
    }

    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      iconSize: iconSize,
      color: color,
      tooltip: tooltip,
    );
  }
}

/// An adaptive text field.
class AdaptiveTextField extends StatelessWidget {
  /// Controller for the text field.
  final TextEditingController? controller;

  /// Label text.
  final String? labelText;

  /// Hint text.
  final String? hintText;

  /// Prefix icon.
  final Widget? prefixIcon;

  /// Suffix icon.
  final Widget? suffixIcon;

  /// Whether the field is obscured.
  final bool obscureText;

  /// Whether the field is enabled.
  final bool enabled;

  /// Keyboard type.
  final TextInputType? keyboardType;

  /// Input action.
  final TextInputAction? textInputAction;

  /// Callback when text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when submitted.
  final ValueChanged<String>? onSubmitted;

  /// Focus node.
  final FocusNode? focusNode;

  const AdaptiveTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformService.usesCupertinoDesign) {
      return CupertinoTextField(
        controller: controller,
        placeholder: hintText,
        prefix: prefixIcon != null
            ? Padding(padding: const EdgeInsets.only(left: 8), child: prefixIcon)
            : null,
        suffix: suffixIcon != null
            ? Padding(padding: const EdgeInsets.only(right: 8), child: suffixIcon)
            : null,
        obscureText: obscureText,
        enabled: enabled,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        focusNode: focusNode,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6.resolveFrom(context),
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
    );
  }
}

/// An adaptive card.
class AdaptiveCard extends StatelessWidget {
  /// Child content.
  final Widget child;

  /// Callback when tapped.
  final VoidCallback? onTap;

  /// Elevation.
  final double? elevation;

  /// Margin.
  final EdgeInsetsGeometry? margin;

  const AdaptiveCard({super.key, required this.child, this.onTap, this.elevation, this.margin});

  @override
  Widget build(BuildContext context) {
    if (PlatformService.usesCupertinoDesign) {
      return Container(
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey4.resolveFrom(context),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: onTap != null
            ? CupertinoButton(onPressed: onTap, padding: EdgeInsets.zero, child: child)
            : child,
      );
    }

    return Card(
      elevation: elevation,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: onTap != null ? InkWell(onTap: onTap, child: child) : child,
    );
  }
}

/// An adaptive snackbar.
class AdaptiveSnackbar {
  /// Shows a platform-adaptive snackbar.
  static void show({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    if (PlatformService.usesCupertinoDesign) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), duration: duration, action: action));
  }
}

/// An adaptive refresh indicator.
class AdaptiveRefreshIndicator extends StatelessWidget {
  /// Child content.
  final Widget child;

  /// Callback when refreshed.
  final Future<void> Function() onRefresh;

  const AdaptiveRefreshIndicator({super.key, required this.child, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    // if (PlatformService.usesCupertinoDesign) {
    //   return CustomScrollView(
    //     slivers: [
    //       CupertinoSliverRefreshControl(onRefresh: onRefresh),
    //       SliverToBoxAdapter(child: child),
    //     ],
    //   );
    // }

    return RefreshIndicator.adaptive(onRefresh: onRefresh, child: child);
  }
}
