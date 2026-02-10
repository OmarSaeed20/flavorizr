# Shared Module

The shared module contains reusable utilities, domain models, and use cases that are used across multiple features in the Fast Golden Taxi application.

## 📁 Directory Structure

```
lib/shared/
├── domain/
│   ├── entities/          # Domain entities
│   ├── usecases/          # Base use case interfaces
│   └── value_objects/     # Value objects
├── utils/                 # Utility functions
├── widgets/               # Shared widgets
├── constants/             # App constants
└── extensions/            # Dart extensions
```

## 🎯 Key Components

### 1. Use Cases (`domain/usecases/`)

Base use case interfaces for business logic.

**UseCase<T, Params>:**
- Synchronous use case interface
- Returns `UseCaseResult<T>`
- Takes parameters of type `Params`

**StreamUseCase<T, Params>:**
- Asynchronous stream use case interface
- Returns `Stream<UseCaseResult<T>>`
- Takes parameters of type `Params`

**Usage:**
```dart
// Define a use case
class GetUserUseCase extends UseCase<User, String> {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  @override
  UseCaseResult<User> call(String userId) {
    try {
      final user = repository.getUserById(userId);
      return UseCaseResult.success(user);
    } catch (e) {
      return UseCaseResult.failure(e.toString());
    }
  }
}

// Use the use case
final useCase = GetUserUseCase(repository);
final result = useCase.call('user123');

result.fold(
  (user) => print('User: ${user.name}'),
  (error) => print('Error: $error'),
);
```

**UseCaseResult<T>:**
```dart
sealed class UseCaseResult<T> {
  const UseCaseResult();

  const factory UseCaseResult.success(T data) = Success;
  const factory UseCaseResult.failure(String error) = Failure;

  bool get isSuccess => this is Success;
  bool get isFailure => this is Failure;

  T? get data => switch (this) {
    Success(:final data) => data,
    _ => null,
  };

  String? get error => switch (this) {
    Failure(:final error) => error,
    _ => null,
  };

  R fold<R>(R Function(T data) onSuccess, R Function(String error) onFailure) {
    return switch (this) {
      Success(:final data) => onSuccess(data),
      Failure(:final error) => onFailure(error),
    };
  }
}
```

### 2. Domain Entities (`domain/entities/`)

Domain entities represent business objects.

**Example:**
```dart
class User {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

### 3. Value Objects (`domain/value_objects/`)

Value objects are immutable objects that represent a concept in the domain.

**Example:**
```dart
class EmailAddress {
  final String value;

  const EmailAddress(this.value);

  bool get isValid => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailAddress && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
```

### 4. Utilities (`utils/`)

Utility functions for common operations.

**Common Utilities:**
- Date/time formatting
- String manipulation
- Validation
- Formatting

**Example:**
```dart
// Date utilities
final formattedDate = DateUtils.formatDate(DateTime.now());
final relativeTime = DateUtils.getRelativeTime(DateTime.now());

// String utilities
final slug = StringUtils.slugify('Hello World'); // 'hello-world'
final initials = StringUtils.getInitials('John Doe'); // 'JD'

// Validation
final isValidEmail = ValidationUtils.isValidEmail('test@example.com');
final isValidPhone = ValidationUtils.isValidPhone('+1234567890');
```

### 5. Shared Widgets (`widgets/`)

Reusable widgets used across multiple features.

**Common Widgets:**
- Loading indicators
- Error widgets
- Empty state widgets
- Action buttons
- Cards
- Lists

**Example:**
```dart
// Loading widget
const LoadingWidget();

// Error widget
ErrorWidget(
  message: 'Something went wrong',
  onRetry: () => retry(),
);

// Empty state widget
EmptyStateWidget(
  icon: Icons.inbox,
  title: 'No items found',
  message: 'Try adjusting your filters',
);
```

### 6. Constants (`constants/`)

App-wide constants.

**Common Constants:**
```dart
// App constants
class AppConstants {
  static const String appName = 'Fast Golden Taxi';
  static const String appVersion = '1.0.0';

  // API constants
  static const int defaultTimeout = 30;
  static const int maxRetryAttempts = 3;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Storage keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyTheme = 'theme';
  static const String keyLocale = 'locale';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minPhoneNumberLength = 10;
  static const int maxPhoneNumberLength = 15;
}
```

### 7. Extensions (`extensions/`)

Dart extensions for common types.

**Common Extensions:**
```dart
// String extensions
extension StringExtensions on String {
  bool get isValidEmail => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  bool get isNotEmpty => this.isNotEmpty;
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}

// DateTime extensions
extension DateTimeExtensions on DateTime {
  String toFormattedDate() => DateFormat('yyyy-MM-dd').format(this);
  String toFormattedTime() => DateFormat('HH:mm').format(this);
  bool get isToday => DateTime.now().difference(this).inDays == 0;
}

// BuildContext extensions
extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  Size get screenSize => MediaQuery.of(this).size;
  bool get isKeyboardOpen => MediaQuery.of(this).viewInsets.bottom > 0;
}
```

## 🏗️ Architecture

### Domain Layer

```
Domain Layer
├── Entities (Business objects)
├── Value Objects (Immutable concepts)
└── Use Cases (Business logic)
```

### Use Case Pattern

```
Use Case
├── Input (Parameters)
├── Output (UseCaseResult<T>)
└── Dependencies (Repositories, Services)
```

## 📝 Best Practices

### 1. Use Use Cases for Business Logic

```dart
// Good
class GetUserUseCase extends UseCase<User, String> {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  @override
  UseCaseResult<User> call(String userId) {
    // Business logic here
  }
}

// Bad
// Put business logic directly in UI
```

### 2. Use Value Objects for Domain Concepts

```dart
// Good
class EmailAddress {
  final String value;
  const EmailAddress(this.value);
  bool get isValid => /* validation */;
}

// Bad
// Use raw strings for email addresses
```

### 3. Keep Entities Immutable

```dart
// Good
class User {
  final String id;
  final String name;
  const User({required this.id, required this.name});
}

// Bad
class User {
  String id;
  String name;
}
```

### 4. Use Result Types for Error Handling

```dart
// Good
final result = useCase.call(params);
result.fold(
  (data) => showData(data),
  (error) => showError(error),
);

// Bad
try {
  final data = useCase.call(params);
  showData(data);
} catch (e) {
  showError(e);
}
```

### 5. Create Reusable Widgets

```dart
// Good
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const PrimaryButton({required this.label, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

// Bad
// Repeat button code everywhere
```

## 🔧 Usage Examples

### Creating a Use Case

```dart
// 1. Define the use case
class GetUserProfileUseCase extends UseCase<UserProfile, String> {
  final UserRepository repository;
  final CacheService cache;

  GetUserProfileUseCase(this.repository, this.cache);

  @override
  UseCaseResult<UserProfile> call(String userId) {
    try {
      // Check cache first
      final cached = cache.get<UserProfile>('user_$userId');
      if (cached != null) {
        return UseCaseResult.success(cached);
      }

      // Fetch from repository
      final profile = repository.getUserProfile(userId);

      // Cache the result
      cache.set('user_$userId', profile);

      return UseCaseResult.success(profile);
    } catch (e) {
      return UseCaseResult.failure(e.toString());
    }
  }
}

// 2. Provide the use case
final getUserProfileProvider = Provider<GetUserProfileUseCase>((ref) {
  return GetUserProfileUseCase(
    ref.watch(userRepositoryProvider),
    ref.watch(cacheServiceProvider),
  );
});

// 3. Use the use case in a widget
class UserProfileWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useCase = ref.watch(getUserProfileProvider);
    final result = useCase.call('user123');

    return result.fold(
      (profile) => Text(profile.name),
      (error) => Text(error),
    );
  }
}
```

### Creating a Value Object

```dart
class PhoneNumber {
  final String value;

  const PhoneNumber(this.value);

  bool get isValid => RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value);

  String get formatted {
    // Format phone number
    return value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneNumber && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
```

### Creating a Shared Widget

```dart
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.all(16),
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? context.theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
```

## 🧪 Testing

### Unit Tests

```dart
test('GetUserProfileUseCase should return user profile', () {
  final mockRepository = MockUserRepository();
  final mockCache = MockCacheService();
  final useCase = GetUserProfileUseCase(mockRepository, mockCache);

  when(mockRepository.getUserProfile('user123'))
      .thenReturn(UserProfile(id: 'user123', name: 'John Doe'));

  final result = useCase.call('user123');

  expect(result.isSuccess, true);
  expect(result.data?.name, 'John Doe');
});
```

### Widget Tests

```dart
testWidgets('AppCard should display child', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: AppCard(
          child: const Text('Test'),
        ),
      ),
    ),
  );

  expect(find.text('Test'), findsOneWidget);
});
```

## 📚 Additional Resources

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Domain-Driven Design](https://martinfowler.com/bliki/DomainDrivenDesign.html)
- [Value Objects](https://martinfowler.com/bliki/ValueObject.html)

## 🤝 Contributing

When adding to the shared module:

1. Keep it generic and reusable
2. Add comprehensive documentation
3. Write tests
4. Follow existing patterns
5. Update this README

## 📄 License

This module is part of the Fast Golden Taxi project.