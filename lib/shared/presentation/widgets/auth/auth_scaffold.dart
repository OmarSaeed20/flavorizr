// lib/shared/presentation/widgets/auth/auth_scaffold.dart
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:flutter/material.dart';

/// A reusable scaffold for all auth screens following the Figma design pattern:
///
///  ┌─────────────────────────────┐
///  │  AppBar (optional back)     │  ← white background
///  ├─────────────────────────────┤
///  │                             │  ← background (#F2F2F2)
///  │      Logo Card              │  ← centered white card with logo
///  │                             │
///  ├─────────────────────────────┤
///  │  ╭───────────────────────╮  │  ← bottom sheet (rounded 24px)
///  │  │  Title                │  │
///  │  │  Subtitle             │  │
///  │  │  [Form Content]       │  │
///  │  │  [Action Buttons]     │  │
///  │  │  [Footer Links]       │  │
///  │  ╰───────────────────────╯  │
///  └─────────────────────────────┘
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.body,
    this.appBarTitle,
    this.showBackButton = true,
    this.backgroundColor,
    this.showLogoCard = true,
    this.logoWidget,
  });

  /// The main body content, typically a bottom sheet layout.
  final Widget body;

  /// Optional app bar title text.
  final String? appBarTitle;

  /// Whether to show the back navigation button.
  final bool showBackButton;

  /// Override background color (defaults to [AuthDesignConstants.background]).
  final Color? backgroundColor;

  /// Whether to show the logo card above the bottom sheet.
  final bool showLogoCard;

  /// Custom logo widget override.
  final Widget? logoWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AuthDesignConstants.background,
      appBar: (appBarTitle != null || showBackButton)
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: showBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      color: AuthDesignConstants.textSecondary,
                      onPressed: () => Navigator.of(context).maybePop(),
                    )
                  : null,
              title: appBarTitle != null
                  ? Text(appBarTitle!, style: AuthDesignConstants.appBarTitle)
                  : null,
              centerTitle: false,
            )
          : null,
      body: body,
    );
  }
}

/// The white logo card used on most auth screens (Login, Signup, etc.).
///
/// Matches Figma: 295 wide, 24px radius, card shadow, contains logo image
/// and "Fast Taxi" text.
class AuthLogoCard extends StatelessWidget {
  const AuthLogoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 295,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AuthDesignConstants.cardBorderRadius),
        ),
        shadows: const [AuthDesignConstants.cardShadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/icons/app_icon.png',
            width: 149,
            height: 147,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              width: 149,
              height: 147,
              decoration: BoxDecoration(
                color: AuthDesignConstants.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.local_taxi, size: 80, color: AuthDesignConstants.primary),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Fast Taxi', style: AuthDesignConstants.logoTitle),
        ],
      ),
    );
  }
}

/// The bottom sheet container used on all auth screens.
///
/// Matches Figma: white background, 24px top corners, shadow, padding.
class AuthBottomSheet extends StatelessWidget {
  const AuthBottomSheet({super.key, required this.children, this.padding, this.spacing = 20});

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? AuthDesignConstants.sheetPadding,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AuthDesignConstants.bottomSheetRadius),
            topRight: Radius.circular(AuthDesignConstants.bottomSheetRadius),
          ),
        ),
        shadows: [AuthDesignConstants.bottomSheetShadow],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: _insertSpacing(children, spacing)),
    );
  }

  List<Widget> _insertSpacing(List<Widget> widgets, double gap) {
    if (widgets.isEmpty) return widgets;
    final result = <Widget>[];
    for (var i = 0; i < widgets.length; i++) {
      result.add(widgets[i]);
      if (i < widgets.length - 1) {
        result.add(SizedBox(height: gap));
      }
    }
    return result;
  }
}

/// Header section with centered title and subtitle.
class AuthSheetHeader extends StatelessWidget {
  const AuthSheetHeader({super.key, required this.title, this.subtitle, this.subtitleWidget});

  final String title;
  final String? subtitle;
  final Widget? subtitleWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, textAlign: TextAlign.center, style: AuthDesignConstants.screenTitle),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(subtitle!, textAlign: TextAlign.center, style: AuthDesignConstants.screenSubtitle),
        ],
        if (subtitleWidget != null) ...[const SizedBox(height: 12), subtitleWidget!],
      ],
    );
  }
}

/// Primary gold action button matching Figma specs.
class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AuthDesignConstants.buttonHeight,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AuthDesignConstants.primary,
          foregroundColor: Colors.black,
          disabledBackgroundColor: AuthDesignConstants.primary.withValues(alpha: 0.5),
          disabledForegroundColor: Colors.black45,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthDesignConstants.buttonBorderRadius),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.black),
                ),
              )
            : Text(text, style: AuthDesignConstants.buttonText),
      ),
    );
  }
}

/// Secondary outlined button matching Figma specs.
class AuthSecondaryButton extends StatelessWidget {
  const AuthSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AuthDesignConstants.buttonHeight,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AuthDesignConstants.textSecondary,
          side: const BorderSide(color: AuthDesignConstants.outlineBorder),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthDesignConstants.buttonBorderRadius),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                text,
                style: const TextStyle(
                  color: AuthDesignConstants.textSecondary,
                  fontSize: 14,
                  fontFamily: AuthDesignConstants.fontHeadings,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
              ),
      ),
    );
  }
}

/// Footer row with "Already have an account? Log In" style links.
class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.text,
    required this.actionText,
    required this.onPressed,
  });

  final String text;
  final String actionText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: text, style: AuthDesignConstants.linkText),
            TextSpan(text: actionText, style: AuthDesignConstants.linkTextAccent),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
