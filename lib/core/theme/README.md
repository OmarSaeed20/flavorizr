# Theme Module

The theme module provides a **Figma-accurate** Material 3 color system for the Fast Golden Taxi application. Every hex value is extracted directly from the Figma design file – no generic Material defaults. Both **light** and **dark** mode palettes are fully specified.

## 📁 Directory Structure

```
lib/core/theme/
├── app_colors.dart        # Figma palette tokens (k* / kDark* constants) + AppColors accessor
├── app_text_styles.dart   # Theme-aware TextStyle accessor
├── app_theme.dart         # ThemeData builder + AppThemeExtension + context extensions
├── color_schemes.dart     # Light / Dark / OLED ColorScheme + SemanticColors
├── theme.dart             # Barrel exports
├── theme_controller.dart  # Riverpod controller + persistence
├── theme_settings.dart    # Immutable settings model
├── typography.dart        # Poppins / Inter / Roboto type-scale
└── README.md              # ← you are here
```

## 🎨 Color Palette – Light Mode (from Figma)

| Token | Hex | Usage |
|---|---|---|
| **Primary** | `#FFBF00` | Golden CTA buttons (Confirm, Accept, Submit), map marker borders |
| **Primary Variant** | `#F2C223` | Selected chip border, date-picker accent |
| **Destructive** | `#CC2B2B` | Cancel button text, error states |
| **Gray 900** | `#000000` | Black text, status-bar icons |
| **Gray 800** | `#212121` | Date/time display text |
| **Gray 700** | `#353535` | Headings, selected date-picker bg |
| **Gray 600** | `#3C3C3C` | Car marker border |
| **Gray 500** | `#686868` | Address / subtitle text |
| **Gray 400** | `#949494` | Placeholder / hint text, disabled bg |
| **Gray 300** | `#B6B6B6` | Toggle border |
| **Gray 200** | `#D1D1D1` | Input field borders |
| **Gray 150** | `#E4E4E4` | Card / chip borders, keyboard keys |
| **Gray 100** | `#F2F2F2` | Input field bg, dividers |
| **Gray 50** | `#FAFAFA` | Avatar borders, icon-button bg |
| **White** | `#FFFFFF` | Card backgrounds, bottom sheets |

## 🌙 Color Palette – Dark Mode (from Figma)

| Token | Hex | Figma Usage |
|---|---|---|
| **Dark Primary** | `#DAA520` | Goldenrod – titles, labels, accents, primary CTAs |
| **Dark Primary Variant** | `#F2C223` | Selected tab/chip border, active accent |
| **Dark Background** | `#636363` | Scaffold / page background |
| **Dark Surface** | `#4A4A4A` | Cards, app bar, containers, inputs, bottom sheets |
| **Dark Surface Variant** | `#636363` | Card borders, input borders, dividers |
| **Dark Segment Border** | `#4F4F4F` | Segmented control border |
| **Dark On Surface** | `#FFFFFF` | Primary text – headings, names, body |
| **Dark Text Secondary** | `#D1D1D1` | Status bar, subtitles, data values |
| **Dark Text Tertiary** | `#B5B5B5` | Body text, descriptions, help text |
| **Dark Text Hint** | `#949494` | Input hints, labels, secondary info |
| **Dark Text Muted** | `#6C6C6C` | Currency suffix in inputs |
| **Dark Badge** | `#26F1C630` | Badge/tag background (15% gold) |
| **Dark Chart Accent** | `#FFDB58` | Pie chart accent |
| **Dark Chat Bubble Sent** | `#B6B6B6` | Sent message bubble |
| **Dark Overlay** | `#B3000000` | Modal backdrop (70% black) |
| **Dark Selected Tab Fill** | `#DAA520` | Selected tab background |
| **Dark Selected Tab Text** | `#4A4A4A` | Inverted text on selected tab |

### Shadows

| Token | Light | Dark | Usage |
|---|---|---|---|
| `kShadowLight` / `kDarkShadowSubtle` | `0x14000000` (8%) | `0x14000000` (8%) | General light shadow |
| `kShadowCard` / `kDarkShadowCard` | `0x3FE1E1E1` (~25%) | `0x28E1E1E1` (~16%) | Card shadow |
| `kShadowSheet` / `kDarkShadow` | `0x3F000000` (25%) | `0x33000000` (20%) | Bottom-sheet / drop shadow |
| `kShadowKey` | `0x4C000000` (30%) | — | Keyboard key shadow |

### Dark-Mode Gradients

| Gradient | Colors | Usage |
|---|---|---|
| **Wallet Card** | `#000000` → `#F7CF4D` | Wallet card background with 3% white overlay |

## 🔤 Typography

| Role | Font | Weights |
|---|---|---|
| **Display / Headline / Title / Label** | Poppins | w400, w500, w600, w700 |
| **Body** | Inter | w400, w500, w600 |
| **Chat messages** | Roboto | w400 |
| **Monospace** (OTP / code) | Roboto Mono | w400 |
| **Arabic locale** | Omnia Arabic ITF | — |

> SF Pro Text appears in Figma for iOS keyboard rendering only – it is **not** bundled.

## 🏗️ Architecture

```
ThemeSettings (immutable model)
       │
       ▼
ThemeController (Riverpod Notifier + SharedPreferences)
       │
       ▼
AppTheme.light() / AppTheme.dark()
       │  uses ──► kLightColorScheme / kDarkColorScheme / kOledDarkColorScheme
       │  uses ──► AppTypography.createTextTheme()
       │  uses ──► AppThemeExtension (success/warning/info/shimmer/overlay/badge/chat)
       ▼
ThemeData  ──►  MaterialApp.theme / darkTheme
```

### Dark-Mode ColorScheme Mapping

```
Figma Element                 → Material 3 Slot
─────────────────────────────────────────────────
Scaffold / page bg (#636363)  → surface (+ scaffoldBackgroundColor override)
Card / app bar (#4A4A4A)      → surfaceContainer / surfaceContainerLow
Primary CTA (#DAA520)         → primary
Selected accent (#F2C223)     → tertiary
Primary text (#FFFFFF)        → onSurface
Subtitles (#D1D1D1)           → onSurfaceVariant
Hints (#949494)               → outline
Card borders (#636363)        → outlineVariant
Error (#CC2B2B)               → error
```

## 🚀 Quick Start

### In `MaterialApp`

```dart
final settings = ref.watch(themeControllerProvider);

MaterialApp(
  theme: AppTheme.light(settings: settings),
  darkTheme: AppTheme.dark(settings: settings),
  themeMode: settings.themeMode,
);
```

### Accessing colors in widgets

```dart
// Via ColorScheme (preferred)
final primary = Theme.of(context).colorScheme.primary;

// Via context extension
final cs = context.colorScheme;
final tt = context.textTheme;

// Via AppColors helper (auto-adapts to dark mode)
final colors = AppColors.of(context);
Container(color: colors.primary);        // #FFBF00 (light) / #DAA520 (dark)
Container(color: colors.inputBackground); // #F2F2F2 (light) / #4A4A4A (dark)
Container(color: colors.textHint);        // #949494 (both modes)

// Via AppThemeExtension (success / warning / info / overlay / badge / chat)
final ext = context.appColors;
Container(color: ext.success);
Container(color: ext.overlay);       // 70% black (dark) / 80% black (light)
Container(color: ext.chatBubbleSent); // #B6B6B6 (dark) / #F2F2F2 (light)
Container(color: ext.cardSurface);    // #4A4A4A (dark) / #FFFFFF (light)

// Raw palette tokens (when you need a specific constant)
Container(color: kDarkPrimary);  // #DAA520
Container(color: kDarkSurface);  // #4A4A4A
```

### Changing theme at runtime

```dart
// Switch to dark mode
ref.read(themeControllerProvider.notifier).setThemeMode(ThemeMode.dark);

// Enable OLED black
ref.read(themeControllerProvider.notifier).setUseOledBlack(true);

// Cycle: system → light → dark → system
ref.read(themeControllerProvider.notifier).cycleThemeMode();

// Adjust text scale
ref.read(themeControllerProvider.notifier).setTextScaleFactor(1.2);

// Reset everything
ref.read(themeControllerProvider.notifier).resetToDefaults();
```

## ✅ Best Practices

1. **Use `ColorScheme` for colors** – never hard-code hex values in widgets.
2. **Use `AppColors.of(context)`** for semantic tokens like `textHint`, `border`, `inputBackground` – they auto-adapt to dark mode.
3. **Use `TextTheme` for typography** – never inline `TextStyle(fontSize: …)`.
4. **Use `k*` / `kDark*` constants** only for values that don't exist in `ColorScheme` (shadows, overlays, social-login colors, gradients).
5. **Test both light and dark** – the golden primary keeps `onPrimary: black` in both modes for maximum contrast.
6. **Check OLED mode** – surfaces should render significantly darker when `useOledBlack` is `true`.
7. **Keep Figma in sync** – when the design file changes, update `app_colors.dart` first, then propagate to `color_schemes.dart`.
8. **Use `context.appColors`** for extended tokens (overlay, badge, chatBubbleSent, chartAccent, cardSurface).

## 📄 License

This module is part of the Fast Golden Taxi project.
