# Localization Module

The localization module provides internationalization (i18n) support for the Fast Golden Taxi application with runtime locale switching, RTL support, and comprehensive localization utilities.

## 📁 Directory Structure

```
lib/core/localization/
├── locale_controller.dart     # Riverpod locale controller
└── localization_service.dart  # Localization utilities
```

## 🎯 Key Components

### 1. LocaleController (`locale_controller.dart`)

Riverpod controller for locale management with persistence.

**Features:**
- Runtime locale switching
- Persistence with SharedPreferences
- System locale detection
- Locale change notifications

**Usage:**
```dart
// Watch current locale
final locale = ref.watch(localeControllerProvider);

// Change locale
ref.read(localeControllerProvider.notifier).setLocale(const Locale('ar'));

// Reset to system locale
ref.read(localeControllerProvider.notifier).resetToSystem();

// Check if RTL
final isRTL = ref.watch(localeControllerProvider).isRTL;
```

**LocaleController:**
```dart
class LocaleController extends StateNotifier<Locale> {
  final SharedPreferences _prefs;

  LocaleController(this._prefs)
      : super(_loadLocale(_prefs) ?? _systemLocale);

  static Locale? _loadLocale(SharedPreferences prefs) {
    final languageCode = prefs.getString('language_code');
    final countryCode = prefs.getString('country_code');
    if (languageCode != null) {
      return Locale(languageCode, countryCode);
    }
    return null;
  }

  static Locale get _systemLocale {
    return PlatformDispatcher.instance.locale;
  }

  void setLocale(Locale locale) {
    _prefs.setString('language_code', locale.languageCode);
    if (locale.countryCode != null) {
      _prefs.setString('country_code', locale.countryCode!);
    }
    state = locale;
  }

  void resetToSystem() {
    _prefs.remove('language_code');
    _prefs.remove('country_code');
    state = _systemLocale;
  }

  bool get isRTL {
    return Bidi.isRtlLanguage(state.languageCode);
  }
}
```

### 2. LocalizationService (`localization_service.dart`)

Utilities for localization, formatting, and RTL support.

**Features:**
- Date/time formatting
- Number formatting
- Currency formatting
- RTL text direction
- Text alignment helpers

**Usage:**
```dart
// Format date
final formattedDate = LocalizationService.formatDate(DateTime.now());

// Format time
final formattedTime = LocalizationService.formatTime(DateTime.now());

// Format number
final formattedNumber = LocalizationService.formatNumber(1234.56);

// Format currency
final formattedCurrency = LocalizationService.formatCurrency(1234.56);

// Get text direction
final textDirection = LocalizationService.textDirection;

// Get text alignment
final textAlign = LocalizationService.textAlign;
```

**LocalizationService:**
```dart
class LocalizationService {
  // Date formatting
  static String formatDate(DateTime date, {String? pattern}) {
    final locale = PlatformDispatcher.instance.locale;
    return DateFormat(pattern ?? 'yMMMd', locale.languageCode).format(date);
  }

  static String formatTime(DateTime time, {String? pattern}) {
    final locale = PlatformDispatcher.instance.locale;
    return DateFormat(pattern ?? 'jm', locale.languageCode).format(time);
  }

  static String formatDateTime(DateTime dateTime, {String? pattern}) {
    final locale = PlatformDispatcher.instance.locale;
    return DateFormat(pattern ?? 'yMMMdjm', locale.languageCode).format(dateTime);
  }

  // Number formatting
  static String formatNumber(num number, {int? decimalDigits}) {
    final locale = PlatformDispatcher.instance.locale;
    return NumberFormat.decimalPattern(locale.languageCode)
        .format(number);
  }

  static String formatCompactNumber(num number) {
    final locale = PlatformDispatcher.instance.locale;
    return NumberFormat.compact(locale.languageCode).format(number);
  }

  // Currency formatting
  static String formatCurrency(
    num amount, {
    String? symbol,
    String? currencyCode,
  }) {
    final locale = PlatformDispatcher.instance.locale;
    return NumberFormat.currency(
      locale: locale.languageCode,
      symbol: symbol,
      name: currencyCode,
    ).format(amount);
  }

  // Percentage formatting
  static String formatPercentage(double value, {int? decimalDigits}) {
    final locale = PlatformDispatcher.instance.locale;
    return NumberFormat.percentPattern(
      locale.languageCode,
      decimalDigits: decimalDigits,
    ).format(value);
  }

  // Duration formatting
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  // Relative time formatting
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  // Text direction
  static TextDirection get textDirection {
    final locale = PlatformDispatcher.instance.locale;
    return Bidi.isRtlLanguage(locale.languageCode)
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  // Text alignment
  static TextAlign get textAlign {
    return textDirection == TextDirection.rtl
        ? TextAlign.right
        : TextAlign.left;
  }

  // Check if RTL
  static bool get isRTL {
    return textDirection == TextDirection.rtl;
  }

  // Get current locale
  static Locale get currentLocale {
    return PlatformDispatcher.instance.locale;
  }

  // Get language code
  static String get languageCode {
    return currentLocale.languageCode;
  }

  // Get country code
  static String? get countryCode {
    return currentLocale.countryCode;
  }
}
```

## 🏗️ Architecture

### Localization Flow

```
1. App starts
2. Load saved locale from SharedPreferences
3. Initialize LocaleController with locale
4. Apply locale to MaterialApp
5. Listen for locale changes
6. Update UI when locale changes
```

### Locale Management

```
LocaleController
    ↓
SharedPreferences (Persistence)
    ↓
MaterialApp (locale property)
    ↓
AppLocalizations (Generated)
    ↓
UI Updates
```

## 📝 Best Practices

### 1. Use LocaleController for Locale Management

```dart
// Good
final locale = ref.watch(localeControllerProvider);
ref.read(localeControllerProvider.notifier).setLocale(const Locale('ar'));

// Bad
// Manage locale manually without controller
```

### 2. Use AppLocalizations for Translations

```dart
// Good
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Text(l10n.welcomeMessage);
  }
}

// Bad
// Hardcode strings
Text('Welcome');
```

### 3. Use LocalizationService for Formatting

```dart
// Good
final formattedDate = LocalizationService.formatDate(DateTime.now());
final formattedCurrency = LocalizationService.formatCurrency(1234.56);

// Bad
// Format manually
final formattedDate = '${date.day}/${date.month}/${date.year}';
```

### 4. Support RTL

```dart
// Good
Directionality(
  textDirection: LocalizationService.textDirection,
  child: MyWidget(),
);

// Bad
// Assume LTR
Directionality(
  textDirection: TextDirection.ltr,
  child: MyWidget(),
);
```

### 5. Use TextDirection for Alignment

```dart
// Good
Align(
  alignment: LocalizationService.textDirection == TextDirection.rtl
      ? Alignment.centerRight
      : Alignment.centerLeft,
  child: Text('Hello'),
);

// Bad
// Hardcode alignment
Align(
  alignment: Alignment.centerLeft,
  child: Text('Hello'),
);
```

## 🔧 Usage Examples

### Locale Switcher

```dart
class LocaleSwitcher extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);

    return SegmentedButton<Locale>(
      segments: const [
        ButtonSegment(
          value: Locale('en'),
          label: Text('English'),
        ),
        ButtonSegment(
          value: Locale('ar'),
          label: Text('العربية'),
        ),
      ],
      selected: {locale},
      onSelectionChanged: (Set<Locale> selected) {
        ref.read(localeControllerProvider.notifier).setLocale(selected.first);
      },
    );
  }
}
```

### RTL-Aware Widget

```dart
class RTLAwareWidget extends StatelessWidget {
  final Widget child;

  const RTLAwareWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: LocalizationService.textDirection,
      child: child,
    );
  }
}
```

### Formatted Date Widget

```dart
class FormattedDate extends StatelessWidget {
  final DateTime date;

  const FormattedDate({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Text(
      LocalizationService.formatDate(date),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
```

### Currency Display Widget

```dart
class CurrencyDisplay extends StatelessWidget {
  final double amount;

  const CurrencyDisplay({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Text(
      LocalizationService.formatCurrency(amount),
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}
```

### Relative Time Widget

```dart
class RelativeTime extends StatelessWidget {
  final DateTime dateTime;

  const RelativeTime({super.key, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Text(
      LocalizationService.formatRelativeTime(dateTime),
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
```

## 🌍 Adding New Languages

### Step 1: Add ARB File

Create `lib/l10n/app_<language_code>.arb`:

```json
{
  "@@locale": "fr",
  "welcomeMessage": "Bienvenue",
  "@welcomeMessage": {
    "description": "Welcome message shown on home screen"
  },
  "loginButton": "Connexion",
  "@loginButton": {
    "description": "Login button label"
  }
}
```

### Step 2: Update AppLocalizations

Run code generation:

```bash
flutter gen-l10n
```

### Step 3: Add to MaterialApp

```dart
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: ref.watch(localeControllerProvider),
);
```

### Step 4: Add to Locale Switcher

```dart
SegmentedButton<Locale>(
  segments: const [
    ButtonSegment(value: Locale('en'), label: Text('English')),
    ButtonSegment(value: Locale('ar'), label: Text('العربية')),
    ButtonSegment(value: Locale('fr'), label: Text('Français')),
  ],
  // ...
);
```

## 🧪 Testing

### Unit Tests

```dart
test('LocalizationService should format date correctly', () {
  final date = DateTime(2024, 1, 15);
  final formatted = LocalizationService.formatDate(date);
  expect(formatted, isNotEmpty);
});

test('LocalizationService should format currency correctly', () {
  final formatted = LocalizationService.formatCurrency(1234.56);
  expect(formatted, contains('\$'));
});
```

### Widget Tests

```dart
testWidgets('LocaleSwitcher should change locale', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        localeControllerProvider.overrideWith((ref) => LocaleController(mockPrefs)),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: LocaleSwitcher(),
        ),
      ),
    ),
  );

  await tester.tap(find.text('العربية'));
  await tester.pumpAndSettle();

  expect(find.text('العربية'), findsOneWidget);
});
```

## 📚 Additional Resources

- [Flutter Internationalization](https://flutter.dev/docs/development/accessibility-and-internationalization/internationalization)
- [ARB Format](https://github.com/google/app-resource-bundle)
- [Bidi Package](https://pub.dev/packages/bidi)

## 🤝 Contributing

When adding new translations:

1. Add to ARB files
2. Run code generation
3. Test on all supported locales
4. Test RTL layouts
5. Update documentation

## 📄 License

This module is part of the Fast Golden Taxi project.