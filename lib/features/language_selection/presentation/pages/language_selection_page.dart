// lib/features/language_selection/presentation/pages/language_selection_page.dart
import 'package:fast_golden_taxi/core/localization/locale_controller.dart';
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/language_selection/presentation/controllers/language_selection_controller.dart';
import 'package:fast_golden_taxi/features/language_selection/presentation/providers/language_selection_providers.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Language selection screen (Figma screen A.2).
///
/// Layout:
/// - Background: #F2F2F2
/// - Logo card centered above bottom sheet
/// - Bottom sheet with language option cards + confirm button
class LanguageSelectionPage extends ConsumerWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(languageSelectionControllerProvider);

    // Navigate on confirmation
    ref.listen<LanguageSelectionState>(languageSelectionControllerProvider, (previous, next) {
      if (next.isConfirmed && !(previous?.isConfirmed ?? false)) {
        // Update app locale
        final lang = next.selectedLanguage;
        if (lang != null) {
          ref.read(localeControllerProvider.notifier).setLocale(lang.locale);
        }
        context.go(Routes.onboarding);
      }
    });

    return Scaffold(
      backgroundColor: AuthDesignConstants.background,
      body: Column(
        children: [
          // ── Top area with logo card ──
          const Expanded(
            child: Center(
              child: Padding(padding: EdgeInsets.only(top: 60), child: AuthLogoCard()),
            ),
          ),

          // ── Bottom sheet ──
          AuthBottomSheet(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            spacing: 16,
            children: [
              // Title
              const SizedBox(
                width: double.infinity,
                child: Text(
                  'Select Language',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: AuthDesignConstants.fontBody,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Language options
              ...AppLanguage.values.map((lang) {
                final isSelected = state.selectedLanguage == lang;
                return _LanguageOptionCard(
                  language: lang,
                  isSelected: isSelected,
                  onTap: () =>
                      ref.read(languageSelectionControllerProvider.notifier).selectLanguage(lang),
                );
              }),

              // Confirm button
              const SizedBox(height: 4),
              AuthPrimaryButton(
                text: 'Confirm',
                isLoading: state.isLoading,
                isEnabled: state.canConfirm,
                onPressed: () => ref.read(languageSelectionControllerProvider.notifier).confirm(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A single language option card matching Figma design.
class _LanguageOptionCard extends StatelessWidget {
  const _LanguageOptionCard({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  final AppLanguage language;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: isSelected
                  ? AuthDesignConstants.primaryVariant
                  : AuthDesignConstants.inactiveBorder,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [AuthDesignConstants.languageCardShadow],
        ),
        child: Row(
          children: [
            // Radio indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AuthDesignConstants.primaryVariant
                      : AuthDesignConstants.inactiveBorder,
                  width: isSelected ? 6 : 2,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Language name
            Expanded(
              child: Text(
                language.nameEn,
                style: AuthDesignConstants.languageOption.copyWith(
                  color: isSelected ? Colors.black : Colors.black87,
                ),
              ),
            ),
            // Native name (right aligned for RTL languages)
            if (language.nameNative != language.nameEn)
              Text(
                language.nameNative,
                style: AuthDesignConstants.languageOption.copyWith(
                  color: AuthDesignConstants.textTertiary,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
