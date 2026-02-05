// lib/features/splash/presentation/pages/splash_page.dart
import 'package:flavorizr/config/flavors.dart';
import 'package:flavorizr/core/router/routes.dart';
import 'package:flavorizr/features/splash/domain/usecases/check_app_initialization_usecase.dart';
import 'package:flavorizr/features/splash/presentation/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Splash screen displayed during app initialization.
///
/// Shows app branding and loading indicator while:
/// - Checking authentication status
/// - Checking onboarding completion
/// - Initializing app services
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    // Give the widget tree time to build
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      await ref.read(splashControllerProvider.notifier).initialize();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToDestination(InitializationResult result) {
    if (!mounted) return;

    final destination = switch (result) {
      InitializationResult.onboarding => Routes.onboarding,
      InitializationResult.login => Routes.login,
      InitializationResult.home => Routes.home,
    };

    context.go(destination);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(splashControllerProvider);

    // Navigate when initialization is complete
    ref.listen<SplashState>(splashControllerProvider, (previous, next) {
      if (!next.isLoading && next.result != null) {
        _navigateToDestination(next.result!);
      }
    });

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primaryContainer,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(scale: _scaleAnimation, child: child),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo/Icon
                  _buildLogo(theme),
                  const SizedBox(height: 24),

                  // App Name
                  _buildAppName(theme),
                  const SizedBox(height: 8),

                  // Tagline
                  _buildTagline(theme),
                  const SizedBox(height: 48),

                  // Loading indicator or error
                  if (state.error != null)
                    _buildError(theme, state.error!)
                  else
                    _buildLoadingIndicator(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(ThemeData theme) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(
        Icons.flash_on_rounded,
        size: 64,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildAppName(ThemeData theme) {
    return Text(
      F.title,
      style: theme.textTheme.headlineLarge?.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildTagline(ThemeData theme) {
    return Text(
      'Your amazing app tagline',
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Column(
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.onPrimary.withValues(alpha: 0.8),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Loading...',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildError(ThemeData theme, String error) {
    return Column(
      children: [
        Icon(
          Icons.error_outline_rounded,
          size: 48,
          color: theme.colorScheme.error,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            error,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            ref.read(splashControllerProvider.notifier).initialize();
          },
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Retry'),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.surface,
            foregroundColor: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
