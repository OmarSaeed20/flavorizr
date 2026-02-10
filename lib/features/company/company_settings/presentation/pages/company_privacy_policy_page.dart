// lib/features/company/company_settings/presentation/pages/company_privacy_policy_page.dart
import 'package:fast_golden_taxi/core/theme/app_colors.dart';
import 'package:fast_golden_taxi/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Company Privacy Policy Page
///
/// Displays the privacy policy for Fast Golden Taxi.
class CompanyPrivacyPolicyPage extends StatelessWidget {
  const CompanyPrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: AppTextStyles.of(context).headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Last Updated: January 2024',
              style: AppTextStyles.of(
                context,
              ).bodySmall.copyWith(color: AppColors.of(context).textSecondary),
            ),
            const SizedBox(height: 24),
            _buildSection(context, '1. Information We Collect'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'We collect information you provide directly to us, including when you create an account, use our services, or communicate with us. This may include your name, phone number, email address, company information, and payment details.',
            ),
            const SizedBox(height: 16),
            _buildSection(context, '2. How We Use Your Information'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'We use the information we collect to provide, maintain, and improve our services, process transactions, send you technical notices and support messages, respond to your comments and questions, and provide customer service.',
            ),
            const SizedBox(height: 16),
            _buildSection(context, '3. Information Sharing'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'We do not sell your personal information. We may share your information with service providers who perform services on our behalf, with your consent, or as required by law. We may also share aggregated, anonymized data that does not identify you.',
            ),
            const SizedBox(height: 16),
            _buildSection(context, '4. Data Security'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet is 100% secure.',
            ),
            const SizedBox(height: 16),
            _buildSection(context, '5. Your Rights'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'You have the right to access, correct, or delete your personal information. You may also opt out of certain communications. To exercise these rights, please contact us through the support section of the app.',
            ),
            const SizedBox(height: 16),
            _buildSection(context, "6. Children's Privacy"),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'Our services are not intended for children under the age of 18. We do not knowingly collect personal information from children under 18. If you are a parent or guardian and believe your child has provided us with personal information, please contact us.',
            ),
            const SizedBox(height: 16),
            _buildSection(context, '7. Changes to This Policy'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'We may update this privacy policy from time to time. We will notify you of any changes by posting the new privacy policy on this page and updating the "Last Updated" date.',
            ),
            const SizedBox(height: 16),
            _buildSection(context, '8. Contact Us'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'If you have any questions about this privacy policy, please contact us at support@fasttaxi.questifysolutions.com',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title) {
    return Text(
      title,
      style: AppTextStyles.of(context).titleLarge.copyWith(
        color: AppColors.of(context).primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildParagraph(BuildContext context, String text) {
    return Text(text, style: AppTextStyles.of(context).bodyMedium);
  }
}
