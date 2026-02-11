// lib/features/onboarding/presentation/pages/onboarding_page.dart
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:fast_golden_taxi/features/onboarding/presentation/widgets/onboarding_indicator.dart';
import 'package:fast_golden_taxi/features/onboarding/presentation/widgets/onboarding_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Onboarding screen displayed to first-time users.
///
/// Matches the Figma design with:
/// - #F2F2F2 background
/// - White top header bar with back arrow & Skip
/// - Image area in the center
/// - White bottom card with rounded top corners, title, description,
///   dot indicators, and a golden Next button
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
    final success = await ref.read(onboardingControllerProvider.notifier).skipOnboarding();
    if (success && mounted) {
      context.go(Routes.roleSelection);
    }
  }

  Future<void> _handleGetStarted() async {
    final success = await ref.read(onboardingControllerProvider.notifier).completeOnboarding();
    if (success && mounted) {
      context.go(Routes.roleSelection);
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
    final state = ref.watch(onboardingControllerProvider);

    if (state.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF2F2F2),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null) {
      return _buildErrorScreen(state.error!);
    }

    if (state.pages.isEmpty) {
      return _buildEmptyScreen();
    }

    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Stack(
        children: [
          // ── Image page view (occupies the area between header and bottom card) ──
          Positioned.fill(
            top: topPadding + 55,
            bottom: 302,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: state.pages.length,
              itemBuilder: (context, index) {
                return OnboardingPageView(page: state.pages[index]);
              },
            ),
          ),

          // ── White header bar ──
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              height: topPadding + 55,
              decoration: const BoxDecoration(color: Colors.white),
              padding: EdgeInsets.only(top: topPadding, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back arrow (hidden on first page)
                  AnimatedOpacity(
                    opacity: state.isFirstPage ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      onTap: state.isFirstPage ? null : _handlePreviousPage,
                      child: const SizedBox(
                        width: 24,
                        height: 24,
                        child: Icon(Icons.arrow_back, size: 24, color: Color(0xFF131313)),
                      ),
                    ),
                  ),
                  // Skip button (hidden on last page)
                  AnimatedOpacity(
                    opacity: state.isLastPage ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      onTap: state.isLastPage ? null : _handleSkip,
                      child: const Text(
                        'Skip',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFFBF00),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 1.75,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom white card ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 32),
              clipBehavior: Clip.antiAlias,
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                shadows: [
                  BoxShadow(color: Color(0x3F000000), blurRadius: 14, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title & Description
                  _buildTitleDescription(state),
                  const SizedBox(height: 20),
                  // Indicators
                  OnboardingIndicator(
                    count: state.pages.length,
                    currentIndex: state.currentPageIndex,
                  ),
                  const SizedBox(height: 20),
                  // Next button
                  _buildNextButton(state),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleDescription(OnboardingState state) {
    final page = state.currentPage;
    if (page == null) return const SizedBox.shrink();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Column(
        key: ValueKey(page.id),
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          SizedBox(
            width: double.infinity,
            child: Text(
              page.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF131313),
                fontSize: 24,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Description
          SizedBox(
            width: double.infinity,
            child: Text(
              page.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF686868),
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(OnboardingState state) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: MaterialButton(
        onPressed: state.isCompleting ? null : _handleNextPage,
        color: const Color(0xFFFFBF00),
        disabledColor: const Color(0xFFFFBF00).withValues(alpha: 0.5),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: state.isCompleting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
              )
            : const Text(
                'Next',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildErrorScreen(String error) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 64, color: Color(0xFFFFBF00)),
              const SizedBox(height: 16),
              const Text(
                'Something went wrong',
                style: TextStyle(
                  color: Color(0xFF131313),
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: const TextStyle(
                  color: Color(0xFF686868),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: MaterialButton(
                  onPressed: () {
                    ref.read(onboardingControllerProvider.notifier).reload();
                  },
                  color: const Color(0xFFFFBF00),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: const Text(
                    'Retry',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline_rounded, size: 64, color: Color(0xFFFFBF00)),
              const SizedBox(height: 16),
              const Text(
                'No onboarding content',
                style: TextStyle(
                  color: Color(0xFF131313),
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: MaterialButton(
                  onPressed: () => context.go(Routes.roleSelection),
                  color: const Color(0xFFFFBF00),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
