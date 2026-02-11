// lib/shared/presentation/widgets/auth/phone_input_field.dart
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Figma-accurate phone input field with country code prefix.
///
/// Layout: [🇸🇦 +966 | _______________]
///
/// Features:
/// - Country flag + dial code prefix
/// - Divider separator
/// - Matches Figma input styling (8px radius, #F2F2F2 border)
class PhoneInputField extends StatelessWidget {
  const PhoneInputField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.textInputAction,
    this.countryCode = '+966',
    this.countryFlag = '🇸🇦',
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final TextInputAction? textInputAction;
  final String countryCode;
  final String countryFlag;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: AuthDesignConstants.fieldLabel),
          const SizedBox(height: 8),
        ],
        DecoratedBox(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: hasError ? AuthDesignConstants.error : AuthDesignConstants.inputBorder,
              ),
              borderRadius: BorderRadius.circular(AuthDesignConstants.inputBorderRadius),
            ),
          ),
          child: Row(
            children: [
              // Country code prefix
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(countryFlag, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 7),
                    Text(countryCode, style: AuthDesignConstants.countryCode),
                  ],
                ),
              ),
              // Divider
              Container(
                height: 24,
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: AuthDesignConstants.textTertiary.withValues(alpha: 0.3),
              ),
              // Phone number input
              Expanded(
                child: TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  enabled: enabled,
                  keyboardType: TextInputType.phone,
                  textInputAction: textInputAction ?? TextInputAction.next,
                  style: const TextStyle(
                    color: AuthDesignConstants.textSecondary,
                    fontSize: 11,
                    fontFamily: AuthDesignConstants.fontBody,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(15),
                  ],
                  decoration: InputDecoration(
                    hintText: hintText ?? '135 153 968 312 025',
                    hintStyle: AuthDesignConstants.fieldHint,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    isDense: true,
                  ),
                  onChanged: onChanged,
                  onFieldSubmitted: onSubmitted,
                ),
              ),
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: const TextStyle(
              color: AuthDesignConstants.error,
              fontSize: 11,
              fontFamily: AuthDesignConstants.fontBody,
            ),
          ),
        ],
      ],
    );
  }
}

/// Figma-accurate password input field with visibility toggle.
class AuthPasswordField extends StatelessWidget {
  const AuthPasswordField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.errorText,
    this.isVisible = false,
    this.onToggleVisibility,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;
  final String? errorText;
  final bool isVisible;
  final VoidCallback? onToggleVisibility;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: AuthDesignConstants.fieldLabel),
          const SizedBox(height: 8),
        ],
        DecoratedBox(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: hasError ? AuthDesignConstants.error : AuthDesignConstants.inputBorder,
              ),
              borderRadius: BorderRadius.circular(AuthDesignConstants.inputBorderRadius),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  enabled: enabled,
                  obscureText: !isVisible,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: textInputAction ?? TextInputAction.done,
                  style: const TextStyle(
                    color: AuthDesignConstants.textSecondary,
                    fontSize: 11,
                    fontFamily: AuthDesignConstants.fontBody,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText ?? 'Enter your password',
                    hintStyle: AuthDesignConstants.fieldHint,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                    isDense: true,
                  ),
                  onChanged: onChanged,
                  onFieldSubmitted: onSubmitted,
                ),
              ),
              IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: AuthDesignConstants.textTertiary,
                  size: 18,
                ),
                onPressed: onToggleVisibility,
                padding: const EdgeInsets.only(right: 4),
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: const TextStyle(
              color: AuthDesignConstants.error,
              fontSize: 11,
              fontFamily: AuthDesignConstants.fontBody,
            ),
          ),
        ],
      ],
    );
  }
}

/// Figma-accurate generic text input field for auth forms (name, email, etc.)
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.textInputAction,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLength,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: AuthDesignConstants.fieldLabel),
          const SizedBox(height: 8),
        ],
        DecoratedBox(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: hasError ? AuthDesignConstants.error : AuthDesignConstants.inputBorder,
              ),
              borderRadius: BorderRadius.circular(AuthDesignConstants.inputBorderRadius),
            ),
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            keyboardType: keyboardType ?? TextInputType.text,
            textInputAction: textInputAction ?? TextInputAction.next,
            textCapitalization: textCapitalization,
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            style: const TextStyle(
              color: AuthDesignConstants.textSecondary,
              fontSize: 11,
              fontFamily: AuthDesignConstants.fontBody,
              fontWeight: FontWeight.w400,
              height: 1.25,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AuthDesignConstants.fieldHint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
              isDense: true,
              counterText: '',
            ),
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: const TextStyle(
              color: AuthDesignConstants.error,
              fontSize: 11,
              fontFamily: AuthDesignConstants.fontBody,
            ),
          ),
        ],
      ],
    );
  }
}
