# Phase 7 — Testing & Quality Assurance

> **Duration:** 2-3 weeks  
> **Priority:** High  
> **Dependencies:** Phases 1-6

---

## 📋 Overview

Phase 7 establishes comprehensive testing infrastructure and quality assurance processes. This phase ensures the app is reliable, maintainable, and production-ready.

**Key Deliverables:**
- Unit testing framework
- Widget testing framework
- Integration testing framework
- Golden (screenshot) testing
- Performance testing
- Code quality tools

---

## 🎯 Goals

| Goal | Success Criteria |
|------|------------------|
| Unit Tests | >80% code coverage |
| Widget Tests | All critical UI components tested |
| Integration Tests | E2E tests for critical flows |
| Golden Tests | Visual regression testing in place |
| Performance | Benchmarks for critical paths |
| Code Quality | Linting, formatting, analysis clean |

---

## 📁 Tasks Breakdown

### Task 7.1: Unit Testing Framework

**Estimated Time:** 3-4 days

#### Objectives
- Set up unit testing infrastructure
- Create test utilities and helpers
- Implement mock factories
- Establish testing patterns

#### Implementation Steps

1. **Create `test/helpers/test_helpers.dart`**
   ```dart
   import 'package:flutter_test/flutter_test.dart';
   import 'package:mocktail/mocktail.dart';
   
   /// Initialize test helpers and fallback values.
   /// 
   /// Call this in setUpAll for any test file that uses mocks.
   /// 
   /// Example:
   /// ```dart
   /// void main() {
   ///   setUpAll(() {
   ///     initializeTestHelpers();
   ///   });
   /// }
   /// ```
   void initializeTestHelpers() {
     // Register fallback values for common types
     registerFallbackValue(Uri());
     registerFallbackValue(StackTrace.empty);
     registerFallbackValue(Duration.zero);
     registerFallbackValue(DateTime(2024));
     
     // Register fallback values for custom types
     // registerFallbackValue(FakeUser());
     // registerFallbackValue(FakeAnalyticsEvent());
   }
   
   /// Helper for testing async operations with timeout.
   Future<T> expectAsync<T>(
     Future<T> Function() operation, {
     Duration timeout = const Duration(seconds: 5),
   }) async {
     return await operation().timeout(timeout);
   }
   
   /// Helper for expecting an async operation to throw.
   Future<void> expectAsyncThrows<E extends Exception>(
     Future<void> Function() operation, {
     String? message,
   }) async {
     try {
       await operation();
       fail('Expected $E to be thrown${message != null ? ': $message' : ''}');
     } on E {
       // Expected
     }
   }
   
   /// Helper for testing stream emissions.
   Future<List<T>> collectStreamEvents<T>(
     Stream<T> stream, {
     int count = 1,
     Duration timeout = const Duration(seconds: 5),
   }) async {
     final events = <T>[];
     await for (final event in stream.take(count).timeout(timeout)) {
       events.add(event);
     }
     return events;
   }
   
   /// Helper for testing debounced operations.
   Future<void> pumpDebounce(Duration duration) async {
     await Future.delayed(duration + const Duration(milliseconds: 50));
   }
   
   /// Matcher for checking that a function was called with specific arguments.
   Matcher calledWithArgs(List<dynamic> args) {
     return predicate<Invocation>((invocation) {
       if (invocation.positionalArguments.length != args.length) return false;
       for (var i = 0; i < args.length; i++) {
         if (invocation.positionalArguments[i] != args[i]) return false;
       }
       return true;
     });
   }
   
   /// Extension for easier verification in tests.
   extension VerifyExtension on VerificationResult {
     /// Verify the call was made exactly [count] times.
     void calledExactly(int count) {
       called(count);
     }
     
     /// Verify the call was never made.
     void neverCalled() {
       called(0);
     }
   }
   ```

2. **Create `test/helpers/mock_factories.dart`**
   ```dart
   import 'package:mocktail/mocktail.dart';
   
   // Import your app's classes
   // import 'package:your_app/core/network/api_client.dart';
   // import 'package:your_app/services/auth_service.dart';
   
   /// Mock classes using mocktail.
   /// 
   /// Example usage:
   /// ```dart
   /// final mockApi = MockApiClient();
   /// when(() => mockApi.get(any())).thenAnswer((_) async => Response());
   /// ```
   
   // class MockApiClient extends Mock implements ApiClient {}
   // class MockAuthService extends Mock implements AuthService {}
   // class MockAnalyticsService extends Mock implements AnalyticsService {}
   // class MockStorageService extends Mock implements StorageService {}
   // class MockConnectivityService extends Mock implements ConnectivityService {}
   
   /// Factory for creating configured mock instances.
   class MockFactory {
     /// Creates a mock API client with common stubbed methods.
     // static MockApiClient createApiClient({
     //   bool shouldFail = false,
     //   Exception? failWith,
     // }) {
     //   final mock = MockApiClient();
     //   
     //   if (shouldFail) {
     //     when(() => mock.get(any())).thenThrow(failWith ?? Exception('API Error'));
     //     when(() => mock.post(any(), any())).thenThrow(failWith ?? Exception('API Error'));
     //   } else {
     //     when(() => mock.get(any())).thenAnswer((_) async => ApiResponse.success({}));
     //     when(() => mock.post(any(), any())).thenAnswer((_) async => ApiResponse.success({}));
     //   }
     //   
     //   return mock;
     // }
     
     /// Creates a mock auth service with a logged-in user.
     // static MockAuthService createAuthService({
     //   User? currentUser,
     //   bool isLoggedIn = true,
     // }) {
     //   final mock = MockAuthService();
     //   
     //   when(() => mock.isLoggedIn).thenReturn(isLoggedIn);
     //   when(() => mock.currentUser).thenReturn(currentUser ?? FakeUser());
     //   when(() => mock.userStream).thenAnswer((_) => Stream.value(currentUser));
     //   
     //   return mock;
     // }
   }
   
   /// Fake implementations for testing.
   /// 
   /// Use these when you need objects that can be passed as arguments
   /// but don't need to verify interactions.
   
   // class FakeUser extends Fake implements User {
   //   @override
   //   String get id => 'test-user-id';
   //   
   //   @override
   //   String get email => 'test@example.com';
   //   
   //   @override
   //   String get displayName => 'Test User';
   // }
   
   // class FakeAnalyticsEvent extends Fake implements AnalyticsEvent {
   //   @override
   //   String get name => 'test_event';
   //   
   //   @override
   //   Map<String, dynamic> get properties => {};
   // }
   ```

3. **Create `test/helpers/test_fixtures.dart`**
   ```dart
   /// Test fixtures and sample data.
   /// 
   /// Provides consistent test data across all tests.
   class TestFixtures {
     TestFixtures._();
     
     // --- Users ---
     
     static const testUserId = 'user-123';
     static const testUserEmail = 'test@example.com';
     static const testUserName = 'Test User';
     
     // static User get validUser => User(
     //   id: testUserId,
     //   email: testUserEmail,
     //   displayName: testUserName,
     // );
     
     // static User get adminUser => User(
     //   id: 'admin-123',
     //   email: 'admin@example.com',
     //   displayName: 'Admin User',
     //   role: UserRole.admin,
     // );
     
     // --- API Responses ---
     
     static Map<String, dynamic> get successResponse => {
       'status': 'success',
       'data': {},
     };
     
     static Map<String, dynamic> get errorResponse => {
       'status': 'error',
       'message': 'Something went wrong',
       'code': 'GENERIC_ERROR',
     };
     
     static Map<String, dynamic> get validationErrorResponse => {
       'status': 'error',
       'message': 'Validation failed',
       'code': 'VALIDATION_ERROR',
       'errors': {
         'email': ['Invalid email format'],
         'password': ['Password too short'],
       },
     };
     
     // --- Dates ---
     
     static DateTime get fixedDate => DateTime(2024, 1, 15, 12, 0, 0);
     static DateTime get pastDate => DateTime(2023, 6, 1);
     static DateTime get futureDate => DateTime(2025, 12, 31);
     
     // --- Tokens ---
     
     static const validAccessToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test';
     static const validRefreshToken = 'refresh-token-test';
     static const expiredToken = 'expired-token';
     
     // --- Strings ---
     
     static const validEmail = 'valid@example.com';
     static const invalidEmail = 'not-an-email';
     static const validPassword = 'SecureP@ss123';
     static const weakPassword = '123';
     
     // --- Collections ---
     
     // static List<Product> get sampleProducts => [
     //   Product(id: '1', name: 'Product 1', price: 9.99),
     //   Product(id: '2', name: 'Product 2', price: 19.99),
     //   Product(id: '3', name: 'Product 3', price: 29.99),
     // ];
   }
   
   /// Extension for creating variations of fixtures.
   extension FixtureVariations<T> on T {
     /// Create a list of this item.
     List<T> repeat(int count) => List.generate(count, (_) => this);
   }
   ```

4. **Create `test/unit/example_service_test.dart`**
   ```dart
   import 'package:flutter_test/flutter_test.dart';
   import 'package:mocktail/mocktail.dart';
   
   // Import the class under test and its dependencies
   // import 'package:your_app/services/example_service.dart';
   
   import '../helpers/test_helpers.dart';
   import '../helpers/mock_factories.dart';
   import '../helpers/test_fixtures.dart';
   
   void main() {
     // Initialize mocks before all tests
     setUpAll(() {
       initializeTestHelpers();
     });
     
     group('ExampleService', () {
       // Declare mocks and class under test
       // late MockApiClient mockApi;
       // late MockStorageService mockStorage;
       // late ExampleService service;
       
       setUp(() {
         // Reset mocks before each test
         // mockApi = MockApiClient();
         // mockStorage = MockStorageService();
         // service = ExampleService(api: mockApi, storage: mockStorage);
       });
       
       group('fetchData', () {
         test('returns data when API call succeeds', () async {
           // Arrange
           // when(() => mockApi.get('/data'))
           //     .thenAnswer((_) async => ApiResponse.success({'value': 42}));
           
           // Act
           // final result = await service.fetchData();
           
           // Assert
           // expect(result, isNotNull);
           // expect(result.value, equals(42));
           // verify(() => mockApi.get('/data')).called(1);
         });
         
         test('throws exception when API call fails', () async {
           // Arrange
           // when(() => mockApi.get('/data'))
           //     .thenThrow(NetworkException('No connection'));
           
           // Act & Assert
           // expect(
           //   () => service.fetchData(),
           //   throwsA(isA<NetworkException>()),
           // );
         });
         
         test('caches result in storage', () async {
           // Arrange
           // when(() => mockApi.get('/data'))
           //     .thenAnswer((_) async => ApiResponse.success({'value': 42}));
           // when(() => mockStorage.save(any(), any()))
           //     .thenAnswer((_) async {});
           
           // Act
           // await service.fetchData();
           
           // Assert
           // verify(() => mockStorage.save('data_cache', any())).called(1);
         });
       });
       
       group('processItems', () {
         test('processes all items in list', () {
           // Arrange
           // final items = [Item(1), Item(2), Item(3)];
           
           // Act
           // final result = service.processItems(items);
           
           // Assert
           // expect(result.length, equals(3));
           // expect(result.every((r) => r.isProcessed), isTrue);
         });
         
         test('handles empty list', () {
           // Arrange & Act
           // final result = service.processItems([]);
           
           // Assert
           // expect(result, isEmpty);
         });
         
         test('filters out invalid items', () {
           // Arrange
           // final items = [
           //   Item(1, isValid: true),
           //   Item(2, isValid: false),
           //   Item(3, isValid: true),
           // ];
           
           // Act
           // final result = service.processItems(items);
           
           // Assert
           // expect(result.length, equals(2));
         });
       });
     });
   }
   ```

#### Acceptance Criteria
- [ ] Test helpers are reusable across tests
- [ ] Mock factories produce consistent mocks
- [ ] Fixtures provide standard test data
- [ ] Unit tests follow AAA pattern
- [ ] Tests are isolated and deterministic

---

### Task 7.2: Widget Testing Framework

**Estimated Time:** 3-4 days

#### Objectives
- Set up widget testing infrastructure
- Create widget test utilities
- Test common widget patterns
- Implement accessibility tests

#### Implementation Steps

1. **Create `test/helpers/widget_test_helpers.dart`**
   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter_test/flutter_test.dart';
   // import 'package:provider/provider.dart';
   // import 'package:flutter_bloc/flutter_bloc.dart';
   
   /// Wraps a widget with all necessary providers for testing.
   /// 
   /// Example:
   /// ```dart
   /// await tester.pumpWidget(
   ///   testableWidget(
   ///     child: MyWidget(),
   ///     providers: [
   ///       Provider<AuthService>.value(value: mockAuthService),
   ///     ],
   ///   ),
   /// );
   /// ```
   Widget testableWidget({
     required Widget child,
     List<dynamic>? providers,
     ThemeData? theme,
     Locale? locale,
     NavigatorObserver? navigatorObserver,
   }) {
     Widget widget = child;
     
     // Wrap with providers if any
     // if (providers != null && providers.isNotEmpty) {
     //   widget = MultiProvider(
     //     providers: providers.cast<SingleChildWidget>(),
     //     child: widget,
     //   );
     // }
     
     return MaterialApp(
       home: widget,
       theme: theme ?? ThemeData.light(),
       locale: locale,
       navigatorObservers: navigatorObserver != null ? [navigatorObserver] : [],
       // Disable animations for faster tests
       debugShowCheckedModeBanner: false,
     );
   }
   
   /// Wraps a widget with a Scaffold for testing.
   Widget scaffoldWidget({
     required Widget child,
     ThemeData? theme,
   }) {
     return testableWidget(
       theme: theme,
       child: Scaffold(
         body: child,
       ),
     );
   }
   
   /// Extension methods for WidgetTester.
   extension WidgetTesterExtensions on WidgetTester {
     /// Pump a widget and settle all animations.
     Future<void> pumpWidgetAndSettle(Widget widget) async {
       await pumpWidget(widget);
       await pumpAndSettle();
     }
     
     /// Find a widget by key and tap it.
     Future<void> tapByKey(Key key) async {
       await tap(find.byKey(key));
       await pumpAndSettle();
     }
     
     /// Find a widget by type and tap it.
     Future<void> tapByType(Type type) async {
       await tap(find.byType(type).first);
       await pumpAndSettle();
     }
     
     /// Find a button by text and tap it.
     Future<void> tapButton(String text) async {
       await tap(find.text(text));
       await pumpAndSettle();
     }
     
     /// Enter text into a TextField by key.
     Future<void> enterTextByKey(Key key, String text) async {
       await enterText(find.byKey(key), text);
       await pumpAndSettle();
     }
     
     /// Enter text into a TextField by label.
     Future<void> enterTextByLabel(String label, String text) async {
       final finder = find.widgetWithText(TextField, label);
       await enterText(finder, text);
       await pumpAndSettle();
     }
     
     /// Scroll until a widget is visible.
     Future<void> scrollUntilVisible(
       Finder finder, {
       double delta = 100,
       int maxScrolls = 50,
     }) async {
       int scrollCount = 0;
       while (!finder.evaluate().isNotEmpty && scrollCount < maxScrolls) {
         await drag(find.byType(Scrollable).first, Offset(0, -delta));
         await pumpAndSettle();
         scrollCount++;
       }
     }
     
     /// Wait for a duration (useful for debounced operations).
     Future<void> wait(Duration duration) async {
       await pump(duration);
     }
     
     /// Get the text of a Text widget.
     String? getTextContent(Finder finder) {
       final textWidget = widget<Text>(finder);
       return textWidget.data;
     }
     
     /// Check if a widget is enabled.
     bool isEnabled(Finder finder) {
       final widget = firstWidget(finder);
       if (widget is ElevatedButton) {
         return widget.onPressed != null;
       }
       if (widget is TextButton) {
         return widget.onPressed != null;
       }
       if (widget is IconButton) {
         return widget.onPressed != null;
       }
       return true;
     }
   }
   
   /// Custom finders for common patterns.
   class CustomFinders {
     /// Find a widget with a semantic label.
     static Finder bySemanticLabel(String label) {
       return find.bySemanticsLabel(label);
     }
     
     /// Find an icon button by icon.
     static Finder iconButton(IconData icon) {
       return find.widgetWithIcon(IconButton, icon);
     }
     
     /// Find a text field by hint text.
     static Finder textFieldByHint(String hint) {
       return find.widgetWithText(TextField, hint);
     }
     
     /// Find a list tile by title.
     static Finder listTileByTitle(String title) {
       return find.widgetWithText(ListTile, title);
     }
     
     /// Find a snackbar with text.
     static Finder snackBar(String text) {
       return find.descendant(
         of: find.byType(SnackBar),
         matching: find.text(text),
       );
     }
     
     /// Find a dialog with title.
     static Finder dialog(String title) {
       return find.descendant(
         of: find.byType(AlertDialog),
         matching: find.text(title),
       );
     }
   }
   ```

2. **Create `test/helpers/accessibility_test_helpers.dart`**
   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter_test/flutter_test.dart';
   
   /// Helpers for testing accessibility.
   class AccessibilityTestHelpers {
     /// Verify that all tappable elements have semantic labels.
     static void verifyTappableSemantics(WidgetTester tester) {
       final tappableWidgets = find.byWidgetPredicate((widget) {
         return widget is GestureDetector ||
             widget is InkWell ||
             widget is ElevatedButton ||
             widget is TextButton ||
             widget is IconButton;
       });
       
       for (final element in tappableWidgets.evaluate()) {
         final semantics = tester.getSemantics(find.byWidget(element.widget));
         expect(
           semantics.label.isNotEmpty || semantics.hint.isNotEmpty,
           isTrue,
           reason: '${element.widget.runtimeType} missing semantic label',
         );
       }
     }
     
     /// Verify that all images have semantic descriptions.
     static void verifyImageSemantics(WidgetTester tester) {
       final images = find.byType(Image);
       
       for (final element in images.evaluate()) {
         final semantics = tester.getSemantics(find.byWidget(element.widget));
         // Images should either have a label or be marked as decorative
         expect(
           semantics.label.isNotEmpty || 
           semantics.flags.contains(SemanticsFlag.isImage) == false,
           isTrue,
           reason: 'Image missing semantic description',
         );
       }
     }
     
     /// Verify that text fields have labels.
     static void verifyTextFieldLabels(WidgetTester tester) {
       final textFields = find.byType(TextField);
       
       for (final element in textFields.evaluate()) {
         final textField = element.widget as TextField;
         expect(
           textField.decoration?.labelText != null ||
           textField.decoration?.hintText != null,
           isTrue,
           reason: 'TextField missing label or hint',
         );
       }
     }
     
     /// Verify color contrast meets WCAG AA standards.
     static void verifyColorContrast(
       Color foreground,
       Color background, {
       bool largeText = false,
     }) {
       final ratio = _calculateContrastRatio(foreground, background);
       final minimumRatio = largeText ? 3.0 : 4.5;
       
       expect(
         ratio >= minimumRatio,
         isTrue,
         reason: 'Contrast ratio $ratio does not meet WCAG AA (minimum: $minimumRatio)',
       );
     }
     
     /// Calculate contrast ratio between two colors.
     static double _calculateContrastRatio(Color color1, Color color2) {
       final l1 = _relativeLuminance(color1);
       final l2 = _relativeLuminance(color2);
       final lighter = l1 > l2 ? l1 : l2;
       final darker = l1 > l2 ? l2 : l1;
       return (lighter + 0.05) / (darker + 0.05);
     }
     
     /// Calculate relative luminance of a color.
     static double _relativeLuminance(Color color) {
       double r = color.red / 255;
       double g = color.green / 255;
       double b = color.blue / 255;
       
       r = r <= 0.03928 ? r / 12.92 : ((r + 0.055) / 1.055).pow(2.4);
       g = g <= 0.03928 ? g / 12.92 : ((g + 0.055) / 1.055).pow(2.4);
       b = b <= 0.03928 ? b / 12.92 : ((b + 0.055) / 1.055).pow(2.4);
       
       return 0.2126 * r + 0.7152 * g + 0.0722 * b;
     }
   }
   
   /// Extension for num.pow().
   extension NumPow on double {
     double pow(double exponent) => 
         this == 0 ? 0 : (this > 0 ? this : -this).pow(exponent);
   }
   ```

3. **Create `test/widget/example_widget_test.dart`**
   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter_test/flutter_test.dart';
   
   import '../helpers/widget_test_helpers.dart';
   import '../helpers/accessibility_test_helpers.dart';
   
   void main() {
     group('ExampleWidget', () {
       testWidgets('renders correctly', (tester) async {
         // Arrange & Act
         await tester.pumpWidgetAndSettle(
           testableWidget(
             child: const Placeholder(), // Replace with your widget
           ),
         );
         
         // Assert
         expect(find.byType(Placeholder), findsOneWidget);
       });
       
       testWidgets('shows loading indicator while loading', (tester) async {
         // Arrange
         await tester.pumpWidget(
           testableWidget(
             child: const Center(
               child: CircularProgressIndicator(),
             ),
           ),
         );
         
         // Assert
         expect(find.byType(CircularProgressIndicator), findsOneWidget);
       });
       
       testWidgets('displays error message on error', (tester) async {
         // Arrange
         const errorMessage = 'Something went wrong';
         
         await tester.pumpWidgetAndSettle(
           testableWidget(
             child: const Center(
               child: Text(errorMessage),
             ),
           ),
         );
         
         // Assert
         expect(find.text(errorMessage), findsOneWidget);
       });
       
       testWidgets('handles tap interaction', (tester) async {
         // Arrange
         var tapped = false;
         
         await tester.pumpWidgetAndSettle(
           testableWidget(
             child: ElevatedButton(
               onPressed: () => tapped = true,
               child: const Text('Tap me'),
             ),
           ),
         );
         
         // Act
         await tester.tapButton('Tap me');
         
         // Assert
         expect(tapped, isTrue);
       });
       
       testWidgets('validates form input', (tester) async {
         // Arrange
         await tester.pumpWidgetAndSettle(
           testableWidget(
             child: Scaffold(
               body: TextField(
                 key: const Key('email_field'),
                 decoration: const InputDecoration(
                   labelText: 'Email',
                   errorText: null,
                 ),
               ),
             ),
           ),
         );
         
         // Act
         await tester.enterTextByKey(const Key('email_field'), 'invalid');
         
         // Assert - would need actual validation logic
         // expect(find.text('Invalid email'), findsOneWidget);
       });
       
       testWidgets('navigates to next screen', (tester) async {
         // Arrange
         await tester.pumpWidgetAndSettle(
           MaterialApp(
             home: Builder(
               builder: (context) => ElevatedButton(
                 onPressed: () {
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (_) => const Scaffold(
                         body: Center(child: Text('Next Screen')),
                       ),
                     ),
                   );
                 },
                 child: const Text('Navigate'),
               ),
             ),
           ),
         );
         
         // Act
         await tester.tapButton('Navigate');
         
         // Assert
         expect(find.text('Next Screen'), findsOneWidget);
       });
       
       group('accessibility', () {
         testWidgets('has proper semantics', (tester) async {
           await tester.pumpWidgetAndSettle(
             testableWidget(
               child: Semantics(
                 label: 'Example widget',
                 child: const Placeholder(),
               ),
             ),
           );
           
           // Verify semantics
           final semantics = tester.getSemantics(find.byType(Placeholder));
           expect(semantics.label, equals('Example widget'));
         });
         
         testWidgets('all interactive elements have labels', (tester) async {
           await tester.pumpWidgetAndSettle(
             testableWidget(
               child: Column(
                 children: [
                   Semantics(
                     label: 'Submit button',
                     child: ElevatedButton(
                       onPressed: () {},
                       child: const Text('Submit'),
                     ),
                   ),
                 ],
               ),
             ),
           );
           
           AccessibilityTestHelpers.verifyTappableSemantics(tester);
         });
       });
     });
   }
   ```

#### Acceptance Criteria
- [ ] Widget test helpers simplify common operations
- [ ] Accessibility tests verify semantic labels
- [ ] Navigation tests verify routing
- [ ] Form tests verify validation
- [ ] All critical widgets have tests

---

### Task 7.3: Integration Testing Framework

**Estimated Time:** 3-4 days

#### Objectives
- Set up integration test infrastructure
- Create E2E test scenarios
- Implement test data management
- Handle authentication in tests

#### Implementation Steps

1. **Create `integration_test/test_config.dart`**
   ```dart
   /// Configuration for integration tests.
   class TestConfig {
     TestConfig._();
     
     /// Base URL for test API.
     static const String apiBaseUrl = 'https://api-test.example.com';
     
     /// Test user credentials.
     static const String testUserEmail = 'test@example.com';
     static const String testUserPassword = 'TestPassword123!';
     
     /// Test timeout durations.
     static const Duration shortTimeout = Duration(seconds: 5);
     static const Duration mediumTimeout = Duration(seconds: 15);
     static const Duration longTimeout = Duration(seconds: 30);
     
     /// Whether to use mock data.
     static const bool useMockData = false;
     
     /// Screenshot directory.
     static const String screenshotDir = 'test_screenshots';
   }
   ```

2. **Create `integration_test/helpers/integration_test_helpers.dart`**
   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter_test/flutter_test.dart';
   import 'package:integration_test/integration_test.dart';
   
   import '../test_config.dart';
   
   /// Helpers for integration tests.
   class IntegrationTestHelpers {
     final IntegrationTestWidgetsFlutterBinding binding;
     
     IntegrationTestHelpers(this.binding);
     
     /// Take a screenshot with a descriptive name.
     Future<void> takeScreenshot(String name) async {
       await binding.takeScreenshot(name);
     }
     
     /// Wait for network operation to complete.
     Future<void> waitForNetwork(WidgetTester tester) async {
       // Wait for loading indicators to disappear
       await tester.pumpAndSettle(TestConfig.mediumTimeout);
       
       // Additional wait for any debounced operations
       await tester.pump(const Duration(milliseconds: 500));
     }
     
     /// Login with test credentials.
     Future<void> login(WidgetTester tester) async {
       // Navigate to login screen if needed
       // Enter credentials
       // await tester.enterText(
       //   find.byKey(const Key('email_field')),
       //   TestConfig.testUserEmail,
       // );
       // await tester.enterText(
       //   find.byKey(const Key('password_field')),
       //   TestConfig.testUserPassword,
       // );
       // await tester.tap(find.byKey(const Key('login_button')));
       // await waitForNetwork(tester);
     }
     
     /// Logout.
     Future<void> logout(WidgetTester tester) async {
       // Navigate to settings and logout
       // await tester.tap(find.byIcon(Icons.settings));
       // await tester.pumpAndSettle();
       // await tester.tap(find.text('Logout'));
       // await tester.pumpAndSettle();
     }
     
     /// Reset app state for clean test.
     Future<void> resetAppState() async {
       // Clear local storage
       // Reset authentication
       // Clear caches
     }
     
     /// Scroll to find a widget.
     Future<void> scrollToWidget(
       WidgetTester tester,
       Finder finder, {
       double step = 100,
       Duration duration = const Duration(milliseconds: 100),
     }) async {
       final scrollable = find.byType(Scrollable).first;
       int attempts = 0;
       const maxAttempts = 50;
       
       while (!finder.evaluate().isNotEmpty && attempts < maxAttempts) {
         await tester.drag(scrollable, Offset(0, -step));
         await tester.pump(duration);
         attempts++;
       }
       
       if (attempts >= maxAttempts) {
         throw Exception('Could not find widget after $maxAttempts scroll attempts');
       }
       
       await tester.pumpAndSettle();
     }
   }
   ```

3. **Create `integration_test/flows/auth_flow_test.dart`**
   ```dart
   import 'package:flutter_test/flutter_test.dart';
   import 'package:integration_test/integration_test.dart';
   
   // import 'package:your_app/main.dart' as app;
   
   import '../test_config.dart';
   import '../helpers/integration_test_helpers.dart';
   
   void main() {
     IntegrationTestWidgetsFlutterBinding.ensureInitialized();
     final binding = IntegrationTestWidgetsFlutterBinding.instance;
     
     late IntegrationTestHelpers helpers;
     
     setUpAll(() {
       helpers = IntegrationTestHelpers(binding);
     });
     
     setUp(() async {
       await helpers.resetAppState();
     });
     
     group('Authentication Flow', () {
       testWidgets('user can login with valid credentials', (tester) async {
         // Start the app
         // app.main();
         // await tester.pumpAndSettle();
         
         // Take initial screenshot
         await helpers.takeScreenshot('1_login_screen');
         
         // Enter email
         // await tester.enterText(
         //   find.byKey(const Key('email_field')),
         //   TestConfig.testUserEmail,
         // );
         
         // Enter password
         // await tester.enterText(
         //   find.byKey(const Key('password_field')),
         //   TestConfig.testUserPassword,
         // );
         
         // Tap login button
         // await tester.tap(find.byKey(const Key('login_button')));
         
         // Wait for login to complete
         await helpers.waitForNetwork(tester);
         
         // Take screenshot of home screen
         await helpers.takeScreenshot('2_home_screen');
         
         // Verify we're on the home screen
         // expect(find.byKey(const Key('home_screen')), findsOneWidget);
       });
       
       testWidgets('user sees error with invalid credentials', (tester) async {
         // Start the app
         // app.main();
         // await tester.pumpAndSettle();
         
         // Enter invalid credentials
         // await tester.enterText(
         //   find.byKey(const Key('email_field')),
         //   'invalid@example.com',
         // );
         // await tester.enterText(
         //   find.byKey(const Key('password_field')),
         //   'wrongpassword',
         // );
         
         // Tap login button
         // await tester.tap(find.byKey(const Key('login_button')));
         
         // Wait for error
         await helpers.waitForNetwork(tester);
         
         // Verify error is shown
         // expect(find.text('Invalid credentials'), findsOneWidget);
         
         await helpers.takeScreenshot('3_login_error');
       });
       
       testWidgets('user can logout', (tester) async {
         // Start the app and login
         // app.main();
         // await tester.pumpAndSettle();
         // await helpers.login(tester);
         
         // Logout
         // await helpers.logout(tester);
         
         // Verify we're on the login screen
         // expect(find.byKey(const Key('login_screen')), findsOneWidget);
       });
     });
   }
   ```

#### Acceptance Criteria
- [ ] Integration tests cover critical user flows
- [ ] Tests can run on CI/CD
- [ ] Screenshots are captured at key steps
- [ ] Test data is managed properly
- [ ] Tests are reliable and non-flaky

---

### Task 7.4: Golden Testing

**Estimated Time:** 2-3 days

*(Golden/screenshot testing implementation)*

---

### Task 7.5: Performance Testing

**Estimated Time:** 2-3 days

*(Performance benchmarking implementation)*

---

### Task 7.6: Code Quality Tools

**Estimated Time:** 2-3 days

*(Linting, formatting, and analysis configuration)*

---

## 📊 Phase 7 Checklist

| Task | Status | Notes |
|------|--------|-------|
| 7.1 Unit Testing | ⬜ | |
| 7.2 Widget Testing | ⬜ | |
| 7.3 Integration Testing | ⬜ | |
| 7.4 Golden Testing | ⬜ | |
| 7.5 Performance Testing | ⬜ | |
| 7.6 Code Quality | ⬜ | |

---

## 🔗 Dependencies for Next Phase

Phase 8 requires the following from Phase 7:
- ✅ Testing infrastructure for CI/CD
- ✅ Code quality tools for automated checks
- ✅ Performance benchmarks for monitoring

---

## 📝 Notes

- Aim for high coverage but prioritize critical paths
- Keep tests fast and maintainable
- Use mocks appropriately, don't over-mock
- Golden tests need careful maintenance
- Run tests in CI before every merge
