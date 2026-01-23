# Phase 4 — Platform Polish

> **Duration:** 2-3 weeks  
> **Priority:** Medium  
> **Dependencies:** Phases 1-3

---

## 📋 Overview

Phase 4 focuses on platform-specific polish, accessibility, and user experience refinements. This phase ensures the app feels native on all platforms and is accessible to all users.

**Key Deliverables:**
- Full accessibility (a11y) support
- Platform-specific adaptations (iOS, Android, Web)
- Dark mode and theming system
- Localization (i18n) with RTL support
- Performance optimizations

---

## 🎯 Goals

| Goal | Success Criteria |
|------|------------------|
| Accessibility | WCAG 2.1 AA compliance |
| Platform Feel | App feels native on each platform |
| Theming | Dark/light mode works correctly |
| Localization | App supports multiple languages |
| Performance | 60fps animations, fast startup |

---

## 📁 Tasks Breakdown

### Task 4.1: Accessibility (a11y)

**Estimated Time:** 3-4 days

#### Objectives
- Implement semantic widgets
- Add screen reader support
- Support dynamic text scaling
- Add keyboard navigation
- Ensure sufficient color contrast

#### Implementation Steps

1. **Create `lib/core/accessibility/accessibility_service.dart`**
   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter/semantics.dart';
   
   /// Service for managing accessibility features across the app.
   /// 
   /// Provides:
   /// - Screen reader announcements
   /// - Focus management
   /// - Accessibility preferences
   class AccessibilityService {
     static AccessibilityService? _instance;
     
     AccessibilityService._();
     
     /// Gets the singleton instance.
     static AccessibilityService get instance {
       _instance ??= AccessibilityService._();
       return _instance!;
     }
     
     /// Announces a message to screen readers.
     /// 
     /// [message] - The text to announce.
     /// [assertiveness] - How urgently the announcement should be made.
     void announce(
       String message, {
       Assertiveness assertiveness = Assertiveness.polite,
     }) {
       SemanticsService.announce(message, TextDirection.ltr);
     }
     
     /// Announces a route change to screen readers.
     void announceRouteChange(String routeName) {
       announce('Navigated to $routeName', assertiveness: Assertiveness.polite);
     }
     
     /// Announces an error to screen readers (assertive).
     void announceError(String error) {
       announce('Error: $error', assertiveness: Assertiveness.assertive);
     }
     
     /// Announces a success message.
     void announceSuccess(String message) {
       announce(message, assertiveness: Assertiveness.polite);
     }
     
     /// Announces loading state.
     void announceLoading() {
       announce('Loading, please wait');
     }
     
     /// Announces completion of loading.
     void announceLoaded() {
       announce('Content loaded');
     }
   }
   
   /// Assertiveness levels for screen reader announcements.
   enum Assertiveness {
     /// Low priority, can be interrupted.
     polite,
     
     /// High priority, interrupts other announcements.
     assertive,
   }
   
   /// Extension methods for accessibility on BuildContext.
   extension AccessibilityExtensions on BuildContext {
     /// Returns true if screen reader is enabled.
     bool get isScreenReaderEnabled {
       return MediaQuery.of(this).accessibleNavigation;
     }
     
     /// Returns true if reduce motion is enabled.
     bool get reduceMotion {
       return MediaQuery.of(this).disableAnimations;
     }
     
     /// Returns true if bold text is enabled.
     bool get boldText {
       return MediaQuery.of(this).boldText;
     }
     
     /// Returns true if high contrast is enabled.
     bool get highContrast {
       return MediaQuery.of(this).highContrast;
     }
     
     /// Returns the current text scale factor.
     double get textScaleFactor {
       return MediaQuery.textScalerOf(this).scale(1.0);
     }
     
     /// Returns true if large text is enabled (scale > 1.3).
     bool get largeText {
       return textScaleFactor > 1.3;
     }
   }
   ```

2. **Create `lib/core/accessibility/semantic_widgets.dart`**
   ```dart
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
         onTap: enabled ? onPressed : null,
         onLongPress: enabled ? onLongPress : null,
         child: ExcludeSemantics(
           child: child,
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
         errorBuilder: errorWidget != null
             ? (context, error, stackTrace) => errorWidget!
             : null,
         frameBuilder: placeholder != null
             ? (context, child, frame, wasSynchronouslyLoaded) {
                 if (wasSynchronouslyLoaded || frame != null) {
                   return child;
                 }
                 return placeholder!;
               }
             : null,
       );
       
       if (isDecorative) {
         return ExcludeSemantics(child: imageWidget);
       }
       
       return Semantics(
         image: true,
         label: description,
         child: ExcludeSemantics(child: imageWidget),
       );
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
         child: TextField(
           controller: controller,
           focusNode: focusNode,
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
       this.level = 1,
       this.style,
       this.textAlign,
     }) : assert(level >= 1 && level <= 6);
   
     @override
     Widget build(BuildContext context) {
       final theme = Theme.of(context);
       
       final defaultStyle = switch (level) {
         1 => theme.textTheme.headlineLarge,
         2 => theme.textTheme.headlineMedium,
         3 => theme.textTheme.headlineSmall,
         4 => theme.textTheme.titleLarge,
         5 => theme.textTheme.titleMedium,
         _ => theme.textTheme.titleSmall,
       };
       
       return Semantics(
         header: true,
         child: Text(
           text,
           style: style ?? defaultStyle,
           textAlign: textAlign,
         ),
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
         label: label,
         selected: isSelected,
         hint: indexHint,
         onTap: onTap,
         child: child,
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
     
     const SemanticLiveRegion({
       super.key,
       required this.child,
       this.value,
       this.isAssertive = false,
     });
   
     @override
     Widget build(BuildContext context) {
       return Semantics(
         liveRegion: true,
         label: value,
         child: child,
       );
     }
   }
   ```

3. **Create `lib/core/accessibility/focus_helpers.dart`**
   ```dart
   import 'package:flutter/material.dart';
   
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
       setState(() {
         _isFocused = _focusNode.hasFocus;
       });
       
       if (_focusNode.hasFocus) {
         widget.onFocused?.call();
       } else {
         widget.onUnfocused?.call();
       }
     }
   
     KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
       if (event is KeyDownEvent) {
         if (event.logicalKey.keyLabel == 'Enter' ||
             event.logicalKey.keyLabel == ' ') {
           widget.onActivate?.call();
           return KeyEventResult.handled;
         }
       }
       return KeyEventResult.ignored;
     }
   
     @override
     Widget build(BuildContext context) {
       final theme = Theme.of(context);
       
       Widget child = widget.child;
       
       if (widget.showFocusIndicator && _isFocused) {
         child = Container(
           decoration: widget.focusDecoration ??
               BoxDecoration(
                 border: Border.all(
                   color: theme.colorScheme.primary,
                   width: 2,
                 ),
                 borderRadius: BorderRadius.circular(4),
               ),
           child: child,
         );
       }
       
       return Focus(
         focusNode: _focusNode,
         canRequestFocus: widget.canRequestFocus,
         skipTraversal: widget.skipTraversal,
         onKeyEvent: widget.onActivate != null ? _handleKeyEvent : null,
         child: child,
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
     
     const FocusTrap({
       super.key,
       required this.child,
       this.active = true,
     });
   
     @override
     Widget build(BuildContext context) {
       if (!active) return child;
       
       return FocusTraversalGroup(
         policy: WidgetOrderTraversalPolicy(),
         child: child,
       );
     }
   }
   ```

#### Acceptance Criteria
- [ ] Screen readers can navigate all screens
- [ ] All interactive elements have semantic labels
- [ ] Dynamic text scaling works up to 2x
- [ ] Keyboard navigation works on web/desktop
- [ ] Color contrast meets WCAG AA standards

---

### Task 4.2: Platform Adaptations

**Estimated Time:** 2-3 days

#### Objectives
- Implement platform-specific behaviors
- Use native navigation patterns
- Adapt UI components per platform
- Handle platform-specific features

#### Implementation Steps

1. **Create `lib/core/platform/platform_service.dart`**
   ```dart
   import 'dart:io';
   
   import 'package:flutter/foundation.dart';
   import 'package:flutter/material.dart';
   
   /// Enumeration of supported platforms.
   enum AppPlatform {
     ios,
     android,
     web,
     macos,
     windows,
     linux,
   }
   
   /// Service for platform detection and adaptation.
   class PlatformService {
     static AppPlatform get current {
       if (kIsWeb) return AppPlatform.web;
       if (Platform.isIOS) return AppPlatform.ios;
       if (Platform.isAndroid) return AppPlatform.android;
       if (Platform.isMacOS) return AppPlatform.macos;
       if (Platform.isWindows) return AppPlatform.windows;
       if (Platform.isLinux) return AppPlatform.linux;
       return AppPlatform.android; // Fallback
     }
     
     /// Returns true if running on iOS.
     static bool get isIOS => current == AppPlatform.ios;
     
     /// Returns true if running on Android.
     static bool get isAndroid => current == AppPlatform.android;
     
     /// Returns true if running on web.
     static bool get isWeb => current == AppPlatform.web;
     
     /// Returns true if running on desktop (macOS, Windows, Linux).
     static bool get isDesktop =>
         current == AppPlatform.macos ||
         current == AppPlatform.windows ||
         current == AppPlatform.linux;
     
     /// Returns true if running on mobile (iOS, Android).
     static bool get isMobile => isIOS || isAndroid;
     
     /// Returns true if the platform has a notch/dynamic island.
     static bool get hasNotch => isIOS; // Simplified, should check device
     
     /// Returns true if the platform uses Cupertino design.
     static bool get usesCupertinoDesign => isIOS || current == AppPlatform.macos;
     
     /// Returns true if the platform uses Material design.
     static bool get usesMaterialDesign => !usesCupertinoDesign;
     
     /// Returns the platform-specific back button behavior.
     static bool get hasPhysicalBackButton => isAndroid;
     
     /// Returns the appropriate haptic feedback for the platform.
     static void lightHaptic() {
       // TODO: Implement haptic feedback
     }
     
     /// Returns the appropriate heavy haptic feedback.
     static void heavyHaptic() {
       // TODO: Implement haptic feedback
     }
   }
   
   /// Extension for platform-specific widget building.
   extension PlatformWidgets on BuildContext {
     /// Returns the current platform.
     AppPlatform get platform => PlatformService.current;
     
     /// Returns true if on iOS.
     bool get isIOS => PlatformService.isIOS;
     
     /// Returns true if on Android.
     bool get isAndroid => PlatformService.isAndroid;
     
     /// Returns true if on web.
     bool get isWeb => PlatformService.isWeb;
     
     /// Returns true if on desktop.
     bool get isDesktop => PlatformService.isDesktop;
     
     /// Returns true if on mobile.
     bool get isMobile => PlatformService.isMobile;
   }
   ```

2. **Create `lib/core/platform/adaptive_widgets.dart`**
   ```dart
   import 'dart:io';
   
   import 'package:flutter/cupertino.dart';
   import 'package:flutter/material.dart';
   
   import 'platform_service.dart';
   
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
         if (isPrimary) {
           return CupertinoButton.filled(
             onPressed: onPressed,
             child: _buildChild(isIOS: true),
           );
         }
         return CupertinoButton(
           onPressed: onPressed,
           child: _buildChild(isIOS: true),
         );
       }
       
       if (isPrimary) {
         if (icon != null) {
           return FilledButton.icon(
             onPressed: onPressed,
             icon: Icon(icon),
             label: Text(text),
           );
         }
         return FilledButton(
           onPressed: onPressed,
           child: Text(text),
         );
       }
       
       if (icon != null) {
         return TextButton.icon(
           onPressed: onPressed,
           icon: Icon(icon),
           label: Text(text),
         );
       }
       return TextButton(
         onPressed: onPressed,
         child: Text(text),
       );
     }
     
     Widget _buildChild({required bool isIOS}) {
       if (icon != null) {
         return Row(
           mainAxisSize: MainAxisSize.min,
           children: [
             Icon(icon, size: isIOS ? 20 : null),
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
             actions: actions.map((action) {
               return CupertinoDialogAction(
                 onPressed: () {
                   Navigator.pop(context, action.value);
                   action.onPressed?.call();
                 },
                 isDefaultAction: action.isDefault,
                 isDestructiveAction: action.isDestructive,
                 child: Text(action.text),
               );
             }).toList(),
           ),
         );
       }
       
       return showDialog<T>(
         context: context,
         builder: (context) => AlertDialog(
           title: Text(title),
           content: content != null ? Text(content) : null,
           actions: actions.map((action) {
             return TextButton(
               onPressed: () {
                 Navigator.pop(context, action.value);
                 action.onPressed?.call();
               },
               child: Text(
                 action.text,
                 style: action.isDestructive
                     ? TextStyle(color: Theme.of(context).colorScheme.error)
                     : null,
               ),
             );
           }).toList(),
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
           AdaptiveDialogAction(
             text: cancelText,
             value: false,
           ),
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
     
     const AdaptiveLoadingIndicator({
       super.key,
       this.size = 24,
       this.color,
     });
   
     @override
     Widget build(BuildContext context) {
       if (PlatformService.usesCupertinoDesign) {
         return CupertinoActivityIndicator(
           radius: size / 2,
           color: color,
         );
       }
       
       return SizedBox(
         width: size,
         height: size,
         child: CircularProgressIndicator(
           strokeWidth: 2,
           valueColor: color != null ? AlwaysStoppedAnimation(color) : null,
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
     
     const AdaptiveSwitch({
       super.key,
       required this.value,
       this.onChanged,
       this.activeColor,
     });
   
     @override
     Widget build(BuildContext context) {
       if (PlatformService.usesCupertinoDesign) {
         return CupertinoSwitch(
           value: value,
           onChanged: onChanged,
           activeColor: activeColor,
         );
       }
       
       return Switch(
         value: value,
         onChanged: onChanged,
         activeColor: activeColor,
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
     
     const AdaptiveAppBar({
       super.key,
       this.title,
       this.leading,
       this.actions,
       this.automaticallyImplyLeading = true,
       this.backgroundColor,
       this.transparent = false,
     });
   
     @override
     Size get preferredSize => const Size.fromHeight(kToolbarHeight);
   
     @override
     Widget build(BuildContext context) {
       if (PlatformService.usesCupertinoDesign) {
         return CupertinoNavigationBar(
           middle: title,
           leading: leading,
           trailing: actions != null && actions!.isNotEmpty
               ? Row(
                   mainAxisSize: MainAxisSize.min,
                   children: actions!,
                 )
               : null,
           automaticallyImplyLeading: automaticallyImplyLeading,
           backgroundColor: transparent
               ? CupertinoColors.systemBackground.withOpacity(0.8)
               : backgroundColor,
         );
       }
       
       return AppBar(
         title: title,
         leading: leading,
         actions: actions,
         automaticallyImplyLeading: automaticallyImplyLeading,
         backgroundColor: transparent ? Colors.transparent : backgroundColor,
         elevation: transparent ? 0 : null,
       );
     }
   }
   ```

#### Acceptance Criteria
- [ ] iOS uses Cupertino components where appropriate
- [ ] Android uses Material components
- [ ] Web adapts to screen size
- [ ] Navigation patterns match platform conventions
- [ ] Platform-specific features work correctly

---

### Task 4.3: Theming System

**Estimated Time:** 2-3 days

#### Objectives
- Implement comprehensive theming
- Support dark/light modes
- Allow custom themes
- Persist theme preferences

*(Detailed theming implementation)*

---

### Task 4.4: Localization (i18n)

**Estimated Time:** 3-4 days

#### Objectives
- Set up localization infrastructure
- Support RTL languages
- Implement language switching
- Handle pluralization and formatting

*(Detailed localization implementation with ARB files)*

---

### Task 4.5: Performance Optimization

**Estimated Time:** 2-3 days

#### Objectives
- Optimize startup time
- Implement lazy loading
- Add image caching and optimization
- Profile and fix jank

*(Detailed performance optimization)*

---

## 📊 Phase 4 Checklist

| Task | Status | Notes |
|------|--------|-------|
| 4.1 Accessibility | ⬜ | |
| 4.2 Platform Adaptations | ⬜ | |
| 4.3 Theming System | ⬜ | |
| 4.4 Localization | ⬜ | |
| 4.5 Performance Optimization | ⬜ | |

---

## 🔗 Dependencies for Next Phase

Phase 5 requires the following from Phase 4:
- ✅ Accessibility infrastructure for analytics events
- ✅ Platform service for platform-specific error handling
- ✅ Localized strings for error messages

---

## 📝 Notes

- Test accessibility with real screen readers (VoiceOver, TalkBack)
- Platform adaptations should feel native, not just visual
- Theme changes should be animated smoothly
- Localization should support interpolation and pluralization
- Performance testing should be done on low-end devices
