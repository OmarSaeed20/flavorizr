# Platform Module

The platform module provides platform-specific utilities and adaptive widgets for iOS, Android, Web, and Desktop platforms in the Fast Golden Taxi application.

## 📁 Directory Structure

```
lib/core/platform/
├── platform.dart            # Platform detection and utilities
├── platform_service.dart    # Platform-specific services
└── adaptive_widgets.dart    # Adaptive widgets for different platforms
```

## 🎯 Key Components

### 1. Platform (`platform.dart`)

Platform detection and utilities for different platforms.

**Features:**
- Platform detection (iOS, Android, Web, Desktop)
- Platform-specific behavior
- Platform capabilities
- Platform-specific styling

**Usage:**
```dart
// Check platform
if (Platform.isIOS) {
  // iOS-specific code
} else if (Platform.isAndroid) {
  // Android-specific code
}

// Check if mobile
if (PlatformUtils.isMobile) {
  // Mobile-specific code
}

// Check if desktop
if (PlatformUtils.isDesktop) {
  // Desktop-specific code
}
```

**PlatformUtils:**
```dart
class PlatformUtils {
  // Platform detection
  static bool get isIOS => Platform.isIOS;
  static bool get isAndroid => Platform.isAndroid;
  static bool get isWeb => kIsWeb;
  static bool get isMacOS => Platform.isMacOS;
  static bool get isWindows => Platform.isWindows;
  static bool get isLinux => Platform.isLinux;

  // Platform categories
  static bool get isMobile => isIOS || isAndroid;
  static bool get isDesktop => isMacOS || isWindows || isLinux;
  static bool get isNative => !isWeb;

  // Platform capabilities
  static bool get supportsBiometrics => isMobile;
  static bool get supportsPushNotifications => isMobile || isWeb;
  static bool get supportsDeepLinks => isMobile;
  static bool get supportsInAppPurchases => isMobile;

  // Platform-specific behavior
  static bool get useCupertino => isIOS;
  static bool get useMaterial => !isIOS || isWeb;

  // Platform info
  static String get platformName {
    if (isIOS) return 'iOS';
    if (isAndroid) return 'Android';
    if (isWeb) return 'Web';
    if (isMacOS) return 'macOS';
    if (isWindows) return 'Windows';
    if (isLinux) return 'Linux';
    return 'Unknown';
  }

  static String get version {
    if (isMobile) {
      // Get mobile version
    }
    return 'Unknown';
  }
}
```

### 2. PlatformService (`platform_service.dart`)

Platform-specific services for native functionality.

**Features:**
- Biometric authentication
- Deep linking
- Share functionality
- Platform-specific APIs

**Usage:**
```dart
// Biometric authentication
final isAuthenticated = await platformService.authenticate(
  reason: 'Authenticate to continue',
);

// Deep linking
platformService.handleDeepLink((link) {
  // Handle deep link
});

// Share content
await platformService.share(
  text: 'Check out this app!',
);
```

**PlatformService:**
```dart
class PlatformService {
  // Biometric authentication
  Future<bool> authenticate({
    required String reason,
  }) async {
    if (!PlatformUtils.supportsBiometrics) {
      return false;
    }

    try {
      final localAuth = LocalAuthentication();
      return await localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  // Check biometric availability
  Future<bool> canAuthenticate() async {
    if (!PlatformUtils.supportsBiometrics) {
      return false;
    }

    try {
      final localAuth = LocalAuthentication();
      return await localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  // Deep linking
  void handleDeepLink(Function(Uri) callback) {
    if (PlatformUtils.isMobile) {
      // Handle mobile deep links
    } else if (PlatformUtils.isWeb) {
      // Handle web deep links
    }
  }

  // Share functionality
  Future<void> share({
    String? text,
    String? subject,
    List<String>? filePaths,
  }) async {
    if (PlatformUtils.isMobile) {
      await Share.share(
        text ?? '',
        subject: subject,
      );
    } else if (PlatformUtils.isWeb) {
      // Web share
    } else {
      // Desktop share
    }
  }

  // Platform-specific APIs
  Future<T> callPlatformMethod<T>(String method, [dynamic arguments]) async {
    // Call platform-specific method
    throw UnimplementedError();
  }
}
```

### 3. AdaptiveWidgets (`adaptive_widgets.dart`)

Adaptive widgets that render differently based on platform.

**Features:**
- Adaptive navigation
- Adaptive dialogs
- Adaptive buttons
- Platform-specific styling

**Usage:**
```dart
// Adaptive navigation
AdaptiveNavigation(
  destinations: [
    AdaptiveNavigationDestination(
      icon: Icons.home,
      label: 'Home',
    ),
  ],
  selectedIndex: 0,
  onDestinationSelected: (index) {
    // Handle selection
  },
);

// Adaptive dialog
await showAdaptiveDialog(
  context: context,
  title: 'Alert',
  content: 'This is an adaptive dialog',
  actions: [
    AdaptiveDialogAction(
      child: Text('OK'),
      onPressed: () => Navigator.pop(context),
    ),
  ],
);
```

**AdaptiveNavigation:**
```dart
class AdaptiveNavigation extends StatelessWidget {
  final List<AdaptiveNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget? body;

  const AdaptiveNavigation({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isIOS) {
      return _buildCupertinoTabBar(context);
    } else {
      return _buildMaterialNavigation(context);
    }
  }

  Widget _buildCupertinoTabBar(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: destinations
            .map((dest) => BottomNavigationBarItem(
                  icon: Icon(dest.icon),
                  label: dest.label,
                ))
            .toList(),
        currentIndex: selectedIndex,
        onTap: onDestinationSelected,
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) => body ?? const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildMaterialNavigation(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        destinations: destinations
            .map((dest) => NavigationDestination(
                  icon: Icon(dest.icon),
                  label: dest.label,
                ))
            .toList(),
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
```

**AdaptiveDialog:**
```dart
Future<T?> showAdaptiveDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required List<AdaptiveDialogAction> actions,
}) {
  if (PlatformUtils.isIOS) {
    return showCupertinoDialog<T>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions
            .map((action) => CupertinoDialogAction(
                  child: action.child,
                  onPressed: () {
                    action.onPressed?.call();
                    Navigator.pop(context, action.result);
                  },
                ))
            .toList(),
      ),
    );
  } else {
    return showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions
            .map((action) => TextButton(
                  child: action.child,
                  onPressed: () {
                    action.onPressed?.call();
                    Navigator.pop(context, action.result);
                  },
                ))
            .toList(),
      ),
    );
  }
}
```

## 🏗️ Architecture

### Platform Detection Flow

```
1. App starts
2. Detect platform
3. Load platform-specific resources
4. Apply platform-specific styling
5. Use platform-specific APIs
```

### Adaptive Widget Flow

```
1. Widget rendered
2. Check platform
3. Choose appropriate implementation
4. Apply platform-specific styling
5. Render widget
```

## 📝 Best Practices

### 1. Use Platform Detection

```dart
// Good
if (PlatformUtils.isIOS) {
  // iOS-specific code
} else {
  // Other platforms
}

// Bad
// Don't check platform
```

### 2. Use Adaptive Widgets

```dart
// Good
AdaptiveNavigation(
  destinations: destinations,
  selectedIndex: selectedIndex,
  onDestinationSelected: onDestinationSelected,
);

// Bad
NavigationBar(
  destinations: destinations,
  selectedIndex: selectedIndex,
  onDestinationSelected: onDestinationSelected,
);
```

### 3. Handle Platform Capabilities

```dart
// Good
if (PlatformUtils.supportsBiometrics) {
  await authenticate();
} else {
  // Fallback to password
}

// Bad
await authenticate(); // May fail on unsupported platforms
```

### 4. Test on All Platforms

```dart
// Good
// Test on iOS, Android, Web, and Desktop

// Bad
// Only test on one platform
```

### 5. Provide Fallbacks

```dart
// Good
if (PlatformUtils.isMobile) {
  await share();
} else {
  await copyToClipboard();
}

// Bad
await share(); // May not work on all platforms
```

## 🔧 Usage Examples

### Platform-Specific UI

```dart
class PlatformSpecificUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isIOS) {
      return _buildIOSUI(context);
    } else if (PlatformUtils.isAndroid) {
      return _buildAndroidUI(context);
    } else if (PlatformUtils.isWeb) {
      return _buildWebUI(context);
    } else {
      return _buildDesktopUI(context);
    }
  }

  Widget _buildIOSUI(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('iOS UI'),
      ),
      child: Center(
        child: CupertinoButton.filled(
          child: const Text('iOS Button'),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildAndroidUI(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Android UI'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Android Button'),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildWebUI(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web UI'),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
          ),
          child: const Text('Web Button'),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildDesktopUI(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desktop UI'),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 48),
          ),
          child: const Text('Desktop Button'),
          onPressed: () {},
        ),
      ),
    );
  }
}
```

### Biometric Authentication

```dart
class BiometricAuth extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformService = ref.watch(platformServiceProvider);

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            if (!PlatformUtils.supportsBiometrics) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Biometrics not supported on this platform'),
                ),
              );
              return;
            }

            final canAuth = await platformService.canAuthenticate();
            if (!canAuth) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No biometrics enrolled'),
                ),
              );
              return;
            }

            final isAuthenticated = await platformService.authenticate(
              reason: 'Authenticate to access secure data',
            );

            if (isAuthenticated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Authentication successful'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Authentication failed'),
                ),
              );
            }
          },
          child: const Text('Authenticate'),
        ),
      ),
    );
  }
}
```

### Platform-Specific Features

```dart
class PlatformFeatures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.fingerprint),
            title: const Text('Biometrics'),
            subtitle: Text(
              PlatformUtils.supportsBiometrics ? 'Supported' : 'Not supported',
            ),
            trailing: PlatformUtils.supportsBiometrics
                ? const Icon(Icons.check, color: Colors.green)
                : const Icon(Icons.close, color: Colors.red),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Push Notifications'),
            subtitle: Text(
              PlatformUtils.supportsPushNotifications
                  ? 'Supported'
                  : 'Not supported',
            ),
            trailing: PlatformUtils.supportsPushNotifications
                ? const Icon(Icons.check, color: Colors.green)
                : const Icon(Icons.close, color: Colors.red),
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text('Deep Links'),
            subtitle: Text(
              PlatformUtils.supportsDeepLinks ? 'Supported' : 'Not supported',
            ),
            trailing: PlatformUtils.supportsDeepLinks
                ? const Icon(Icons.check, color: Colors.green)
                : const Icon(Icons.close, color: Colors.red),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('In-App Purchases'),
            subtitle: Text(
              PlatformUtils.supportsInAppPurchases
                  ? 'Supported'
                  : 'Not supported',
            ),
            trailing: PlatformUtils.supportsInAppPurchases
                ? const Icon(Icons.check, color: Colors.green)
                : const Icon(Icons.close, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
```

### Adaptive Button

```dart
class AdaptiveButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const AdaptiveButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isIOS) {
      return CupertinoButton(
        color: isPrimary
            ? CupertinoColors.activeBlue
            : CupertinoColors.systemGrey,
        child: Text(label),
        onPressed: onPressed,
      );
    } else {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
        ),
        child: Text(label),
        onPressed: onPressed,
      );
    }
  }
}
```

## 🧪 Testing

### Platform Detection Tests

```dart
test('PlatformUtils should detect iOS', () {
  // Mock platform
  expect(PlatformUtils.isIOS, true);
});

test('PlatformUtils should detect mobile', () {
  // Mock platform
  expect(PlatformUtils.isMobile, true);
});
```

### Adaptive Widget Tests

```dart
testWidgets('AdaptiveNavigation should render correctly on iOS', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: AdaptiveNavigation(
        destinations: [
          AdaptiveNavigationDestination(
            icon: Icons.home,
            label: 'Home',
          ),
        ],
        selectedIndex: 0,
        onDestinationSelected: (index) {},
      ),
    ),
  );

  expect(find.byType(CupertinoTabBar), findsOneWidget);
});
```

## 📚 Additional Resources

- [Flutter Platform Detection](https://api.flutter.dev/flutter/foundation/Platform-class.html)
- [Adaptive UI in Flutter](https://flutter.dev/docs/development/ui/adaptive-responsive)
- [Platform Channels](https://flutter.dev/docs/development/platform-integration/platform-channels)

## 🤝 Contributing

When adding platform-specific features:

1. Test on all platforms
2. Provide fallbacks
3. Use adaptive widgets
4. Update documentation
5. Add tests

## 📄 License

This module is part of the Fast Golden Taxi project.