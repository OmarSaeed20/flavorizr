import 'package:fast_golden_taxi/core/localization/locale_controller.dart';
import 'package:fast_golden_taxi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSettingsPage extends ConsumerWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.language)),
      body: ListView(
        children: [
          _buildLanguageTile(
            context,
            ref,
            title: 'English',
            locale: const Locale('en'),
            isSelected: currentLocale.languageCode == 'en',
          ),
          _buildLanguageTile(
            context,
            ref,
            title: 'العربية',
            locale: const Locale('ar'),
            isSelected: currentLocale.languageCode == 'ar',
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required Locale locale,
    required bool isSelected,
  }) {
    return ListTile(
      title: Text(title),
      trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
      onTap: () {
        ref.read(localeControllerProvider.notifier).setLocale(locale);
      },
    );
  }
}
