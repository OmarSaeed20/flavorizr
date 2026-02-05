import 'package:flavorizr/core/ui/responsive/src/breakpoints.dart';
import 'package:flavorizr/core/ui/responsive/src/device_info.dart';
import 'package:flavorizr/core/ui/responsive/src/responsive_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigation type for adaptive scaffold
enum NavigationType {
  /// Drawer navigation (mobile - overlay)
  drawer,

  /// Navigation rail (tablet - collapsed)
  rail,

  /// Extended navigation rail (desktop - expanded)
  extendedRail,

  /// No navigation
  none,
}

/// Configuration for adaptive navigation behavior
class AdaptiveNavigationConfig {
  /// Whether to show drawer on mobile
  final bool showDrawerOnMobile;

  /// Whether to show rail on tablet
  final bool showRailOnTablet;

  /// Whether to show extended rail on desktop
  final bool showExtendedRailOnDesktop;

  /// Whether the rail is initially expanded
  final bool initiallyExpanded;

  /// Custom drawer width
  final double? drawerWidth;

  /// Custom rail width (collapsed)
  final double? railWidth;

  /// Custom extended rail width
  final double? extendedRailWidth;

  const AdaptiveNavigationConfig({
    this.showDrawerOnMobile = true,
    this.showRailOnTablet = true,
    this.showExtendedRailOnDesktop = true,
    this.initiallyExpanded = false,
    this.drawerWidth,
    this.railWidth,
    this.extendedRailWidth,
  });

  /// Default configuration
  static const AdaptiveNavigationConfig defaultConfig =
      AdaptiveNavigationConfig();

  /// Configuration with no navigation
  static const AdaptiveNavigationConfig noNavigation = AdaptiveNavigationConfig(
    showDrawerOnMobile: false,
    showRailOnTablet: false,
    showExtendedRailOnDesktop: false,
  );

  /// Configuration for always expanded rail
  static const AdaptiveNavigationConfig alwaysExpanded =
      AdaptiveNavigationConfig(initiallyExpanded: true);
}

/// An adaptive scaffold that changes navigation based on device type
///
/// Navigation behavior:
/// - Mobile: Uses Drawer (overlay navigation)
/// - Tablet: Uses NavigationRail (collapsed side navigation)
/// - Desktop: Uses Extended NavigationRail (expanded side navigation)
///
/// Integrates with:
/// - [StatefulNavigationShell] for shell-based navigation
/// - Custom navigation drawer/rail widgets
/// - [Scaffold] for platform-adaptive behavior
class AdaptiveScaffold extends StatefulWidget {
  /// The navigation shell for go_router shell navigation
  final StatefulNavigationShell? navigationShell;

  /// The body content builder (used when navigationShell is null)
  final Widget Function(BuildContext context, int selectedIndex)? bodyBuilder;

  /// The body widget (alternative to bodyBuilder, used when navigationShell is null)
  final Widget? body;

  /// Navigation configuration
  final AdaptiveNavigationConfig navigationConfig;

  /// Currently selected index (used when navigationShell is null)
  final int selectedIndex;

  /// Callback when destination is selected (used when navigationShell is null)
  final ValueChanged<int>? onDestinationSelected;

  /// App bar widget
  final PreferredSizeWidget? appBar;

  /// Floating action button
  final Widget? floatingActionButton;

  /// Floating action button location
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Floating action button animator
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// Background color for the scaffold
  final Color? backgroundColor;

  /// Custom drawer widget builder (for mobile)
  final Widget Function(BuildContext context, StatefulNavigationShell shell)?
  drawerBuilder;

  /// Custom navigation rail widget builder (for tablet/desktop)
  final Widget Function(
    BuildContext context,
    StatefulNavigationShell shell,
    bool isExpanded,
  )?
  railBuilder;

  /// Whether the scaffold is in a nested navigation context
  final bool isNested;

  /// Whether to resize to avoid bottom inset (keyboard)
  final bool? resizeToAvoidBottomInset;

  /// Restoration ID for state restoration
  final String? restorationId;

  /// Content builder for wrapping body content
  final Widget Function(BuildContext context, Widget child)? contentBuilder;

  /// Key for the underlying scaffold
  final Key? scaffoldKey;

  /// Creates an adaptive scaffold with navigation shell integration
  const AdaptiveScaffold({
    super.key,
    this.navigationShell,
    this.bodyBuilder,
    this.body,
    this.navigationConfig = AdaptiveNavigationConfig.defaultConfig,
    this.selectedIndex = 0,
    this.onDestinationSelected,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.backgroundColor,
    this.drawerBuilder,
    this.railBuilder,
    this.isNested = false,
    this.resizeToAvoidBottomInset,
    this.restorationId,
    this.contentBuilder,
    this.scaffoldKey,
  }) : assert(
         navigationShell != null || bodyBuilder != null || body != null,
         'Either navigationShell, bodyBuilder or body must be provided',
       );

  /// Creates an adaptive scaffold specifically for navigation shell
  const AdaptiveScaffold.shell({
    super.key,
    required StatefulNavigationShell this.navigationShell,
    this.navigationConfig = AdaptiveNavigationConfig.defaultConfig,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.backgroundColor,
    this.drawerBuilder,
    this.railBuilder,
    this.isNested = false,
    this.resizeToAvoidBottomInset,
    this.restorationId,
    this.contentBuilder,
    this.scaffoldKey,
  }) : bodyBuilder = null,
       body = null,
       selectedIndex = 0,
       onDestinationSelected = null;

  /// Creates an adaptive scaffold without navigation (content only)
  const AdaptiveScaffold.content({
    super.key,
    required Widget this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.restorationId,
    this.contentBuilder,
    this.scaffoldKey,
  }) : navigationShell = null,
       bodyBuilder = null,
       navigationConfig = AdaptiveNavigationConfig.noNavigation,
       selectedIndex = 0,
       onDestinationSelected = null,
       drawerBuilder = null,
       railBuilder = null,
       isNested = true;

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  NavigationType _getNavigationType(DeviceInfo info) {
    if (widget.isNested || widget.navigationShell == null) {
      return NavigationType.none;
    }

    final config = widget.navigationConfig;

    return switch (info.deviceType) {
      DeviceType.mobile =>
        config.showDrawerOnMobile ? NavigationType.drawer : NavigationType.none,
      DeviceType.tablet =>
        config.showRailOnTablet ? NavigationType.rail : NavigationType.none,
      DeviceType.desktop =>
        config.showExtendedRailOnDesktop
            ? NavigationType.extendedRail
            : (config.showRailOnTablet
                  ? NavigationType.rail
                  : NavigationType.none),
    };
  }

  int get _currentIndex =>
      widget.navigationShell?.currentIndex ?? widget.selectedIndex;

  @override
  Widget build(BuildContext context) {
    final info = DeviceInfo.fromContext(context);
    final data = ResponsiveData(info);
    final navigationType = _getNavigationType(info);

    Widget bodyContent = _buildBodyContent(context);

    // Apply content builder if provided
    if (widget.contentBuilder != null) {
      bodyContent = widget.contentBuilder!(context, bodyContent);
    }

    return Scaffold(
      key: widget.scaffoldKey ?? _scaffoldKey,
      appBar: widget.appBar,
      backgroundColor: widget.backgroundColor,
      body: _buildBody(context, info, data, navigationType, bodyContent),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      restorationId: widget.restorationId,
      drawer: navigationType == NavigationType.drawer
          ? _buildDrawer(context, info, data)
          : null,
    );
  }

  Widget _buildBodyContent(BuildContext context) {
    if (widget.navigationShell != null) {
      return widget.navigationShell!;
    }
    return widget.body ??
        (widget.bodyBuilder != null
            ? widget.bodyBuilder!(context, _currentIndex)
            : const SizedBox.shrink());
  }

  Widget _buildBody(
    BuildContext context,
    DeviceInfo info,
    ResponsiveData data,
    NavigationType navigationType,
    Widget bodyContent,
  ) {
    switch (navigationType) {
      case NavigationType.drawer:
      case NavigationType.none:
        // Drawer is handled by scaffold, just return body
        return bodyContent;

      case NavigationType.rail:
        return Row(
          children: [
            _buildNavigationRail(context, info, data, isExpanded: false),
            Expanded(child: bodyContent),
          ],
        );

      case NavigationType.extendedRail:
        return Row(
          children: [
            _buildNavigationRail(context, info, data, isExpanded: true),
            Expanded(child: bodyContent),
          ],
        );
    }
  }

  Widget? _buildDrawer(
    BuildContext context,
    DeviceInfo info,
    ResponsiveData data,
  ) {
    if (widget.navigationShell == null) return null;

    // Use custom drawer builder if provided
    if (widget.drawerBuilder != null) {
      return widget.drawerBuilder!(context, widget.navigationShell!);
    }

    // Return null to allow external drawer widget (CustomNavigationDrawer)
    // to be used via the NavigationSideController integration
    return null;
  }

  Widget _buildNavigationRail(
    BuildContext context,
    DeviceInfo info,
    ResponsiveData data, {
    required bool isExpanded,
  }) {
    if (widget.navigationShell == null) {
      return const SizedBox.shrink();
    }

    // Use custom rail builder if provided
    if (widget.railBuilder != null) {
      return widget.railBuilder!(context, widget.navigationShell!, isExpanded);
    }

    // Return a placeholder that expects CustomNavigationRail to be used
    // This maintains compatibility with the existing navigation system
    return const SizedBox.shrink();
  }

  /// Opens the drawer (for mobile navigation)
  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  /// Closes the drawer (for mobile navigation)
  void closeDrawer() {
    _scaffoldKey.currentState?.closeDrawer();
  }

  /// Returns whether the drawer is currently open
  bool get isDrawerOpen => _scaffoldKey.currentState?.isDrawerOpen ?? false;
}

/// A simpler responsive scaffold for content pages
class ResponsiveScaffold extends StatelessWidget {
  /// The body content
  final Widget body;

  /// App bar widget
  final PreferredSizeWidget? appBar;

  /// Floating action button
  final Widget? floatingActionButton;

  /// Floating action button location
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Floating action button animator
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// Background color
  final Color? backgroundColor;

  /// Whether to center the body with max width
  final bool centerBody;

  /// Maximum body width (defaults to responsive value)
  final double? maxBodyWidth;

  /// Horizontal padding for the body
  final double? horizontalPadding;

  /// Vertical padding for the body
  final double? verticalPadding;

  /// Whether to apply safe area
  final bool applySafeArea;

  /// Whether to include bottom safe area
  final bool includeBottomSafeArea;

  /// Whether to include left safe area (for landscape)
  final bool includeLeftSafeArea;

  /// Whether to include right safe area (for landscape)
  final bool includeRightSafeArea;

  /// Whether to resize to avoid bottom inset (keyboard)
  final bool? resizeToAvoidBottomInset;

  /// Bottom sheet widget
  final Widget? bottomSheet;

  /// Persistent footer buttons
  final List<Widget>? persistentFooterButtons;

  /// Persistent footer alignment
  final AlignmentDirectional? persistentFooterAlignment;

  /// Whether the scaffold extends body behind app bar
  final bool extendBodyBehindAppBar;

  /// Whether the scaffold extends body
  final bool extendBody;

  /// Drawer widget
  final Widget? drawer;

  /// End drawer widget
  final Widget? endDrawer;

  /// Drawer scrim color
  final Color? drawerScrimColor;

  /// Drawer edge drag width
  final double? drawerEdgeDragWidth;

  /// Enable drawer open drag gesture
  final bool drawerEnableOpenDragGesture;

  /// Enable end drawer open drag gesture
  final bool endDrawerEnableOpenDragGesture;

  /// Callback when drawer state changes
  final DrawerCallback? onDrawerChanged;

  /// Callback when end drawer state changes
  final DrawerCallback? onEndDrawerChanged;

  /// Restoration ID for state restoration
  final String? restorationId;

  /// Whether the scaffold is primary (affects status bar)
  final bool primary;

  /// Widget key for the underlying scaffold
  final Key? scaffoldKey;

  /// Builder for wrapping content with additional widgets
  final Widget Function(BuildContext context, Widget child)? contentBuilder;

  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.backgroundColor,
    this.centerBody = true,
    this.maxBodyWidth,
    this.horizontalPadding,
    this.verticalPadding,
    this.applySafeArea = true,
    this.includeBottomSafeArea = false,
    this.includeLeftSafeArea = true,
    this.includeRightSafeArea = true,
    this.resizeToAvoidBottomInset,
    this.bottomSheet,
    this.persistentFooterButtons,
    this.persistentFooterAlignment,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.drawer,
    this.endDrawer,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
    this.restorationId,
    this.primary = true,
    this.scaffoldKey,
    this.contentBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final info = DeviceInfo.fromContext(context);
    final data = ResponsiveData(info);

    Widget content = body;

    // Apply responsive centering and constraints
    if (centerBody) {
      final effectiveMaxWidth = maxBodyWidth ?? info.maxContentWidth;
      final effectiveHorizontalPadding =
          horizontalPadding ?? data.padding.screen;
      final effectiveVerticalPadding = verticalPadding ?? 0.0;

      content = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: effectiveHorizontalPadding,
              vertical: effectiveVerticalPadding,
            ),
            child: content,
          ),
        ),
      );
    }

    // Apply safe area if needed
    if (applySafeArea) {
      content = SafeArea(
        bottom: includeBottomSafeArea,
        left: includeLeftSafeArea,
        right: includeRightSafeArea,
        child: content,
      );
    }

    // Apply content builder if provided
    if (contentBuilder != null) {
      content = contentBuilder!(context, content);
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: appBar,
      backgroundColor: backgroundColor,
      body: content,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      bottomSheet: bottomSheet,
      persistentFooterButtons: persistentFooterButtons,
      persistentFooterAlignment:
          persistentFooterAlignment ?? AlignmentDirectional.centerEnd,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
      drawer: drawer,
      endDrawer: endDrawer,
      drawerScrimColor: drawerScrimColor,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      onDrawerChanged: onDrawerChanged,
      onEndDrawerChanged: onEndDrawerChanged,
      restorationId: restorationId,
      primary: primary,
    );
  }

  /// Creates a simple ResponsiveScaffold with just a body and optional app bar title
  static Widget simple({
    Key? key,
    required Widget body,
    String? title,
    Widget? titleWidget,
    List<Widget>? actions,
    Widget? leading,
    bool automaticallyImplyLeading = true,
    Color? backgroundColor,
    Color? appBarBackgroundColor,
    Widget? floatingActionButton,
    bool centerBody = true,
    bool applySafeArea = true,
  }) {
    return ResponsiveScaffold(
      key: key,
      body: body,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      centerBody: centerBody,
      applySafeArea: applySafeArea,
      appBar: title != null || titleWidget != null || actions != null
          ? AppBar(
              title: titleWidget ?? (title != null ? Text(title) : null),
              actions: actions,
              leading: leading,
              automaticallyImplyLeading: automaticallyImplyLeading,
              backgroundColor: appBarBackgroundColor,
            )
          : null,
    );
  }

  /// Creates a ResponsiveScaffold with a sliver app bar for scrollable content
  static Widget withSliverAppBar({
    Key? key,
    required Widget body,
    required Widget sliverAppBar,
    Color? backgroundColor,
    bool centerBody = true,
    double? maxBodyWidth,
    bool applySafeArea = false,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
  }) {
    return Builder(
      builder: (context) {
        final info = DeviceInfo.fromContext(context);
        final data = ResponsiveData(info);

        Widget content = body;

        if (centerBody) {
          final effectiveMaxWidth = maxBodyWidth ?? info.maxContentWidth;
          final effectivePadding = data.padding.screen;

          content = Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: effectivePadding),
                child: content,
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: backgroundColor,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          body: CustomScrollView(
            slivers: [
              sliverAppBar as SliverAppBar,
              SliverToBoxAdapter(child: content),
            ],
          ),
        );
      },
    );
  }

  /// Creates a ResponsiveScaffold optimized for form pages
  static Widget forForm({
    Key? key,
    required Widget body,
    String? title,
    Widget? titleWidget,
    List<Widget>? actions,
    Color? backgroundColor,
    bool resizeToAvoidBottomInset = true,
    Widget? floatingActionButton,
    List<Widget>? persistentFooterButtons,
    double? maxBodyWidth,
  }) {
    return ResponsiveScaffold(
      key: key,
      body: body,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      persistentFooterButtons: persistentFooterButtons,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      maxBodyWidth: maxBodyWidth,
      includeBottomSafeArea: true,
      appBar: title != null || titleWidget != null || actions != null
          ? AppBar(
              title: titleWidget ?? (title != null ? Text(title) : null),
              actions: actions,
            )
          : null,
    );
  }

  /// Creates a ResponsiveScaffold with drawer navigation
  static Widget withDrawer({
    Key? key,
    required Widget body,
    required Widget drawer,
    Widget? endDrawer,
    PreferredSizeWidget? appBar,
    String? title,
    Color? backgroundColor,
    Widget? floatingActionButton,
    bool centerBody = true,
    double? maxBodyWidth,
  }) {
    return ResponsiveScaffold(
      key: key,
      body: body,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      centerBody: centerBody,
      maxBodyWidth: maxBodyWidth,
      appBar: appBar ?? (title != null ? AppBar(title: Text(title)) : null),
    );
  }
}

/// Extension methods for ResponsiveScaffold
extension ResponsiveScaffoldExtensions on ResponsiveScaffold {
  /// Returns a copy of this ResponsiveScaffold with the given fields replaced
  ResponsiveScaffold copyWith({
    Widget? body,
    PreferredSizeWidget? appBar,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    FloatingActionButtonAnimator? floatingActionButtonAnimator,
    Color? backgroundColor,
    bool? centerBody,
    double? maxBodyWidth,
    double? horizontalPadding,
    double? verticalPadding,
    bool? applySafeArea,
    bool? includeBottomSafeArea,
    bool? includeLeftSafeArea,
    bool? includeRightSafeArea,
    bool? resizeToAvoidBottomInset,
    Widget? bottomSheet,
    List<Widget>? persistentFooterButtons,
    AlignmentDirectional? persistentFooterAlignment,
    bool? extendBodyBehindAppBar,
    bool? extendBody,
    Widget? drawer,
    Widget? endDrawer,
    Color? drawerScrimColor,
    double? drawerEdgeDragWidth,
    bool? drawerEnableOpenDragGesture,
    bool? endDrawerEnableOpenDragGesture,
    DrawerCallback? onDrawerChanged,
    DrawerCallback? onEndDrawerChanged,
    String? restorationId,
    bool? primary,
    Key? scaffoldKey,
    Widget Function(BuildContext context, Widget child)? contentBuilder,
  }) {
    return ResponsiveScaffold(
      body: body ?? this.body,
      appBar: appBar ?? this.appBar,
      floatingActionButton: floatingActionButton ?? this.floatingActionButton,
      floatingActionButtonLocation:
          floatingActionButtonLocation ?? this.floatingActionButtonLocation,
      floatingActionButtonAnimator:
          floatingActionButtonAnimator ?? this.floatingActionButtonAnimator,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      centerBody: centerBody ?? this.centerBody,
      maxBodyWidth: maxBodyWidth ?? this.maxBodyWidth,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      applySafeArea: applySafeArea ?? this.applySafeArea,
      includeBottomSafeArea:
          includeBottomSafeArea ?? this.includeBottomSafeArea,
      includeLeftSafeArea: includeLeftSafeArea ?? this.includeLeftSafeArea,
      includeRightSafeArea: includeRightSafeArea ?? this.includeRightSafeArea,
      resizeToAvoidBottomInset:
          resizeToAvoidBottomInset ?? this.resizeToAvoidBottomInset,
      bottomSheet: bottomSheet ?? this.bottomSheet,
      persistentFooterButtons:
          persistentFooterButtons ?? this.persistentFooterButtons,
      persistentFooterAlignment:
          persistentFooterAlignment ?? this.persistentFooterAlignment,
      extendBodyBehindAppBar:
          extendBodyBehindAppBar ?? this.extendBodyBehindAppBar,
      extendBody: extendBody ?? this.extendBody,
      drawer: drawer ?? this.drawer,
      endDrawer: endDrawer ?? this.endDrawer,
      drawerScrimColor: drawerScrimColor ?? this.drawerScrimColor,
      drawerEdgeDragWidth: drawerEdgeDragWidth ?? this.drawerEdgeDragWidth,
      drawerEnableOpenDragGesture:
          drawerEnableOpenDragGesture ?? this.drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture:
          endDrawerEnableOpenDragGesture ?? this.endDrawerEnableOpenDragGesture,
      onDrawerChanged: onDrawerChanged ?? this.onDrawerChanged,
      onEndDrawerChanged: onEndDrawerChanged ?? this.onEndDrawerChanged,
      restorationId: restorationId ?? this.restorationId,
      primary: primary ?? this.primary,
      scaffoldKey: scaffoldKey ?? this.scaffoldKey,
      contentBuilder: contentBuilder ?? this.contentBuilder,
    );
  }
}
