# Pages Module

The pages module contains router layouts, screens, and supporting services for the Fast Golden Taxi application's navigation system.

## 📁 Directory Structure

```
lib/pages/
├── router_layouts_screens.dart      # Router layouts and screens configuration
└── router_supporting_services.dart  # Supporting services for router
```

## 🎯 Key Components

### 1. RouterLayoutsScreens (`router_layouts_screens.dart`)

Defines the layouts and screens used by the application router.

**Features:**
- Screen definitions
- Layout configurations
- Route mappings
- Screen builders

**Usage:**
```dart
// Define a screen
final homeScreen = GoRoute(
  path: '/home',
  builder: (context, state) => const HomeScreen(),
);

// Define a layout
final mainLayout = ShellRoute(
  builder: (context, state, child) => MainLayout(child: child),
  routes: [
    homeScreen,
  ],
);
```

### 2. RouterSupportingServices (`router_supporting_services.dart`)

Supporting services for the router including guards, redirects, and middleware.

**Features:**
- Route guards
- Auth guards
- Role guards
- Redirects
- Middleware

**Usage:**
```dart
// Auth guard
final authGuard = GoRouterRedirect(
  (context, state) {
    final isAuthenticated = ref.watch(authStateProvider).isAuthenticated;
    final isAuthRoute = state.matchedLocation.startsWith('/auth');

    if (!isAuthenticated && !isAuthRoute) {
      return '/auth/login';
    }

    if (isAuthenticated && isAuthRoute) {
      return '/home';
    }

    return null;
  },
);
```

## 🏗️ Architecture

### Router Flow

```
1. User navigates
2. Router checks guards
3. Router checks redirects
4. Router matches route
5. Router builds screen
6. Screen displayed
```

### Guard Flow

```
1. Route accessed
2. Guard checks conditions
3. Guard allows or denies
4. If denied, redirect
5. If allowed, continue
```

## 📝 Best Practices

### 1. Use Named Routes

```dart
// Good
GoRoute(
  name: 'home',
  path: '/home',
  builder: (context, state) => const HomeScreen(),
);

// Bad
GoRoute(
  path: '/home',
  builder: (context, state) => const HomeScreen(),
);
```

### 2. Use Guards for Protected Routes

```dart
// Good
GoRoute(
  path: '/profile',
  redirect: authGuard,
  builder: (context, state) => const ProfileScreen(),
);

// Bad
GoRoute(
  path: '/profile',
  builder: (context, state) => const ProfileScreen(),
);
```

### 3. Use Shell Routes for Layouts

```dart
// Good
ShellRoute(
  builder: (context, state, child) => MainLayout(child: child),
  routes: [
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
  ],
);

// Bad
GoRoute(
  path: '/home',
  builder: (context, state) => MainLayout(child: const HomeScreen()),
);
```

### 4. Pass Parameters Correctly

```dart
// Good
GoRoute(
  path: '/user/:userId',
  builder: (context, state) {
    final userId = state.pathParameters['userId']!;
    return UserScreen(userId: userId);
  },
);

// Bad
GoRoute(
  path: '/user/:userId',
  builder: (context, state) => const UserScreen(),
);
```

### 5. Handle Errors Gracefully

```dart
// Good
GoRoute(
  path: '/:path(.*)',
  builder: (context, state) => const NotFoundScreen(),
);

// Bad
// Don't handle 404
```

## 🔧 Usage Examples

### Defining Routes

```dart
final appRoutes = [
  // Auth routes
  GoRoute(
    path: '/auth/login',
    name: 'login',
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/auth/register',
    name: 'register',
    builder: (context, state) => const RegisterScreen(),
  ),

  // Main routes
  ShellRoute(
    builder: (context, state, child) => MainLayout(child: child),
    routes: [
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        redirect: authGuard,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  ),

  // 404 route
  GoRoute(
    path: '/:path(.*)',
    builder: (context, state) => const NotFoundScreen(),
  ),
];
```

### Route Guards

```dart
// Auth guard
final authGuard = GoRouterRedirect((context, state) {
  final isAuthenticated = ref.watch(authStateProvider).isAuthenticated;
  final isAuthRoute = state.matchedLocation.startsWith('/auth');

  if (!isAuthenticated && !isAuthRoute) {
    return '/auth/login';
  }

  if (isAuthenticated && isAuthRoute) {
    return '/home';
  }

  return null;
});

// Role guard
final roleGuard = GoRouterRedirect((context, state) {
  final userRole = ref.watch(userRoleProvider);
  final requiredRole = state.uri.queryParameters['role'];

  if (requiredRole != null && userRole != requiredRole) {
    return '/access-denied';
  }

  return null;
});
```

### Navigation

```dart
// Navigate to route
context.go('/home');

// Navigate with name
context.goNamed('home');

// Navigate with parameters
context.go('/user/123');

// Navigate with query parameters
context.go('/search?q=flutter');

// Navigate and replace
context.go('/home');

// Navigate back
context.pop();
```

### Shell Routes

```dart
class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          NavigationRail(
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Profile'),
              ),
            ],
            selectedIndex: _getSelectedIndex(context),
            onDestinationSelected: (index) {
              _navigateTo(context, index);
            },
          ),
          // Content
          Expanded(child: child),
        ],
      ),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/profile')) return 1;
    return 0;
  }

  void _navigateTo(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/profile');
        break;
    }
  }
}
```

### Route Parameters

```dart
// Define route with parameters
GoRoute(
  path: '/user/:userId',
  builder: (context, state) {
    final userId = state.pathParameters['userId']!;
    return UserScreen(userId: userId);
  },
);

// Navigate with parameters
context.go('/user/123');

// Access parameters in screen
class UserScreen extends StatelessWidget {
  final String userId;

  const UserScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('User ID: $userId'),
      ),
    );
  }
}
```

### Query Parameters

```dart
// Define route with query parameters
GoRoute(
  path: '/search',
  builder: (context, state) {
    final query = state.uri.queryParameters['q'] ?? '';
    final page = int.tryParse(state.uri.queryParameters['page'] ?? '1') ?? 1;
    return SearchScreen(query: query, page: page);
  },
);

// Navigate with query parameters
context.go('/search?q=flutter&page=1');

// Access query parameters in screen
class SearchScreen extends StatelessWidget {
  final String query;
  final int page;

  const SearchScreen({
    super.key,
    required this.query,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Query: $query, Page: $page'),
      ),
    );
  }
}
```

### Error Handling

```dart
// 404 screen
class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

// Access denied screen
class AccessDeniedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Access denied',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🧪 Testing

### Route Tests

```dart
testWidgets('Should navigate to home screen', (tester) async {
  await tester.pumpWidget(
    MaterialApp.router(
      routerConfig: router,
    ),
  );

  expect(find.text('Home'), findsOneWidget);
});

testWidgets('Should redirect to login when not authenticated', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authStateProvider.overrideWithValue(AuthState.unauthenticated()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    ),
  );

  expect(find.text('Login'), findsOneWidget);
});
```

## 📚 Additional Resources

- [GoRouter Documentation](https://pub.dev/documentation/go_router/latest/)
- [Flutter Navigation](https://flutter.dev/docs/development/ui/navigation)
- [Deep Linking](https://flutter.dev/docs/development/ui/navigation/deep-linking)

## 🤝 Contributing

When adding routes:

1. Use descriptive route names
2. Add guards for protected routes
3. Handle errors gracefully
4. Update documentation
5. Add tests

## 📄 License

This module is part of the Fast Golden Taxi project.