import 'package:flavorizr/core/ui/responsive/src/device_info.dart';
import 'package:flavorizr/core/ui/responsive/src/responsive_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A responsive container that constrains content width
///
/// Automatically centers content and applies maximum width
/// based on device type.
class ResponsiveContainer extends StatelessWidget {
  /// The child widget
  final Widget child;

  /// Maximum width (uses responsive defaults if null)
  final double? maxWidth;

  /// Horizontal padding
  final double? padding;

  /// Alignment of the content
  final Alignment alignment;

  /// Whether to apply safe area
  final bool applySafeArea;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.alignment = Alignment.topCenter,
    this.applySafeArea = false,
  });

  @override
  Widget build(BuildContext context) {
    final info = DeviceInfo.fromContext(context);
    final data = ResponsiveData(info);

    final effectiveMaxWidth = maxWidth ?? info.maxContentWidth;
    final effectivePadding = padding ?? data.padding.screen;

    Widget content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: effectivePadding),
        child: child,
      ),
    );

    if (alignment != Alignment.topCenter) {
      content = Align(alignment: alignment, child: content);
    } else {
      content = Center(child: content);
    }

    if (applySafeArea) {
      content = SafeArea(child: content);
    }

    return content;
  }
}

/// A responsive grid that adjusts column count based on screen width
class ResponsiveGrid extends StatelessWidget {
  /// The children widgets
  final List<Widget> children;

  /// Column count for mobile (default: 1)
  final int mobileColumns;

  /// Column count for tablet (default: 2)
  final int tabletColumns;

  /// Column count for desktop (default: 3)
  final int desktopColumns;

  /// Main axis spacing
  final double? mainAxisSpacing;

  /// Cross axis spacing
  final double? crossAxisSpacing;

  /// Child aspect ratio
  final double? childAspectRatio;

  /// Padding around the grid
  final EdgeInsetsGeometry? padding;

  /// Main axis extent (height of each item)
  final double? mainAxisExtent;

  /// Shrink wrap the grid
  final bool shrinkWrap;

  /// Physics for scrolling
  final ScrollPhysics? physics;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.childAspectRatio,
    this.mainAxisExtent,
    this.padding,
    this.shrinkWrap = true,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final info = DeviceInfo.fromContext(context);
    final data = ResponsiveData(info);

    final columnCount = info.byDevice(
      mobile: mobileColumns,
      tablet: tabletColumns,
      desktop: desktopColumns,
    );

    final effectiveMainAxisSpacing = mainAxisSpacing ?? data.spacing.grid;
    final effectiveCrossAxisSpacing = crossAxisSpacing ?? data.spacing.grid;

    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        mainAxisSpacing: effectiveMainAxisSpacing,
        crossAxisSpacing: effectiveCrossAxisSpacing,
        childAspectRatio: childAspectRatio ?? 1,
        mainAxisExtent: mainAxisExtent,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// A sliver version of ResponsiveGrid for CustomScrollView
class SliverResponsiveGrid extends StatelessWidget {
  /// The children widgets
  final List<Widget> children;

  /// Column count for mobile (default: 1)
  final int mobileColumns;

  /// Column count for tablet (default: 2)
  final int tabletColumns;

  /// Column count for desktop (default: 3)
  final int desktopColumns;

  /// Main axis spacing
  final double? mainAxisSpacing;

  /// Cross axis spacing
  final double? crossAxisSpacing;

  /// Child aspect ratio
  final double? childAspectRatio;

  /// Main axis extent
  final double? mainAxisExtent;

  const SliverResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.childAspectRatio,
    this.mainAxisExtent,
  });

  @override
  Widget build(BuildContext context) {
    final info = DeviceInfo.fromContext(context);
    final data = ResponsiveData(info);

    final columnCount = info.byDevice(
      mobile: mobileColumns,
      tablet: tabletColumns,
      desktop: desktopColumns,
    );

    final effectiveMainAxisSpacing = mainAxisSpacing ?? data.spacing.grid;
    final effectiveCrossAxisSpacing = crossAxisSpacing ?? data.spacing.grid;

    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) => children[index],
        childCount: children.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        mainAxisSpacing: effectiveMainAxisSpacing,
        crossAxisSpacing: effectiveCrossAxisSpacing,
        childAspectRatio: childAspectRatio ?? 1,
        mainAxisExtent: mainAxisExtent,
      ),
    );
  }
}

/// A responsive row that becomes a column on smaller screens
class ResponsiveRowColumn extends StatelessWidget {
  /// The children widgets
  final List<Widget> children;

  /// Use column layout on mobile (default: true)
  final bool columnOnMobile;

  /// Main axis alignment
  final MainAxisAlignment mainAxisAlignment;

  /// Cross axis alignment
  final CrossAxisAlignment crossAxisAlignment;

  /// Main axis size
  final MainAxisSize mainAxisSize;

  /// Spacing between children
  final double? spacing;

  /// Whether to wrap children with Expanded when in Row mode
  final bool expandChildren;

  /// Flex values for each child when expandChildren is true
  /// If null, all children will have flex: 1
  final List<int>? flexValues;

  const ResponsiveRowColumn({
    super.key,
    required this.children,
    this.columnOnMobile = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing,
    this.expandChildren = true,
    this.flexValues,
  });

  @override
  Widget build(BuildContext context) {
    final info = DeviceInfo.fromContext(context);
    final data = ResponsiveData(info);

    final useColumn = columnOnMobile && info.isMobile;
    final effectiveSpacing = spacing ?? data.spacing.md;

    final spacedChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      Widget child = children[i];

      // Wrap with Expanded when in Row mode and expandChildren is true
      if (!useColumn && expandChildren) {
        final flex = (flexValues != null && i < flexValues!.length) ? flexValues![i] : 1;
        child = Expanded(flex: flex, child: child);
      }

      spacedChildren.add(child);

      /* if (i < children.length - 1) {
        spacedChildren.add(SizedBox(
          width: useColumn ? null : effectiveSpacing,
          height: useColumn ? effectiveSpacing : null,
        ));
      } */
    }

    if (useColumn) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        spacing: effectiveSpacing,
        children: spacedChildren,
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      spacing: effectiveSpacing,
      children: spacedChildren,
    );
  }
}

/// A responsive wrap that adjusts spacing based on device
class ResponsiveWrap extends StatelessWidget {
  /// The children widgets
  final List<Widget> children;

  /// Horizontal spacing between children
  final double? spacing;

  /// Vertical spacing between children (run spacing)
  final double? runSpacing;

  /// Alignment of children
  final WrapAlignment alignment;

  /// Cross axis alignment
  final WrapCrossAlignment crossAxisAlignment;

  const ResponsiveWrap({
    super.key,
    required this.children,
    this.spacing,
    this.runSpacing,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final info = DeviceInfo.fromContext(context);
    final data = ResponsiveData(info);

    final effectiveSpacing = spacing ?? data.spacing.sm;
    final effectiveRunSpacing = runSpacing ?? data.spacing.sm;

    return Wrap(
      spacing: effectiveSpacing,
      runSpacing: effectiveRunSpacing,
      alignment: alignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}

/// Responsive padding widget that applies device-appropriate padding
class ResponsivePaddingWidget extends StatelessWidget {
  /// The child widget
  final Widget child;

  /// Mobile padding
  final EdgeInsetsGeometry? mobile;

  /// Tablet padding
  final EdgeInsetsGeometry? tablet;

  /// Desktop padding
  final EdgeInsetsGeometry? desktop;

  /// Use screen padding preset
  final bool useScreenPadding;

  /// Use card padding preset
  final bool useCardPadding;

  const ResponsivePaddingWidget({
    super.key,
    required this.child,
    this.mobile,
    this.tablet,
    this.desktop,
    this.useScreenPadding = false,
    this.useCardPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    final info = DeviceInfo.fromContext(context);
    final data = ResponsiveData(info);

    EdgeInsetsGeometry effectivePadding;

    if (useScreenPadding) {
      effectivePadding = EdgeInsets.symmetric(horizontal: data.padding.screen);
    } else if (useCardPadding) {
      effectivePadding = EdgeInsets.all(data.padding.card);
    } else {
      effectivePadding = info.byDevice(
        mobile: mobile ?? EdgeInsets.all(data.padding.md),
        tablet: tablet,
        desktop: desktop,
      );
    }

    return Padding(padding: effectivePadding, child: child);
  }
}

/// A responsive card with device-appropriate styling
class ResponsiveCard extends StatelessWidget {
  /// The child widget
  final Widget child;

  /// Card color
  final Color? color;

  /// Card elevation
  final double? elevation;

  /// Card border radius
  final double? borderRadius;

  /// Card padding
  final EdgeInsetsGeometry? padding;

  /// Card margin
  final EdgeInsetsGeometry? margin;

  /// Card border
  final BorderSide? border;

  /// On tap callback
  final VoidCallback? onTap;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.color,
    this.elevation,
    this.borderRadius,
    this.padding,
    this.margin,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final info = DeviceInfo.fromContext(context);
    final data = ResponsiveData(info);
    final theme = Theme.of(context);

    final effectiveBorderRadius = borderRadius ?? data.radius.card;
    final effectivePadding = padding ?? EdgeInsets.all(data.padding.card);
    final effectiveElevation = elevation ?? (info.isDesktop ? 2.r : 1.r);

    Widget card = Card(
      color: color ?? theme.cardColor,
      elevation: effectiveElevation,
      margin: margin ?? EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        side: border ?? BorderSide.none,
      ),
      child: Padding(padding: effectivePadding, child: child),
    );

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        child: card,
      );
    }

    return card;
  }
}
