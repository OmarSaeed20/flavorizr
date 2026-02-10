# Theme Module

The theme module provides a comprehensive theming system for the Fast Golden Taxi application with Material 3 design system support, dynamic colors, and extensive customization options.

## 📁 Directory Structure

```
lib/core/theme/
├── app_theme.dart           # Main theme generation
├── color_schemes.dart       # Predefined color schemes
├── typography.dart          # Typography configuration
├── theme_controller.dart    # Riverpod theme controller
└── theme_settings.dart      # Theme settings model
```

## 🎯 Key Components

### 1. AppTheme (`app_theme.dart`)

Main theme generation using flex_color_scheme.

**Features:**
- 28+ predefined color schemes
- Material 3 design system
- Dynamic color support
- OLED black mode
- Custom component themes

**Usage:**
```dart
// Light theme
final lightTheme = AppTheme.light(settings: themeSettings);

// Dark theme
final darkTheme = AppTheme.dark(settings: themeSettings);

// Use in MaterialApp
MaterialApp(
  theme: lightTheme,
  darkTheme: darkTheme,
  themeMode: themeSettings.themeMode,
);
```

**Theme Generation:**
```dart
static ThemeData light({required ThemeSettings settings}) {
  final scheme = settings.colorScheme;
  final useMaterial3 = settings.useMaterial3;

  return FlexThemeData.light(
    scheme: scheme,
    usedColors: settings.usedColors,
    surfaceMode: settings.surfaceMode,
    blendLevel: settings.blendLevel,
    appBarStyle: FlexAppBarStyle.primary,
    appBarOpacity: settings.appBarOpacity,
    transparentStatusBar: settings.transparentStatusBar,
    subThemesData: _buildSubThemes(settings),
    keyColors: settings.useKeyColors
        ? FlexKeyColors(
            useKeyColors: true,
            useSecondary: settings.useSecondaryKeyColor,
            useTertiary: settings.useTertiaryKeyColor,
          )
        : null,
    tones: settings.useTones
        ? FlexTones(
            brightness: Brightness.light,
            onMain: settings.onMainTone,
            onContainer: settings.onContainerTone,
          )
        : null,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: useMaterial3,
    swapLegacyOnMaterial3: useMaterial3,
    fontFamily: 'Inter',
  ).copyWith(
    extensions: [
      _buildCustomColors(settings),
    ],
  );
}
```

### 2. ColorSchemes (`color_schemes.dart`)

Predefined color schemes using flex_color_scheme.

**Available Schemes:**
- Material Design (Blue, Red, Green, Yellow, Purple, Orange, Pink, Cyan, Teal, Amber, Indigo, Lime, Brown, Grey, BlueGrey)
- Custom (Golden, Taxi, Brand)
- Deep Purple, Deep Orange, Deep Teal
- Rose, Violet, Emerald, Sapphire
- Mango, Lime, Sky, Mint

**Usage:**
```dart
// Get a color scheme
final scheme = ColorSchemes.golden;

// Use in theme settings
final settings = ThemeSettings(
  colorScheme: scheme,
  themeMode: ThemeMode.system,
);

// Access scheme colors
final primary = scheme.primary;
final secondary = scheme.secondary;
final tertiary = scheme.tertiary;
```

**Color Scheme Examples:**
```dart
class ColorSchemes {
  // Material Design schemes
  static const blue = FlexScheme.blue;
  static const red = FlexScheme.red;
  static const green = FlexScheme.green;
  static const yellow = FlexScheme.yellow;
  static const purple = FlexScheme.purple;
  static const orange = FlexScheme.orange;
  static const pink = FlexScheme.pink;
  static const cyan = FlexScheme.cyan;
  static const teal = FlexScheme.teal;
  static const amber = FlexScheme.amber;
  static const indigo = FlexScheme.indigo;
  static const lime = FlexScheme.lime;
  static const brown = FlexScheme.brown;
  static const grey = FlexScheme.grey;
  static const blueGrey = FlexScheme.blueGrey;

  // Custom schemes
  static const golden = FlexScheme.gold;
  static const taxi = FlexScheme.barossa;
  static const brand = FlexScheme.mango;

  // Deep schemes
  static const deepPurple = FlexScheme.deepPurple;
  static const deepOrange = FlexScheme.deepOrange;
  static const deepTeal = FlexScheme.deepTeal;

  // Vibrant schemes
  static const rose = FlexScheme.rose;
  static const violet = FlexScheme.violet;
  static const emerald = FlexScheme.emerald;
  static const sapphire = FlexScheme.sapphire;
}
```

### 3. Typography (`typography.dart`)

Typography configuration using Material 3 type scale.

**Features:**
- Material 3 type scale
- Custom font family (Inter)
- Responsive text scaling
- Custom text styles

**Usage:**
```dart
// Get text theme
final textTheme = AppTypography.textTheme;

// Use in theme
MaterialApp(
  theme: ThemeData(
    textTheme: textTheme,
  ),
);

// Access text styles
Text(
  'Hello',
  style: textTheme.displayLarge,
);
```

**Text Scale:**
```dart
static TextTheme get textTheme => const TextTheme(
  // Display styles
  displayLarge: TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
  ),
  displayMedium: TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
  ),
  displaySmall: TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
  ),

  // Headline styles
  headlineLarge: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
  ),
  headlineMedium: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
  ),
  headlineSmall: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
  ),

  // Title styles
  titleLarge: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
  ),
  titleMedium: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  ),
  titleSmall: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  ),

  // Body styles
  bodyLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  ),
  bodyMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  ),
  bodySmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  ),

  // Label styles
  labelLarge: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  ),
  labelMedium: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  ),
  labelSmall: TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  ),
);
```

### 4. ThemeController (`theme_controller.dart`)

Riverpod controller for theme management with persistence.

**Features:**
- Theme mode switching (light/dark/system)
- Color scheme selection
- Custom theme settings
- Persistence with SharedPreferences

**Usage:**
```dart
// Watch theme settings
final themeSettings = ref.watch(themeControllerProvider);

// Change theme mode
ref.read(themeControllerProvider.notifier).setThemeMode(ThemeMode.dark);

// Change color scheme
ref.read(themeControllerProvider.notifier).setColorScheme(FlexScheme.gold);

// Update settings
ref.read(themeControllerProvider.notifier).updateSettings(
  ThemeSettings(
    colorScheme: FlexScheme.gold,
    themeMode: ThemeMode.system,
    useMaterial3: true,
  ),
);
```

**ThemeController:**
```dart
class ThemeController extends StateNotifier<ThemeSettings> {
  final SharedPreferences _prefs;

  ThemeController(this._prefs) : super(_loadSettings(_prefs));

  static ThemeSettings _loadSettings(SharedPreferences prefs) {
    final themeModeIndex = prefs.getInt('theme_mode') ?? 0;
    final colorSchemeIndex = prefs.getInt('color_scheme') ?? 0;
    final useMaterial3 = prefs.getBool('use_material3') ?? true;

    return ThemeSettings(
      themeMode: ThemeMode.values[themeModeIndex],
      colorScheme: FlexScheme.values[colorSchemeIndex],
      useMaterial3: useMaterial3,
    );
  }

  void setThemeMode(ThemeMode mode) {
    _prefs.setInt('theme_mode', mode.index);
    state = state.copyWith(themeMode: mode);
  }

  void setColorScheme(FlexScheme scheme) {
    _prefs.setInt('color_scheme', scheme.index);
    state = state.copyWith(colorScheme: scheme);
  }

  void updateSettings(ThemeSettings settings) {
    _prefs.setInt('theme_mode', settings.themeMode.index);
    _prefs.setInt('color_scheme', settings.colorScheme.index);
    _prefs.setBool('use_material3', settings.useMaterial3);
    state = settings;
  }
}
```

### 5. ThemeSettings (`theme_settings.dart`)

Theme settings model with freezed.

**Properties:**
- Theme mode (light/dark/system)
- Color scheme
- Material 3 flag
- Surface mode
- Blend level
- Custom colors

**Usage:**
```dart
// Create settings
final settings = ThemeSettings(
  themeMode: ThemeMode.system,
  colorScheme: FlexScheme.gold,
  useMaterial3: true,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 0,
);

// Copy with changes
final newSettings = settings.copyWith(
  themeMode: ThemeMode.dark,
);
```

**ThemeSettings Model:**
```dart
@freezed
class ThemeSettings with _$ThemeSettings {
  const factory ThemeSettings({
    required ThemeMode themeMode,
    required FlexScheme colorScheme,
    @Default(true) bool useMaterial3,
    @Default(FlexSurfaceMode.levelSurfacesLowScaffold) FlexSurfaceMode surfaceMode,
    @Default(0) int blendLevel,
    @Default(FlexAppBarStyle.primary) FlexAppBarStyle appBarStyle,
    @Default(1.0) double appBarOpacity,
    @Default(false) bool transparentStatusBar,
    @Default(FlexUsedColors.primary) FlexUsedColors usedColors,
    @Default(true) bool useKeyColors,
    @Default(true) bool useSecondaryKeyColor,
    @Default(true) bool useTertiaryKeyColor,
    @Default(true) bool useTones,
    @Default(40) int onMainTone,
    @Default(90) int onContainerTone,
  }) = _ThemeSettings;

  factory ThemeSettings.fromJson(Map<String, dynamic> json) =>
      _$ThemeSettingsFromJson(json);
}
```

## 🏗️ Architecture

### Theme System Flow

```
1. App starts
2. Load theme settings from SharedPreferences
3. Initialize ThemeController with settings
4. Generate light and dark themes
5. Apply themes to MaterialApp
6. Listen for theme changes
7. Update UI when theme changes
```

### Theme Generation

```
ThemeSettings
    ↓
AppTheme.light() / AppTheme.dark()
    ↓
FlexThemeData (flex_color_scheme)
    ↓
ThemeData (Flutter)
    ↓
MaterialApp
```

## 📝 Best Practices

### 1. Use ThemeController for Theme Management

```dart
// Good
final themeSettings = ref.watch(themeControllerProvider);
ref.read(themeControllerProvider.notifier).setThemeMode(ThemeMode.dark);

// Bad
// Manage theme manually without controller
```

### 2. Use Theme.of(context) for Theme Access

```dart
// Good
final theme = Theme.of(context);
final color = theme.colorScheme.primary;

// Bad
// Hardcode colors
final color = Colors.blue;
```

### 3. Use TextTheme for Typography

```dart
// Good
Text(
  'Hello',
  style: Theme.of(context).textTheme.headlineMedium,
);

// Bad
Text(
  'Hello',
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
);
```

### 4. Use ColorScheme for Colors

```dart
// Good
Container(
  color: Theme.of(context).colorScheme.primary,
);

// Bad
Container(
  color: Colors.blue,
);
```

### 5. Support Dark Mode

```dart
// Good
MaterialApp(
  theme: AppTheme.light(settings: settings),
  darkTheme: AppTheme.dark(settings: settings),
  themeMode: settings.themeMode,
);

// Bad
MaterialApp(
  theme: AppTheme.light(settings: settings),
);
```

## 🔧 Usage Examples

### Custom Theme Widget

```dart
class ThemedContainer extends StatelessWidget {
  final Widget child;

  const ThemedContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline),
      ),
      child: child,
    );
  }
}
```

### Theme Switcher

```dart
class ThemeSwitcher extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeControllerProvider);

    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment(
          value: ThemeMode.light,
          label: Text('Light'),
          icon: Icon(Icons.light_mode),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          label: Text('Dark'),
          icon: Icon(Icons.dark_mode),
        ),
        ButtonSegment(
          value: ThemeMode.system,
          label: Text('System'),
          icon: Icon(Icons.brightness_auto),
        ),
      ],
      selected: {themeSettings.themeMode},
      onSelectionChanged: (Set<ThemeMode> selected) {
        ref.read(themeControllerProvider.notifier)
            .setThemeMode(selected.first);
      },
    );
  }
}
```

### Color Scheme Selector

```dart
class ColorSchemeSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeControllerProvider);

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: FlexScheme.values.length,
      itemBuilder: (context, index) {
        final scheme = FlexScheme.values[index];
        final isSelected = themeSettings.colorScheme == scheme;

        return GestureDetector(
          onTap: () {
            ref.read(themeControllerProvider.notifier)
                .setColorScheme(scheme);
          },
          child: Container(
            decoration: BoxDecoration(
              color: FlexColor.of(scheme).light.primary,
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
        );
      },
    );
  }
}
```

## 🧪 Testing

### Widget Tests

```dart
testWidgets('Theme should apply correctly', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        themeControllerProvider.overrideWith((ref) => ThemeController(mockPrefs)),
      ],
      child: MaterialApp(
        theme: AppTheme.light(settings: defaultSettings),
        home: Scaffold(
          body: Container(
            color: Theme.of(tester.element(find.byType(Scaffold)))
                .colorScheme
                .primary,
          ),
        ),
      ),
    ),
  );

  final container = tester.widget<Container>(find.byType(Container));
  expect(container.color, isNotNull);
});
```

## 📚 Additional Resources

- [Material 3 Design](https://m3.material.io)
- [flex_color_scheme](https://pub.dev/packages/flex_color_scheme)
- [Flutter Theming](https://flutter.dev/docs/development/ui/widgets/material)

## 🤝 Contributing

When modifying the theme system:

1. Test on both light and dark modes
2. Ensure accessibility (contrast ratios)
3. Test on different screen sizes
4. Update documentation
5. Add tests

## 📄 License

This module is part of the Fast Golden Taxi project.