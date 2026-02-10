// lib/features/company/company_settings/presentation/pages/company_terms_page.dart
import 'package:fast_golden_taxi/core/theme/app_colors.dart';
import 'package:fast_golden_taxi/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Company Terms of Service Page
///
/// Displays the terms of service for Fast Golden Taxi.
class CompanyTermsPage extends StatelessWidget {
  const CompanyTermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
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
            _buildSection(context, '1. Acceptance of Terms'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'By accessing and using Fast Golden Taxi services, you accept and agree to be bound by the terms and provisions of this agreement. If you do not agree to abide by these terms, please do not use our service.',
            ),
            const SizedBox(height: 16),
            _buildSection(context, '2. Company Account'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'To use our services as a company, you must create an account and provide accurate, complete, and current information. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.',
            ),
            const SizedBox(height: 16),
            _buildSection(context, '3. Service Availability'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'We strive to provide our services 24/7, but we do not guarantee uninterrupted access. We reserve the right to modify, suspend, or discontinue the service at any time without prior notice.',
            ),
            const SizedBox(height: 16),
            _buildSection(context, '4. Company Responsibilities'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'As a company partner, you agree to: maintain accurate fleet information, ensure all drivers are properly licensed and verified, provide quality service to passengers, comply with all applicable laws and regulations, and maintain appropriate insurance coverage.',
            ),
            const SizedBox(height: 16),
            _buildSection(context, '5. Payment Terms'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'Payments for completed rides will be processed according to our payment schedule. The platform commission will be deducted from each fare before payment is made to your company. You agree to provide valid payment information and keep it updated.',
            ),
            const SizedBox(height: 16),
            _buildSection(context, '6. Driver Conduct'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'All drivers in your fleet must adhere to our code of conduct, including maintaining professional behavior, keeping vehicles clean and in good condition, following navigation instructions, and respecting passenger privacy.',
            ),
            const SizedBox(height: 16),
            _buildSection(context, '7. Prohibited Activities'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'You may not use our services for any illegal purpose, attempt to gain unauthorized access to our systems, interfere with or disrupt the service, or use automated tools to access the service for any purpose without our express written permission.',
            ),
            const SizedBox(height: 16),
            _buildSection(context, '8. Intellectual Property'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'All content, features, and functionality of the Fast Golden Taxi app are owned by Fast Golden Taxi and are protected by international copyright, trademark, and other intellectual property laws.',
            ),
            const SizedBox(height: 16),
            _buildSection(context, '9. Limitation of Liability'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'To the fullest extent permitted by law, Fast Golden Taxi shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses.',
            ),
            const SizedBox(height: 16),
            _buildSection(context, '10. Termination'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'We reserve the right to terminate or suspend your account at any time, with or without cause, with or without notice. Upon termination, your right to use the service will immediately cease.',
            ),
            const SizedBox(height: 16),
            _buildSection(context, '11. Governing Law'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'These terms shall be governed by and construed in accordance with the laws of Egypt, without regard to its conflict of law provisions.',
            ),
            const SizedBox(height: 16),
            _buildSection(context, '12. Changes to Terms'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'We reserve the right to modify these terms at any time. We will notify users of any material changes by posting the new terms on this page. Your continued use of the service after such modifications constitutes your acceptance of the new terms.',
            ),
            const SizedBox(height: 16),
            _buildSection(context, '13. Contact Us'),
            const SizedBox(height: 8),
            _buildParagraph(
              context,
              'If you have any questions about these terms, please contact us at support@fasttaxi.questifysolutions.com',
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
