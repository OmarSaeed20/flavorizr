// lib/features/company/company_settings/presentation/pages/company_about_page.dart
import 'package:flutter/material.dart';
import 'package:fast_golden_taxi/core/theme/app_colors.dart';
import 'package:fast_golden_taxi/core/theme/app_text_styles.dart';

/// Company About Us Page
///
/// Displays information about Fast Golden Taxi.
class CompanyAboutPage extends StatelessWidget {
  const CompanyAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.of(context).primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.local_taxi, size: 80, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            // App Name
            Center(child: Text('Fast Golden Taxi', style: AppTextStyles.of(context).headlineLarge)),
            const SizedBox(height: 8),
            // Version
            Center(
              child: Text(
                'Version 1.0.0',
                style: AppTextStyles.of(
                  context,
                ).bodyMedium.copyWith(color: AppColors.of(context).textSecondary),
              ),
            ),
            const SizedBox(height: 32),
            // About Content
            _buildSection(context, 'Our Mission'),
            const SizedBox(height: 8),
            Text(
              'Fast Golden Taxi is dedicated to providing safe, reliable, and efficient transportation services for both passengers and fleet operators. We leverage cutting-edge technology to connect riders with drivers seamlessly.',
              style: AppTextStyles.of(context).bodyMedium,
            ),
            const SizedBox(height: 24),
            _buildSection(context, 'Our Vision'),
            const SizedBox(height: 8),
            Text(
              'To become the leading ride-hailing platform in Egypt, known for our commitment to safety, customer satisfaction, and innovation in the transportation industry.',
              style: AppTextStyles.of(context).bodyMedium,
            ),
            const SizedBox(height: 24),
            _buildSection(context, 'What We Offer'),
            const SizedBox(height: 8),
            _buildFeatureItem(
              context,
              icon: Icons.security,
              title: 'Safe Rides',
              description: 'All drivers are verified and vehicles are regularly inspected.',
            ),
            _buildFeatureItem(
              context,
              icon: Icons.speed,
              title: 'Fast Service',
              description: 'Quick pickup times and efficient route optimization.',
            ),
            _buildFeatureItem(
              context,
              icon: Icons.attach_money,
              title: 'Competitive Pricing',
              description: 'Fair and transparent pricing with no hidden fees.',
            ),
            _buildFeatureItem(
              context,
              icon: Icons.support_agent,
              title: '24/7 Support',
              description: 'Round-the-clock customer support for all your needs.',
            ),
            const SizedBox(height: 24),
            _buildSection(context, 'Contact Us'),
            const SizedBox(height: 8),
            _buildContactItem(
              context,
              icon: Icons.email,
              label: 'Email',
              value: 'support@fasttaxi.questifysolutions.com',
            ),
            _buildContactItem(
              context,
              icon: Icons.phone,
              label: 'Phone',
              value: '+20 123 456 7890',
            ),
            _buildContactItem(
              context,
              icon: Icons.location_on,
              label: 'Address',
              value: 'Cairo, Egypt',
            ),
            const SizedBox(height: 24),
            _buildSection(context, 'Follow Us'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialButton(context, Icons.facebook),
                const SizedBox(width: 16),
                _buildSocialButton(context, Icons.camera_alt),
                const SizedBox(width: 16),
                _buildSocialButton(context, Icons.link),
                const SizedBox(width: 16),
                _buildSocialButton(context, Icons.play_circle),
              ],
            ),
            const SizedBox(height: 32),
            // Copyright
            Center(
              child: Text(
                '© 2024 Fast Golden Taxi. All rights reserved.',
                style: AppTextStyles.of(
                  context,
                ).bodySmall.copyWith(color: AppColors.of(context).textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title) {
    return Text(
      title,
      style: AppTextStyles.of(
        context,
      ).titleLarge.copyWith(color: AppColors.of(context).primary, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.of(context).primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.of(context).primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.of(context).titleMedium),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.of(
                    context,
                  ).bodyMedium.copyWith(color: AppColors.of(context).textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.of(context).primary, size: 20),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: AppTextStyles.of(context).bodyMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value, style: AppTextStyles.of(context).bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.of(context).primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
