import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

/// A generic, highly‑customisable dropdown based on [DropdownButton2].
///
/// The widget mirrors the example from the package documentation
/// (see the constructor and build‑method in the package source)‑【7†L1132-L1179】【7†L1189-L1239】,
/// but adds a type parameter `T` and an optional item‑label builder
/// so it works with any data type.
///
/// ```dart
/// CustomDropDown<String>(
///   hint: 'Select a country',
///   items: countryList,
///   value: selectedCountry,
///   onChanged: (v) => setState(() => selectedCountry = v),
///   itemLabelBuilder: (c) => c,
/// )
/// ```
class CustomDropDown<T> extends StatelessWidget {
  const CustomDropDown({
    super.key,
    // ──────────────────────── required ────────────────────────
    required this.hint,
    required this.items,
    required this.onChanged,
    // ───────────────────── optional ────────────────────────
    this.value,
    this.itemLabelBuilder,
    this.itemWidgetBuilder,
    this.selectedItemBuilder,
    this.hintAlignment,
    this.valueAlignment,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonPadding,
    this.buttonDecoration,
    this.buttonElevation,
    this.icon,
    this.iconSize,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.itemHeight,
    this.itemPadding,
    this.dropdownHeight,
    this.dropdownWidth,
    this.dropdownPadding,
    this.dropdownDecoration,
    this.dropdownElevation,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.scrollbarAlwaysShow,
    this.offset = Offset.zero,
    this.label,
  });

  /// Label text displayed above the field.
  final String? label;

  // ────────────────────── required fields ──────────────────────
  /// Text shown when no value is selected.
  final String hint;

  /// The list of data items you want to display.
  final List<T> items;

  /// Callback fired when the user selects a new value.
  final ValueChanged<T?> onChanged;

  // ────────────────────── optional fields ──────────────────────
  /// Currently selected value (may be `null`).
  final T? value;

  /// Convert an item of type `T` to a `String` that will be shown inside the
  /// default `Text` widget. If omitted the widget falls back to `item.toString()`.
  final String Function(T)? itemLabelBuilder;

  /// Build a custom widget for an item (overrides `itemLabelBuilder`).
  final Widget Function(BuildContext context, T item)? itemWidgetBuilder;

  /// Builder for the selected item (same contract as `DropdownButtonBuilder`).
  final DropdownButtonBuilder? selectedItemBuilder;

  final Alignment? hintAlignment;
  final Alignment? valueAlignment;
  final double? buttonHeight;
  final double? buttonWidth;
  final EdgeInsetsGeometry? buttonPadding;
  final BoxDecoration? buttonDecoration;
  final int? buttonElevation;
  final Widget? icon;
  final double? iconSize;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final double? itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final double? dropdownHeight;
  final double? dropdownWidth;
  final EdgeInsetsGeometry? dropdownPadding;
  final BoxDecoration? dropdownDecoration;
  final int? dropdownElevation;
  final Radius? scrollbarRadius;
  final double? scrollbarThickness;
  final bool? scrollbarAlwaysShow;
  final Offset offset;

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
        DropdownButtonHideUnderline(
          child: DropdownButton2<T>(
            // -------------------------------------------------------------
            // General behaviour
            // -------------------------------------------------------------
            isExpanded: true,
            hint: Container(
              alignment: hintAlignment ?? Alignment.centerLeft,
              child: Text(
                hint,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
              ),
            ),
            value: value,
            // -------------------------------------------------------------
            // Items
            // -------------------------------------------------------------
            items: items.map((item) {
              final Widget child;
              if (itemWidgetBuilder != null) {
                child = itemWidgetBuilder!(context, item);
              } else {
                final label = itemLabelBuilder != null ? itemLabelBuilder!(item) : item.toString();
                child = Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 14),
                );
              }
              return DropdownMenuItem<T>(
                value: item,
                // Align the child inside the menu item.
                child: Container(alignment: valueAlignment ?? Alignment.centerLeft, child: child),
              );
            }).toList(),
            onChanged: onChanged,
            selectedItemBuilder: selectedItemBuilder,
            // -------------------------------------------------------------
            // Styling – button (the closed dropdown)
            // -------------------------------------------------------------
            buttonStyleData: ButtonStyleData(
              height: buttonHeight ?? 40,
              width: buttonWidth ?? 140,
              padding: buttonPadding ?? const EdgeInsets.only(left: 14, right: 14),
              decoration:
                  buttonDecoration ??
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black45),
                  ),
              elevation: buttonElevation ?? 0,
            ),
            // -------------------------------------------------------------
            // Styling – icon
            // -------------------------------------------------------------
            iconStyleData: IconStyleData(
              icon: icon ?? const Icon(Icons.arrow_forward_ios_outlined),
              iconSize: iconSize ?? 12,
              iconEnabledColor: iconEnabledColor,
              iconDisabledColor: iconDisabledColor,
            ),
            // -------------------------------------------------------------
            // Styling – dropdown menu
            // -------------------------------------------------------------
            dropdownStyleData: DropdownStyleData(
              maxHeight: dropdownHeight ?? 200,
              width: dropdownWidth ?? 140,
              padding: dropdownPadding,
              decoration:
                  dropdownDecoration ?? BoxDecoration(borderRadius: BorderRadius.circular(12)),
              elevation: dropdownElevation ?? 8,
              offset: offset,
              // Scrollbar customisation
              scrollbarTheme: ScrollbarThemeData(
                radius: scrollbarRadius ?? const Radius.circular(40),
                thickness: scrollbarThickness != null
                    ? WidgetStatePropertyAll(scrollbarThickness!)
                    : null,
                thumbVisibility: scrollbarAlwaysShow != null
                    ? WidgetStatePropertyAll(scrollbarAlwaysShow!)
                    : null,
              ),
            ),
            // -------------------------------------------------------------
            // Styling – each menu item
            // -------------------------------------------------------------
            menuItemStyleData: MenuItemStyleData(
              height: itemHeight ?? 40,
              padding: itemPadding ?? const EdgeInsets.symmetric(horizontal: 14),
            ),
          ),
        ),
      ],
    );
  }
}
