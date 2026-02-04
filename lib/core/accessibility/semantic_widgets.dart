// lib/core/accessibility/semantic_widgets.dart
/// Semantic widgets for accessibility support.
///
/// Provides widgets with proper semantics for screen readers and assistive technologies.
library;

import 'package:flutter/material.dart';

/// A button with proper semantics for accessibility.
///
/// Wraps content with appropriate semantic labels and hints.
class SemanticButton extends StatelessWidget {
  /// The child widget (usually icon or text).
  final Widget child;

  /// The semantic label read by screen readers.
  final String label;

  /// Optional hint describing the action.
  final String? hint;

  /// Whether the button is currently enabled.
  final bool enabled;

  /// Callback when pressed.
  final VoidCallback? onPressed;

  /// Optional callback for long press.
  final VoidCallback? onLongPress;

  const SemanticButton({
    super.key,
    required this.child,
    required this.label,
    this.hint,
    this.enabled = true,
    this.onPressed,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      hint: hint,
      excludeSemantics: true,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        onLongPress: enabled ? onLongPress : null,
        child: Opacity(opacity: enabled ? 1.0 : 0.5, child: child),
      ),
    );
  }
}

/// An image with proper semantics for accessibility.
class SemanticImage extends StatelessWidget {
  /// The image to display.
  final ImageProvider image;

  /// The semantic description of the image.
  /// If the image is purely decorative, set to empty string.
  final String description;

  /// Whether this is a decorative image (ignored by screen readers).
  final bool isDecorative;

  /// Widget to show while loading.
  final Widget? placeholder;

  /// Widget to show on error.
  final Widget? errorWidget;

  /// Image fit mode.
  final BoxFit? fit;

  /// Image width.
  final double? width;

  /// Image height.
  final double? height;

  const SemanticImage({
    super.key,
    required this.image,
    required this.description,
    this.isDecorative = false,
    this.placeholder,
    this.errorWidget,
    this.fit,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = Image(
      image: image,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? const Icon(Icons.error_outline);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ?? const CircularProgressIndicator();
      },
    );

    if (isDecorative) {
      return Semantics(container: true, excludeSemantics: true, child: imageWidget);
    }

    return Semantics(image: true, label: description, child: imageWidget);
  }
}

/// A text field with proper semantics and labels.
class SemanticTextField extends StatelessWidget {
  /// Controller for the text field.
  final TextEditingController? controller;

  /// The semantic label (used if no labelText).
  final String? semanticLabel;

  /// Visible label above the field.
  final String? labelText;

  /// Hint text shown when empty.
  final String? hintText;

  /// Helper text shown below the field.
  final String? helperText;

  /// Error text shown below the field.
  final String? errorText;

  /// Prefix icon.
  final Widget? prefixIcon;

  /// Suffix icon.
  final Widget? suffixIcon;

  /// Whether the field is obscured (for passwords).
  final bool obscureText;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether the field is read-only.
  final bool readOnly;

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

  /// Autofill hints.
  final Iterable<String>? autofillHints;

  const SemanticTextField({
    super.key,
    this.controller,
    this.semanticLabel,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: semanticLabel ?? labelText,
      hint: hintText,
      value: controller?.text,
      enabled: enabled,
      readOnly: readOnly,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          helperText: helperText,
          errorText: errorText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
        obscureText: obscureText,
        enabled: enabled,
        readOnly: readOnly,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        focusNode: focusNode,
        autofillHints: autofillHints,
      ),
    );
  }
}

/// A heading widget with proper semantics for screen readers.
class SemanticHeading extends StatelessWidget {
  /// The heading text.
  final String text;

  /// The heading level (1-6).
  final int level;

  /// Optional text style override.
  final TextStyle? style;

  /// Text alignment.
  final TextAlign? textAlign;

  const SemanticHeading({
    super.key,
    required this.text,
    required this.level,
    this.style,
    this.textAlign,
  }) : assert(level >= 1 && level <= 6, 'Heading level must be between 1 and 6');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = switch (level) {
      1 => theme.textTheme.displayLarge,
      2 => theme.textTheme.displayMedium,
      3 => theme.textTheme.displaySmall,
      4 => theme.textTheme.headlineMedium,
      5 => theme.textTheme.headlineSmall,
      6 => theme.textTheme.titleLarge,
      _ => theme.textTheme.displayLarge,
    };

    return Semantics(
      header: true,
      textDirection: TextDirection.ltr,
      child: Text(text, style: style ?? defaultStyle, textAlign: textAlign),
    );
  }
}

/// A list item with proper semantics for accessibility.
class SemanticListItem extends StatelessWidget {
  /// The child content.
  final Widget child;

  /// Semantic label for the item.
  final String? label;

  /// Whether the item is selected.
  final bool isSelected;

  /// Index of the item in the list.
  final int? index;

  /// Total number of items in the list.
  final int? total;

  /// Callback when tapped.
  final VoidCallback? onTap;

  const SemanticListItem({
    super.key,
    required this.child,
    this.label,
    this.isSelected = false,
    this.index,
    this.total,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String? indexHint;
    if (index != null && total != null) {
      indexHint = 'Item ${index! + 1} of $total';
    }

    return Semantics(
      button: onTap != null,
      selected: isSelected,
      label: label,
      hint: indexHint,
      child: InkWell(onTap: onTap, child: child),
    );
  }
}

/// A live region that announces changes to screen readers.
class SemanticLiveRegion extends StatelessWidget {
  /// The content that may change.
  final Widget child;

  /// The current value to announce when it changes.
  final String? value;

  /// Whether changes should be announced assertively.
  final bool isAssertive;

  const SemanticLiveRegion({super.key, required this.child, this.value, this.isAssertive = false});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: value,
      // assertiveness: isAssertive ? Assertiveness.assertive : Assertiveness.polite,
      child: child,
    );
  }
}

/// A card with proper semantics for accessibility.
class SemanticCard extends StatelessWidget {
  /// The card content.
  final Widget child;

  /// Semantic label for the card.
  final String? label;

  /// Optional description.
  final String? description;

  /// Callback when tapped.
  final VoidCallback? onTap;

  const SemanticCard({super.key, required this.child, this.label, this.description, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: label,
      value: description,
      button: onTap != null,
      child: Card(
        child: InkWell(onTap: onTap, child: child),
      ),
    );
  }
}

/// A checkbox with proper semantics.
class SemanticCheckbox extends StatelessWidget {
  /// Current value.
  final bool value;

  /// Callback when value changes.
  final ValueChanged<bool?>? onChanged;

  /// Semantic label.
  final String label;

  const SemanticCheckbox({super.key, required this.value, required this.label, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      // checkbox: true,
      checked: value,
      label: label,
      enabled: onChanged != null,
      child: CheckboxListTile(value: value, onChanged: onChanged, title: Text(label)),
    );
  }
}

/// A switch with proper semantics.
class SemanticSwitch extends StatelessWidget {
  /// Current value.
  final bool value;

  /// Callback when value changes.
  final ValueChanged<bool>? onChanged;

  /// Semantic label.
  final String label;

  const SemanticSwitch({super.key, required this.value, required this.label, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      // switchRole: true,
      checked: value,
      label: label,
      enabled: onChanged != null,
      child: SwitchListTile(value: value, onChanged: onChanged, title: Text(label)),
    );
  }
}

/// A radio button with proper semantics.
class SemanticRadio<T> extends StatelessWidget {
  /// Current value.
  final T value;

  /// Group value.
  final T? groupValue;

  /// Callback when value changes.
  final ValueChanged<T?>? onChanged;

  /// Semantic label.
  final String label;

  const SemanticRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.label,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      // radio: true,
      checked: value == groupValue,
      label: label,
      enabled: onChanged != null,
      child: RadioListTile<T>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        title: Text(label),
      ),
    );
  }
}

/// A slider with proper semantics.
class SemanticSlider extends StatelessWidget {
  /// Current value.
  final double value;

  /// Callback when value changes.
  final ValueChanged<double>? onChanged;

  /// Semantic label.
  final String label;

  /// Minimum value.
  final double min;

  /// Maximum value.
  final double max;

  /// Number of divisions.
  final int? divisions;

  const SemanticSlider({
    super.key,
    required this.value,
    required this.label,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      slider: true,
      value: value.toString(),
      label: label,
      enabled: onChanged != null,
      child: Slider(
        value: value,
        onChanged: onChanged,
        min: min,
        max: max,
        divisions: divisions,
        label: label,
      ),
    );
  }
}

/// A progress indicator with proper semantics.
class SemanticProgressIndicator extends StatelessWidget {
  /// Progress value (0.0 to 1.0).
  final double? value;

  /// Semantic label.
  final String? label;

  const SemanticProgressIndicator({super.key, this.value, this.label});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: value != null ? '${(value! * 100).toInt()}%' : null,
      label: label ?? 'Loading',
      child: value != null
          ? LinearProgressIndicator(value: value)
          : const CircularProgressIndicator(),
    );
  }
}

/// A tab with proper semantics.
class SemanticTab extends StatelessWidget {
  /// The tab content.
  final Widget child;

  /// Semantic label.
  final String label;

  /// Whether the tab is selected.
  final bool isSelected;

  const SemanticTab({super.key, required this.child, required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Semantics(selected: isSelected, label: label, button: true, child: child);
  }
}

/// A chip with proper semantics.
class SemanticChip extends StatelessWidget {
  /// The chip label.
  final String label;

  /// Whether the chip is selected.
  final bool isSelected;

  /// Callback when tapped.
  final VoidCallback? onDeleted;

  /// Callback when selected.
  final ValueChanged<bool>? onSelected;

  /// Avatar widget.
  final Widget? avatar;

  const SemanticChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onDeleted,
    this.onSelected,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onSelected != null,
      selected: isSelected,
      label: label,
      child: Chip(
        label: Text(label),
        // selected: isSelected,
        onDeleted: onDeleted,
        // onSelected: onSelected,
        avatar: avatar,
      ),
    );
  }
}
