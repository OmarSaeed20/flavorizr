# Features Module

The features module contains all feature-specific implementations for the Fast Golden Taxi application. Each feature is organized as a self-contained module with its own domain, data, and presentation layers.

## 📁 Directory Structure

```
lib/features/
├── auth/                    # Authentication feature
│   ├── data/
│   │   ├── datasources/     # Remote and local data sources
│   │   ├── models/          # Data transfer objects
│   │   └── repositories/    # Repository implementations
│   ├── domain/
│   │   ├── entities/        # Domain entities
│   │   ├── repositories/    # Repository interfaces
│   │   └── usecases/        # Use cases
│   └── presentation/
│       ├── pages/           # Full-screen pages
│       ├── widgets/         # Feature-specific widgets
│       └── providers/       # Riverpod providers
├── consumer/                # Consumer feature
├── driver/                  # Driver feature
├── company/                 # Company feature
├── booking/                 # Booking feature
├── payment/                 # Payment feature
├── notification/            # Notification feature
└── settings/                # Settings feature
```

## 🎯 Feature Structure

Each feature follows a consistent structure:

### 1. Data Layer

**Purpose:** Handles data retrieval and storage.

**Components:**
- **Data Sources:** API clients, local storage, cache
- **Models:** Data transfer objects (DTOs)
- **Repositories:** Repository implementations

**Example:**
```dart
// data/datasources/auth_remote_data_source.dart
class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<AuthModel> login(String email, String password) async {
    final response = await apiClient.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    return AuthModel.fromJson(response.data);
  }
}

// data/models/auth_model.dart
@freezed
class AuthModel with _$AuthModel {
  const factory AuthModel({
    required String token,
    required User user,
  }) = _AuthModel;

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);
}

// data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
  );

  @override
  Future<Either<Failure, Auth>> login(String email, String password) async {
    try {
      final model = await remoteDataSource.login(email, password);
      await localDataSource.saveToken(model.token);
      return Right(model.toEntity());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
```

### 2. Domain Layer

**Purpose:** Contains business logic and domain models.

**Components:**
- **Entities:** Domain entities
- **Repositories:** Repository interfaces
- **Use Cases:** Business logic

**Example:**
```dart
// domain/entities/auth.dart
class Auth {
  final String token;
  final User user;

  const Auth({
    required this.token,
    required this.user,
  });
}

// domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<Either<Failure, Auth>> login(String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, Auth?>> getCurrentAuth();
}

// domain/usecases/login_usecase.dart
class LoginUseCase extends UseCase<Auth, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  UseCaseResult<Auth> call(LoginParams params) {
    try {
      final result = await repository.login(params.email, params.password);
      return result.fold(
        (auth) => UseCaseResult.success(auth),
        (failure) => UseCaseResult.failure(failure.message),
      );
    } catch (e) {
      return UseCaseResult.failure(e.toString());
    }
  }
}
```

### 3. Presentation Layer

**Purpose:** Handles UI and user interaction.

**Components:**
- **Pages:** Full-screen pages
- **Widgets:** Feature-specific widgets
- **Providers:** Riverpod state management

**Example:**
```dart
// presentation/providers/auth_provider.dart
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository repository;

  AuthNotifier(this.repository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    state = AuthLoading();
    final result = await repository.login(email, password);
    result.fold(
      (auth) => state = AuthAuthenticated(auth),
      (failure) => state = AuthError(failure.message),
    );
  }
}

// presentation/pages/login_page.dart
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authProvider);

    return Scaffold(
      body: state.when(
        initial: () => LoginForm(
          onLogin: (email, password) {
            ref.read(authProvider.notifier).login(email, password);
          },
        ),
        loading: () => const LoadingWidget(),
        authenticated: (auth) => HomePage(),
        error: (message) => ErrorWidget(message: message),
      ),
    );
  }
}
```

## 🏗️ Architecture

### Feature Architecture

```
Feature
├── Data Layer
│   ├── Data Sources (API, Local Storage)
│   ├── Models (DTOs)
│   └── Repository Implementations
├── Domain Layer
│   ├── Entities (Domain Models)
│   ├── Repository Interfaces
│   └── Use Cases (Business Logic)
└── Presentation Layer
    ├── Pages (Screens)
    ├── Widgets (Components)
    └── Providers (State Management)
```

### Data Flow

```
UI (Presentation Layer)
    ↓
Use Case (Domain Layer)
    ↓
Repository (Domain Layer)
    ↓
Data Source (Data Layer)
    ↓
API/Storage (External)
```

## 📝 Best Practices

### 1. Follow Clean Architecture

```dart
// Good - Domain layer doesn't depend on data layer
abstract class AuthRepository {
  Future<Either<Failure, Auth>> login(String email, String password);
}

// Bad - Domain layer depends on data layer
abstract class AuthRepository {
  Future<Either<Failure, AuthModel>> login(String email, String password);
}
```

### 2. Use Use Cases for Business Logic

```dart
// Good
class LoginUseCase extends UseCase<Auth, LoginParams> {
  final AuthRepository repository;

  @override
  UseCaseResult<Auth> call(LoginParams params) {
    // Business logic here
  }
}

// Bad
// Put business logic directly in UI or repository
```

### 3. Keep UI Separate from Business Logic

```dart
// Good
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authProvider);
    return /* UI code */;
  }
}

// Bad
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Business logic in UI
    final auth = await ref.read(authRepositoryProvider).login(email, password);
    return /* UI code */;
  }
}
```

### 4. Use Freezed for Immutable Models

```dart
// Good
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}

// Bad
class User {
  String id;
  String name;
  String email;
}
```

### 5. Handle Errors Properly

```dart
// Good
final result = await repository.login(email, password);
result.fold(
  (auth) => state = AuthAuthenticated(auth),
  (failure) => state = AuthError(failure.message),
);

// Bad
try {
  final auth = await repository.login(email, password);
  state = AuthAuthenticated(auth);
} catch (e) {
  state = AuthError(e.toString());
}
```

## 🔧 Creating a New Feature

### Step 1: Create Feature Structure

```bash
mkdir -p lib/features/my_feature/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{pages,widgets,providers}}
```

### Step 2: Define Domain Layer

```dart
// domain/entities/my_entity.dart
class MyEntity {
  final String id;
  final String name;

  const MyEntity({
    required this.id,
    required this.name,
  });
}

// domain/repositories/my_repository.dart
abstract class MyRepository {
  Future<Either<Failure, MyEntity>> getEntity(String id);
}

// domain/usecases/get_entity_usecase.dart
class GetEntityUseCase extends UseCase<MyEntity, String> {
  final MyRepository repository;

  GetEntityUseCase(this.repository);

  @override
  UseCaseResult<MyEntity> call(String id) {
    try {
      final result = await repository.getEntity(id);
      return result.fold(
        (entity) => UseCaseResult.success(entity),
        (failure) => UseCaseResult.failure(failure.message),
      );
    } catch (e) {
      return UseCaseResult.failure(e.toString());
    }
  }
}
```

### Step 3: Implement Data Layer

```dart
// data/datasources/my_remote_data_source.dart
class MyRemoteDataSource {
  final ApiClient apiClient;

  MyRemoteDataSource(this.apiClient);

  Future<MyModel> getEntity(String id) async {
    final response = await apiClient.get('/entities/$id');
    return MyModel.fromJson(response.data);
  }
}

// data/models/my_model.dart
@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,
    required String name,
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);

  MyEntity toEntity() => MyEntity(id: id, name: name);
}

// data/repositories/my_repository_impl.dart
class MyRepositoryImpl implements MyRepository {
  final MyRemoteDataSource remoteDataSource;

  MyRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, MyEntity>> getEntity(String id) async {
    try {
      final model = await remoteDataSource.getEntity(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
```

### Step 4: Create Presentation Layer

```dart
// presentation/providers/my_provider.dart
final myProvider = StateNotifierProvider<MyNotifier, MyState>((ref) {
  return MyNotifier(ref.watch(myRepositoryProvider));
});

class MyNotifier extends StateNotifier<MyState> {
  final MyRepository repository;

  MyNotifier(this.repository) : super(MyInitial());

  Future<void> getEntity(String id) async {
    state = MyLoading();
    final result = await repository.getEntity(id);
    result.fold(
      (entity) => state = MyLoaded(entity),
      (failure) => state = MyError(failure.message),
    );
  }
}

// presentation/pages/my_page.dart
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProvider);

    return Scaffold(
      body: state.when(
        initial: () => const Center(child: Text('Initial')),
        loading: () => const LoadingWidget(),
        loaded: (entity) => Text(entity.name),
        error: (message) => ErrorWidget(message: message),
      ),
    );
  }
}
```

### Step 5: Provide Dependencies

```dart
// In your main provider file
final myRepositoryProvider = Provider<MyRepository>((ref) {
  return MyRepositoryImpl(
    ref.watch(myRemoteDataSourceProvider),
  );
});

final myRemoteDataSourceProvider = Provider<MyRemoteDataSource>((ref) {
  return MyRemoteDataSource(
    ref.watch(apiClientProvider),
  );
});

final getEntityUseCaseProvider = Provider<GetEntityUseCase>((ref) {
  return GetEntityUseCase(
    ref.watch(myRepositoryProvider),
  );
});
```

## 🧪 Testing

### Unit Tests

```dart
test('GetEntityUseCase should return entity', () async {
  final mockRepository = MockMyRepository();
  final useCase = GetEntityUseCase(mockRepository);

  when(mockRepository.getEntity('123'))
      .thenAnswer((_) async => Right(MyEntity(id: '123', name: 'Test')));

  final result = await useCase.call('123');

  expect(result.isSuccess, true);
  expect(result.data?.name, 'Test');
});
```

### Widget Tests

```dart
testWidgets('MyPage should display entity name', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        myProvider.overrideWith((ref) => MyNotifier(mockRepository)),
      ],
      child: MaterialApp(home: MyPage()),
    ),
  );

  expect(find.text('Test'), findsOneWidget);
});
```

## 📚 Additional Resources

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Architecture](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options)
- [Riverpod Documentation](https://riverpod.dev)

## 🤝 Contributing

When creating a new feature:

1. Follow the established structure
2. Implement all three layers (data, domain, presentation)
3. Write tests for each layer
4. Add comprehensive documentation
5. Update this README

## 📄 License

This module is part of the Fast Golden Taxi project.