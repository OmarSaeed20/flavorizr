// lib/features/company/company_settings/presentation/pages/company_faq_page.dart
import 'package:fast_golden_taxi/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Company FAQ Page
///
/// Displays frequently asked questions and answers.
class CompanyFaqPage extends StatelessWidget {
  const CompanyFaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FAQItem> faqItems = [
      FAQItem(
        question: 'How do I register my company?',
        answer:
            'To register your company, go to the registration page and fill in your company details including name, phone number, and other required information. You will need to verify your phone number to complete the registration.',
      ),
      FAQItem(
        question: 'How do I add drivers to my fleet?',
        answer:
            'You can add drivers to your fleet through the fleet management section. Each driver will need to complete their own registration and verification process before they can start accepting rides.',
      ),
      FAQItem(
        question: 'How are payments processed?',
        answer:
            'Payments are processed automatically after each completed ride. The fare is split between the platform and your company according to the agreed commission rate. You can view your earnings and payment history in the dashboard.',
      ),
      FAQItem(
        question: 'What happens if a driver cancels a ride?',
        answer:
            "If a driver cancels a ride, the passenger will be matched with another available driver. Repeated cancellations may affect your company's rating and could lead to account restrictions.",
      ),
      FAQItem(
        question: "How do I track my fleet's performance?",
        answer:
            "You can track your fleet's performance through the analytics dashboard. This includes metrics such as total rides, earnings, driver ratings, and cancellation rates.",
      ),
      FAQItem(
        question: 'Can I set custom pricing for my fleet?',
        answer:
            'Pricing is determined by the platform based on distance, time, and demand. However, you can offer promotional discounts to attract more customers during off-peak hours.',
      ),
      FAQItem(
        question: 'What support is available for companies?',
        answer:
            'We offer 24/7 support for all our company partners. You can reach us through the in-app support chat, email, or phone. Our dedicated account managers are also available to help with any issues.',
      ),
      FAQItem(
        question: 'How do I update my company information?',
        answer:
            'You can update your company information through the profile settings. Changes to critical information like phone number or business address may require additional verification.',
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: faqItems.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _buildFAQItem(context, faqItems[index]);
        },
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, FAQItem item) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(top: 8, bottom: 16),
      iconColor: AppColors.of(context).primary,
      collapsedIconColor: AppColors.of(context).primary,
      title: Text(item.question, style: AppTextStyles.of(context).titleMedium),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            item.answer,
            style: AppTextStyles.of(
              context,
            ).bodyMedium.copyWith(color: AppColors.of(context).textSecondary),
          ),
        ),
      ],
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
