# Localization (l10n) Module

The localization module provides internationalization (i18n) and localization (l10n) support for the Fast Golden Taxi application, supporting multiple languages and locales.

## 📁 Directory Structure

```
lib/l10n/
├── app_en.arb                  # English translations
├── app_ar.arb                  # Arabic translations
├── app_localizations.dart      # Generated localizations class
├── app_localizations_en.dart   # English localizations
└── app_localizations_ar.dart   # Arabic localizations
```

## 🎯 Key Components

### 1. ARB Files (`app_*.arb`)

Application Resource Bundle (ARB) files containing translations for each supported language.

**Features:**
- Key-value translation pairs
- Pluralization support
- Date/time formatting
- Number formatting
- Currency formatting

**Usage:**
```json
{
  "@@locale": "en",
  "appTitle": "Fast Golden Taxi",
  "welcomeMessage": "Welcome to Fast Golden Taxi",
  "loginButton": "Login",
  "logoutButton": "Logout"
}
```

### 2. AppLocalizations (`app_localizations.dart`)

Generated localizations class providing type-safe access to translations.

**Features:**
- Type-safe translation access
- Auto-generated from ARB files
- Support for all translation types
- Compile-time checking

**Usage:**
```dart
// Access translations
final localizations = AppLocalizations.of(context);
final title = localizations.appTitle;
final welcome = localizations.welcomeMessage;
```

## 🏗️ Architecture

### Localization Flow

```
1. App starts
2. Detect device locale
3. Load appropriate ARB file
4. Generate AppLocalizations
5. Apply translations to UI
6. Handle locale changes
```

### Translation Process

```
1. Add translation keys to ARB files
2. Run code generation
3. AppLocalizations generated
4. Use translations in code
5. Test all locales
```

## 📝 Best Practices

### 1. Use Descriptive Keys

```json
// Good
"loginButton": "Login",
"forgotPasswordButton": "Forgot Password?"

// Bad
"btn1": "Login",
"btn2": "Forgot Password?"
```

### 2. Use Placeholders

```json
// Good
"welcomeUser": "Welcome, {username}!",
"itemsCount": "You have {count} items"

// Bad
"welcomeUser": "Welcome, John!",
"itemsCount": "You have 5 items"
```

### 3. Use Pluralization

```json
// Good
"itemsCount": "{count, plural, =0{No items} =1{One item} other{{count} items}}"

// Bad
"itemsCount": "You have items"
```

### 4. Keep Translations Consistent

```json
// Good
"loginButton": "Login",
"loginTitle": "Login"

// Bad
"loginButton": "Sign In",
"loginTitle": "Login"
```

### 5. Test All Locales

```dart
// Good
// Test English, Arabic, and all other supported locales

// Bad
// Only test English
```

## 🔧 Usage Examples

### Adding Translations

**English (app_en.arb):**
```json
{
  "@@locale": "en",
  "appTitle": "Fast Golden Taxi",
  "welcomeMessage": "Welcome to Fast Golden Taxi",
  "loginButton": "Login",
  "logoutButton": "Logout",
  "homeTab": "Home",
  "profileTab": "Profile",
  "settingsTab": "Settings",
  "searchPlaceholder": "Search...",
  "noResults": "No results found",
  "loading": "Loading...",
  "error": "An error occurred",
  "retry": "Retry",
  "cancel": "Cancel",
  "save": "Save",
  "delete": "Delete",
  "edit": "Edit",
  "close": "Close",
  "confirm": "Confirm",
  "yes": "Yes",
  "no": "No",
  "ok": "OK",
  "welcomeUser": "Welcome, {username}!",
  "itemsCount": "{count, plural, =0{No items} =1{One item} other{{count} items}}",
  "lastUpdated": "Last updated: {date}"
}
```

**Arabic (app_ar.arb):**
```json
{
  "@@locale": "ar",
  "appTitle": "تاكسي الذهبي السريع",
  "welcomeMessage": "مرحبًا بك في تاكسي الذهبي السريع",
  "loginButton": "تسجيل الدخول",
  "logoutButton": "تسجيل الخروج",
  "homeTab": "الرئيسية",
  "profileTab": "الملف الشخصي",
  "settingsTab": "الإعدادات",
  "searchPlaceholder": "بحث...",
  "noResults": "لم يتم العثور على نتائج",
  "loading": "جاري التحميل...",
  "error": "حدث خطأ",
  "retry": "إعادة المحاولة",
  "cancel": "إلغاء",
  "save": "حفظ",
  "delete": "حذف",
  "edit": "تعديل",
  "close": "إغلاق",
  "confirm": "تأكيد",
  "yes": "نعم",
  "no": "لا",
  "ok": "موافق",
  "welcomeUser": "مرحبًا، {username}!",
  "itemsCount": "{count, plural, =0{لا توجد عناصر} =1{عنصر واحد} other{{count} عناصر}}",
  "lastUpdated": "آخر تحديث: {date}"
}
```

### Using Translations in Widgets

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
      ),
      body: Center(
        child: Column(
          children: [
            Text(localizations.welcomeMessage),
            ElevatedButton(
              onPressed: () {},
              child: Text(localizations.loginButton),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Using Placeholders

```dart
class WelcomeWidget extends StatelessWidget {
  final String username;

  const WelcomeWidget({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Text(
      localizations.welcomeUser(username),
    );
  }
}
```

### Using Pluralization

```dart
class ItemsWidget extends StatelessWidget {
  final int count;

  const ItemsWidget({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Text(
      localizations.itemsCount(count),
    );
  }
}
```

### Date and Number Formatting

```dart
class FormattedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final now = DateTime.now();
    final price = 1234.56;

    return Column(
      children: [
        Text(
          localizations.lastUpdated(
            DateFormat.yMMMd(localizations.localeName).format(now),
          ),
        ),
        Text(
          NumberFormat.currency(
            locale: localizations.localeName,
            symbol: '\$',
          ).format(price),
        ),
      ],
    );
  }
}
```

### Changing Locale

```dart
class LocaleSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeController = ref.watch(localeControllerProvider);
    final currentLocale = localeController.locale;

    return DropdownButton<Locale>(
      value: currentLocale,
      items: const [
        DropdownMenuItem(
          value: Locale('en'),
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: Locale('ar'),
          child: Text('العربية'),
        ),
      ],
      onChanged: (locale) {
        if (locale != null) {
          ref.read(localeControllerProvider.notifier).setLocale(locale);
        }
      },
    );
  }
}
```

### RTL Support

```dart
class RTLWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Row(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Icon(Icons.arrow_back),
        SizedBox(width: 8),
        Text('Back'),
      ],
    );
  }
}
```

## 🧪 Testing

### Localization Tests

```dart
testWidgets('Should display English translations', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: MyWidget(),
    ),
  );

  expect(find.text('Welcome to Fast Golden Taxi'), findsOneWidget);
  expect(find.text('Login'), findsOneWidget);
});

testWidgets('Should display Arabic translations', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ar'),
      home: MyWidget(),
    ),
  );

  expect(find.text('مرحبًا بك في تاكسي الذهبي السريع'), findsOneWidget);
  expect(find.text('تسجيل الدخول'), findsOneWidget);
});
```

## 📚 Additional Resources

- [Flutter Internationalization](https://flutter.dev/docs/development/accessibility-and-internationalization/internationalization)
- [ARB Format](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)
- [Flutter Localizations](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html)

## 🤝 Contributing

When adding translations:

1. Add keys to all ARB files
2. Run code generation
3. Test all locales
4. Check RTL support
5. Update documentation

## 📄 License

This module is part of the Fast Golden Taxi project.