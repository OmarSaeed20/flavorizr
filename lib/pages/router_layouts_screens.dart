/* // lib/shared/presentation/layouts/main_layout.dart
// import '../../core/router/app_router.dart';
// import '../../core/navigation/navigation_service.dart';

import 'package:fast_golden_taxi/core/router/app_router.dart';
import 'package:fast_golden_taxi/core/router/navigation_state.dart';
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/pages/router_supporting_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainLayout extends ConsumerStatefulWidget {
  final Widget child;
  final String currentRoute;

  const MainLayout({super.key, required this.child, required this.currentRoute});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  int _selectedIndex = 0;

  final List<NavigationDestination> _destinations = [
    const NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    const NavigationDestination(
      icon: Icon(Icons.store_outlined),
      selectedIcon: Icon(Icons.store),
      label: 'Shop',
    ),
    const NavigationDestination(
      icon: Icon(Icons.shopping_cart_outlined),
      selectedIcon: Icon(Icons.shopping_cart),
      label: 'Cart',
    ),
    const NavigationDestination(
      icon: Icon(Icons.receipt_long_outlined),
      selectedIcon: Icon(Icons.receipt_long),
      label: 'Orders',
    ),
    const NavigationDestination(
      icon: Icon(Icons.person_outlined),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  final List<String> _routes = [
    Routes.home,
    Routes.shop,
    Routes.cart,
    Routes.orders,
    Routes.profile,
  ];

  @override
  void initState() {
    super.initState();
    _updateSelectedIndex();
  }

  @override
  void didUpdateWidget(MainLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentRoute != widget.currentRoute) {
      _updateSelectedIndex();
    }
  }

  void _updateSelectedIndex() {
    final currentRoute = widget.currentRoute;
    for (var i = 0; i < _routes.length; i++) {
      if (currentRoute.startsWith(_routes[i])) {
        if (mounted) {
          setState(() => _selectedIndex = i);
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final navigationState = ref.watch(
    //   NavigationService.instance.navigationState,
    // );
    // Define a StreamProvider for the navigation state
    final navigationStateProvider = StreamProvider<NavigationState>((ref) {
      return NavigationService.instance.navigationState;
    });

    // In your widget or consumer, watch the provider
    final navigationState = ref.watch(navigationStateProvider);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          widget.child,
          if (navigationState.value?.isLoading ?? false)
            ColoredBox(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
      drawer: _buildDrawer(context),
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    final currentRoute = widget.currentRoute;

    if (_shouldHideAppBar(currentRoute)) {
      return null;
    }

    return AppBar(
      title: Text(_getAppBarTitle(currentRoute)),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(icon: const Icon(Icons.search), onPressed: () => _showSearchDialog(context)),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => context.push('/notifications'),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: _handleMenuSelection,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'help',
              child: ListTile(
                leading: Icon(Icons.help),
                title: Text('Help & Support'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Logout', style: TextStyle(color: Colors.red)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool _shouldHideAppBar(String route) {
    return route.startsWith('/auth') || route == Routes.splash;
  }

  String _getAppBarTitle(String route) {
    if (route.startsWith(Routes.home)) return 'Home';
    if (route.startsWith(Routes.shop)) return 'Shop';
    if (route.startsWith(Routes.cart)) return 'Cart';
    if (route.startsWith(Routes.orders)) return 'Orders';
    if (route.startsWith(Routes.profile)) return 'Profile';
    if (route.startsWith(Routes.settings)) return 'Settings';
    return 'App';
  }

  Widget _buildBottomNavigation(BuildContext context) {
    if (_shouldHideBottomNavigation(widget.currentRoute)) {
      return const SizedBox.shrink();
    }

    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onDestinationSelected,
      destinations: _destinations,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).primaryColor,
      indicatorColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
    );
  }

  bool _shouldHideBottomNavigation(String route) {
    return route.startsWith('/auth') ||
        route == Routes.splash ||
        route.startsWith('/checkout') ||
        route.startsWith('/admin');
  }

  void _onDestinationSelected(int index) {
    if (index == _selectedIndex) return;

    final route = _routes[index];
    context.go(route);
  }

  Widget _buildDrawer(BuildContext context) {
    if (_shouldHideDrawer(widget.currentRoute)) {
      return const SizedBox.shrink();
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue, Colors.blueAccent]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                ),
                SizedBox(height: 12),
                Text(
                  'John Doe',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('john.doe@example.com', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.home,
            title: 'Home',
            route: Routes.home,
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.store,
            title: 'Shop',
            route: Routes.shop,
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.favorite,
            title: 'Wishlist',
            route: '/wishlist',
            context: context,
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            route: Routes.settings,
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.help,
            title: 'Help & Support',
            route: '/help',
            context: context,
          ),
          _buildDrawerItem(icon: Icons.info, title: 'About', route: '/about', context: context),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => _handleLogout(context),
          ),
        ],
      ),
    );
  }

  bool _shouldHideDrawer(String route) {
    return route.startsWith('/auth') || route == Routes.splash;
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required String route,
    required BuildContext context,
  }) {
    final isSelected = widget.currentRoute.startsWith(route);

    return ListTile(
      leading: Icon(icon, color: isSelected ? Theme.of(context).primaryColor : null),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).primaryColor : null,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.of(context).pop();
        context.go(route);
      },
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'settings':
        context.go(Routes.settings);
        break;
      case 'help':
        context.push('/help');
        break;
      case 'logout':
        _handleLogout(context);
        break;
    }
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              AppRouter.instance.logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Search products, users, etc.',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Handle search
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}

// lib/shared/presentation/layouts/auth_layout.dart
class AuthLayout extends StatelessWidget {
  final Widget child;

  const AuthLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Icon(Icons.store, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 32),

                // App Name
                Text(
                  'Shopping App',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'Your one-stop shopping destination',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 48),

                // Auth Content
                Container(constraints: const BoxConstraints(maxWidth: 400), child: child),

                const SizedBox(height: 24),

                // Footer
                Text(
                  '© 2024 Shopping App. All rights reserved.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// lib/shared/presentation/screens/splash_screen.dart
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(duration: const Duration(seconds: 2), vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await _animationController.forward();

    // Navigate based on auth state
    if (mounted) {
      final authService = AuthService.instance;
      final isAuthenticated = await authService.isAuthenticated();

      if (mounted) {
        if (isAuthenticated) {
          context.go(Routes.home);
        } else {
          context.go(Routes.login);
        }
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Icon(Icons.store, size: 80, color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Shopping App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// lib/shared/presentation/screens/error_screen.dart
class ErrorScreen extends StatelessWidget {
  final String? error;
  final VoidCallback? onRetry;

  const ErrorScreen({super.key, this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 120, color: Colors.red[300]),
              const SizedBox(height: 32),

              Text(
                'Oops! Something went wrong',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              if (error != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    border: Border.all(color: Colors.red[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    error!,
                    style: TextStyle(color: Colors.red[700], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],

              Text(
                'We apologize for the inconvenience. Please try again or go back to the home screen.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (onRetry != null) ...[
                    ElevatedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],

                  OutlinedButton.icon(
                    onPressed: () => context.go(Routes.home),
                    icon: const Icon(Icons.home),
                    label: const Text('Go Home'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/shared/presentation/screens/not_found_screen.dart
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '404',
                style: TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Page Not Found',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),

              Text(
                "The page you are looking for doesn't exist or has been moved.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              ElevatedButton.icon(
                onPressed: () => context.go(Routes.home),
                icon: const Icon(Icons.home),
                label: const Text('Go Home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/features/auth/presentation/screens/login_screen.dart
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = AuthService.instance;
      final success = await authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        await AppRouter.instance.navigateAfterLogin();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome Back',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  // if (value?.isEmpty ?? true) return 'Please enter your email';
                  // if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}) return 'Please enter your email';
                  // if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                  //   return 'Please enter a valid email';
                  // }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your password';
                  }
                  if (value!.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push('/auth/forgot-password'),
                  child: const Text('Forgot Password?'),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Login'),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                    onPressed: () => context.go(Routes.register),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/features/auth/presentation/screens/register_screen.dart
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate() || !_acceptTerms) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please accept the terms and conditions'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = AuthService.instance;
      final success = await authService.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!'), backgroundColor: Colors.green),
        );
        context.go(Routes.home);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create Account',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter your name';
                  if (value!.length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  // if (value?.isEmpty ?? true).hasMatch(value!)) {
                  //   return 'Please enter a valid email';
                  // }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your password';
                  }
                  if (value!.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (value) => setState(() => _acceptTerms = value ?? false),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(color: Colors.black87),
                          children: [
                            TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Create Account'),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? '),
                  TextButton(
                    onPressed: () => context.go(Routes.login),
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/features/auth/presentation/screens/forgot_password_screen.dart
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() => _emailSent = true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: _emailSent ? _buildSuccessContent() : _buildFormContent(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.lock_reset, size: 80, color: Colors.blue),
          const SizedBox(height: 24),

          Text(
            'Reset Password',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          Text(
            "Enter your email address and we'll send you a link to reset your password.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email Address',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please enter your email';
              // if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}) return 'Please enter your email';
              //     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
              //       return 'Please enter a valid email';
              //     }
              return null;
            },
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _isLoading ? null : _handleResetPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Send Reset Link'),
          ),
          const SizedBox(height: 16),

          TextButton(
            onPressed: () => context.go(Routes.login),
            child: const Text('Back to Login'),
          ),
          /*           
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please enter your password';
              if (value!.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.push('/auth/forgot-password'),
              child: const Text('Forgot Password?'),
            ),
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Login'),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Don\'t have an account? '),
              TextButton(
                onPressed: () => context.go(Routes.register),
                child: const Text('Sign Up'),
              ),
            ],
          ),
 */
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle, size: 80, color: Colors.green),
        const SizedBox(height: 24),

        Text(
          'Email Sent!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        Text(
          "We've sent a password reset link to ${_emailController.text}. Please check your email and follow the instructions.",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        ElevatedButton(
          onPressed: () => context.go(Routes.login),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
          child: const Text('Back to Login'),
        ),
        const SizedBox(height: 16),

        TextButton(
          onPressed: () => setState(() => _emailSent = false),
          child: const Text('Send Another Email'),
        ),
      ],
    );
  }
}

// lib/features/auth/presentation/screens/register_screen.dart
/* class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate() || !_acceptTerms) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please accept the terms and conditions'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = AuthService.instance;
      final success = await authService.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go(Routes.home);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create Account',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter your name';
                  if (value!.length < 2) return 'Name must be at least 2 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true).hasMatch(value!)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          
          ElevatedButton(
            onPressed: _isLoading ? null : _handleResetPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Send Reset Link'),
          ),
          const SizedBox(height: 16),
          
          TextButton(
            onPressed: () => context.go(Routes.login),
            child: const Text('Back to Login'),
          ),
        ],
      ),
    )));
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check_circle,
          size: 80,
          color: Colors.green,
        ),
        const SizedBox(height: 24),
        
        Text(
          'Email Sent!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        
        Text(
          'We\'ve sent a password reset link to ${_emailController.text}. Please check your email and follow the instructions.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        
        ElevatedButton(
          onPressed: () => context.go(Routes.login),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
          child: const Text('Back to Login'),
        ),
        const SizedBox(height: 16),
        
        TextButton(
          onPressed: () => setState(() => _emailSent = false),
          child: const Text('Send Another Email'),
        ),
      ],
    );
  }
}
 */
// lib/features/auth/presentation/screens/reset_password_screen.dart
class ResetPasswordScreen extends StatefulWidget {
  final String? token;

  const ResetPasswordScreen({super.key, this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _passwordReset = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() => _passwordReset = true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.token == null) {
      return const ErrorScreen(
        error: 'Invalid reset token. Please request a new password reset link.',
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: _passwordReset ? _buildSuccessContent() : _buildFormContent(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.lock_open, size: 80, color: Colors.blue),
          const SizedBox(height: 24),

          Text(
            'Create New Password',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          Text(
            'Please create a new password for your account.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'New Password',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your new password';
              }
              if (value!.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Confirm New Password',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please confirm your password';
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _isLoading ? null : _handleResetPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Reset Password'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle, size: 80, color: Colors.green),
        const SizedBox(height: 24),

        Text(
          'Password Reset!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        Text(
          'Your password has been successfully reset. You can now login with your new password.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        ElevatedButton(
          onPressed: () => context.go(Routes.login),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
          child: const Text('Go to Login'),
        ),
      ],
    );
  }
}

// Placeholder screens for missing implementations
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 100, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text('Home Screen', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 100, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text(
              userId != null ? 'User Profile: $userId' : 'My Profile',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 100, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text('Settings Screen', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}

class ShopScreen extends StatelessWidget {
  final String? categoryId;
  final String? category;
  final String? searchQuery;

  const ShopScreen({super.key, this.categoryId, this.category, this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store, size: 100, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text('Shop Screen', style: Theme.of(context).textTheme.headlineMedium),
            if (categoryId != null) Text('Category: $categoryId'),
            if (category != null) Text('Filter: $category'),
            if (searchQuery != null) Text('Search: $searchQuery'),
          ],
        ),
      ),
    );
  }
}

class ProductDetailsScreen extends StatelessWidget {
  final String productId;
  final String? variant;

  const ProductDetailsScreen({super.key, required this.productId, this.variant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory, size: 100, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text('Product Details', style: Theme.of(context).textTheme.headlineMedium),
            Text('Product ID: $productId'),
            if (variant != null) Text('Variant: $variant'),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart, size: 100, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text('Cart Screen', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment, size: 100, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text('Checkout Screen', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}

class CheckoutPaymentScreen extends StatelessWidget {
  final String? orderId;

  const CheckoutPaymentScreen({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.credit_card, size: 100, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text('Payment Screen', style: Theme.of(context).textTheme.headlineMedium),
            if (orderId != null) Text('Order ID: $orderId'),
          ],
        ),
      ),
    );
  }
}

class CheckoutConfirmScreen extends StatelessWidget {
  final String orderId;

  const CheckoutConfirmScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 100, color: Colors.green),
            const SizedBox(height: 16),
            Text('Order Confirmed', style: Theme.of(context).textTheme.headlineMedium),
            Text('Order ID: $orderId'),
          ],
        ),
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 100, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text('Orders Screen', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt, size: 100, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text('Order Details', style: Theme.of(context).textTheme.headlineMedium),
            Text('Order ID: $orderId'),
          ],
        ),
      ),
    );
  }
}

// Additional placeholder screens
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Edit Profile Screen', style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Notification Settings', style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Privacy Settings', style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Security Settings', style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}

class ProductReviewsScreen extends StatelessWidget {
  final String productId;

  const ProductReviewsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, size: 100, color: Colors.amber),
            const SizedBox(height: 16),
            Text('Product Reviews', style: Theme.of(context).textTheme.headlineMedium),
            Text('Product ID: $productId'),
          ],
        ),
      ),
    );
  }
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.admin_panel_settings, size: 100, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text('Admin Dashboard', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Admin Users Management', style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}

class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Admin Products Management', style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Admin Orders Management', style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
 */
