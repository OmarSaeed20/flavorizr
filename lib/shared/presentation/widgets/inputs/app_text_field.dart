// lib/shared/presentation/widgets/inputs/app_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A customizable text field widget with consistent styling.
///
/// Features:
/// - Label and hint text
/// - Error message display
/// - Prefix and suffix icons
/// - Password visibility toggle
/// - Input formatters
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
  });

  /// Controller for the text field.
  final TextEditingController? controller;

  /// Focus node for the text field.
  final FocusNode? focusNode;

  /// Label text displayed above the field.
  final String? label;

  /// Hint text displayed inside the field.
  final String? hint;

  /// Error text displayed below the field.
  final String? errorText;

  /// Helper text displayed below the field.
  final String? helperText;

  /// Icon displayed at the start of the field.
  final Widget? prefixIcon;

  /// Icon displayed at the end of the field.
  final Widget? suffixIcon;

  /// The type of keyboard to use.
  final TextInputType? keyboardType;

  /// The action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// Whether to obscure the text (for passwords).
  final bool obscureText;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Maximum number of lines.
  final int maxLines;

  /// Minimum number of lines.
  final int? minLines;

  /// Maximum character length.
  final int? maxLength;

  /// Whether to autofocus the field.
  final bool autofocus;

  /// Whether to enable autocorrect.
  final bool autocorrect;

  /// Whether to enable suggestions.
  final bool enableSuggestions;

  /// Input formatters to apply.
  final List<TextInputFormatter>? inputFormatters;

  /// Callback when text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when the user submits.
  final ValueChanged<String>? onSubmitted;

  /// Callback when the field is tapped.
  final VoidCallback? onTap;

  /// Validator function for form validation.
  final FormFieldValidator<String>? validator;

  /// Text capitalization behavior.
  final TextCapitalization textCapitalization;

  /// Autofill hints for the field.
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          enabled: enabled,
          readOnly: readOnly,
          maxLines: obscureText ? 1 : maxLines,
          minLines: minLines,
          maxLength: maxLength,
          autofocus: autofocus,
          autocorrect: autocorrect,
          enableSuggestions: enableSuggestions,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          autofillHints: autofillHints,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          onTap: onTap,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            helperText: helperText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
            ),
            filled: true,
            fillColor: enabled
                ? theme.colorScheme.surface
                : theme.colorScheme.surfaceContainerHighest,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}

/// A password text field with visibility toggle.
class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.errorText,
    this.isVisible = false,
    this.onToggleVisibility,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.enabled = true,
    this.autofillHints,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool isVisible;
  final VoidCallback? onToggleVisibility;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final bool enabled;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      focusNode: focusNode,
      label: label,
      hint: hint ?? 'Enter password',
      errorText: errorText,
      obscureText: !isVisible,
      enabled: enabled,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
        onPressed: onToggleVisibility,
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}

/// An email text field with email-specific settings.
class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.enabled = true,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final bool enabled;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      focusNode: focusNode,
      label: label,
      hint: hint ?? 'Enter email',
      errorText: errorText,
      enabled: enabled,
      autofocus: autofocus,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction ?? TextInputAction.next,
      autocorrect: false,
      enableSuggestions: false,
      autofillHints: const [AutofillHints.email],
      prefixIcon: const Icon(Icons.email_outlined),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
