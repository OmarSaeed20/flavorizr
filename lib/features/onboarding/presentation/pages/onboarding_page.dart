// lib/features/onboarding/presentation/pages/onboarding_page.dart
import 'package:flavorizr/core/router/routes.dart';
import 'package:flavorizr/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:flavorizr/features/onboarding/presentation/widgets/onboarding_indicator.dart';
import 'package:flavorizr/features/onboarding/presentation/widgets/onboarding_page_view.dart';
import 'package:flavorizr/shared/presentation/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Onboarding screen displayed to first-time users.
///
/// Features:
/// - Swipeable page view with illustrations
/// - Skip option
/// - Progress indicator
/// - Navigation to login/register
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleSkip() async {
    final success = await ref
        .read(onboardingControllerProvider.notifier)
        .skipOnboarding();
    if (success && mounted) {
      context.go(Routes.login);
    }
  }

  Future<void> _handleGetStarted() async {
    final success = await ref
        .read(onboardingControllerProvider.notifier)
        .completeOnboarding();
    if (success && mounted) {
      context.go(Routes.login);
    }
  }

  void _handleNextPage() {
    final state = ref.read(onboardingControllerProvider);
    if (state.isLastPage) {
      _handleGetStarted();
    } else {
      ref.read(onboardingControllerProvider.notifier).nextPage();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handlePreviousPage() {
    ref.read(onboardingControllerProvider.notifier).previousPage();
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    ref.read(onboardingControllerProvider.notifier).goToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(onboardingControllerProvider);

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.error != null) {
      return _buildErrorScreen(theme, state.error!);
    }

    if (state.pages.isEmpty) {
      return _buildEmptyScreen(theme);
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            _buildHeader(theme, state),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: state.pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPageView(page: state.pages[index]);
                },
              ),
            ),

            // Indicator and buttons
            _buildFooter(theme, state),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, OnboardingState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button (hidden on first page)
          AnimatedOpacity(
            opacity: state.isFirstPage ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              onPressed: state.isFirstPage ? null : _handlePreviousPage,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),

          // Skip button (hidden on last page)
          AnimatedOpacity(
            opacity: state.isLastPage ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: TextButton(
              onPressed: state.isLastPage ? null : _handleSkip,
              child: Text(
                'Skip',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(ThemeData theme, OnboardingState state) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Page indicator
          OnboardingIndicator(
            count: state.pages.length,
            currentIndex: state.currentPageIndex,
          ),
          const SizedBox(height: 32),

          // Progress bar (alternative)
          // OnboardingProgressBar(progress: state.progress),
          // const SizedBox(height: 24),

          // Main button
          SizedBox(
            width: double.infinity,
            child: AppButton.primary(
              onPressed: state.isCompleting ? null : _handleNextPage,
              text: state.isLastPage ? 'Get Started' : 'Next',
              isLoading: state.isCompleting,
              size: AppButtonSize.large,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen(ThemeData theme, String error) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text('Something went wrong', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                error,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              AppButton.primary(
                onPressed: () {
                  ref.read(onboardingControllerProvider.notifier).reload();
                },
                text: 'Retry',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyScreen(ThemeData theme) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 64,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text('No onboarding content', style: theme.textTheme.titleLarge),
              const SizedBox(height: 24),
              AppButton.primary(
                onPressed: () => context.go(Routes.login),
                text: 'Continue to Login',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
