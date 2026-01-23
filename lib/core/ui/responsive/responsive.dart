/// Complete Responsive System for Flutter Applications
///
/// This library provides a comprehensive responsive design system that adapts
/// to different screen sizes, device types, and orientations.
///
/// ## Features:
/// - **Breakpoints**: Material Design 3 responsive breakpoints
/// - **Device Detection**: Smart detection of mobile, tablet, desktop
/// - **Responsive Values**: Easy value switching based on device/screen
/// - **Spacing System**: Consistent spacing with responsive scaling
/// - **Typography**: Responsive font sizing
/// - **Layout Helpers**: Gap, padding, margin utilities
/// - **Responsive Widgets**: Builder widgets for adaptive layouts
///
/// ## Usage:
/// ```dart
/// import 'package:swnw_app/core/ui/responsive/responsive.dart';
///
/// // Access responsive values
/// final padding = context.responsive.padding.md;
/// final fontSize = context.responsive.fontSize.body;
///
/// // Use responsive builder
/// ResponsiveBuilder(
///   mobile: (context) => MobileLayout(),
///   tablet: (context) => TabletLayout(),
///   desktop: (context) => DesktopLayout(),
/// )
/// ```
library;

export 'src/breakpoints.dart';
export 'src/device_info.dart';
export 'src/responsive_context.dart';
export 'src/responsive_data.dart';
export 'src/responsive_extensions.dart';
export 'src/responsive_value.dart';
export 'src/spacing/spacing.dart';
export 'src/typography/typography.dart';
export 'src/widgets/widgets.dart';
