// lib/features/splash/presentation/pages/splash_page.dart
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/splash/domain/usecases/check_app_initialization_usecase.dart';
import 'package:fast_golden_taxi/features/splash/presentation/controllers/splash_controller.dart';
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

class _SplashPageState extends ConsumerState<SplashPage> with SingleTickerProviderStateMixin {
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
      InitializationResult.languageSelection => Routes.languageSelection,
      InitializationResult.onboarding => Routes.onboarding,
      InitializationResult.login => Routes.roleSelection,
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
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.60)),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo
                    _buildLogo(),
                    const SizedBox(height: 22),

                    // App Name and Tagline
                    _buildAppInfo(),

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
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 68,
      height: 70,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/icons/app_logo.png'),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      // Fallback icon if image is not available
      child: const Icon(Icons.local_taxi_rounded, size: 48, color: Colors.white),
    );
  }

  Widget _buildAppInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // App Name
        const SizedBox(
          width: 296,
          child: Text(
            'Fast Taxi',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Tagline
        SizedBox(
          width: 296,
          child: Text(
            "Reliable rides, anytime, anywhere. Let's get you moving.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFFFAFAFA).withValues(alpha: 0.9),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Loading...',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildError(ThemeData theme, String error) {
    return Column(
      children: [
        const Icon(Icons.error_outline_rounded, size: 48, color: Colors.white),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            error,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Poppins'),
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
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }
}
