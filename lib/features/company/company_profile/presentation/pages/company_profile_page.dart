// lib/features/company/company_profile/presentation/pages/company_profile_page.dart
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/theme/app_colors.dart';
import 'package:fast_golden_taxi/core/theme/app_text_styles.dart';
import 'package:fast_golden_taxi/features/company/company_auth/presentation/providers/company_auth_providers.dart';
import 'package:fast_golden_taxi/features/company/company_profile/presentation/controllers/company_profile_controller.dart';
import 'package:fast_golden_taxi/features/company/company_profile/presentation/providers/company_profile_providers.dart';
import 'package:fast_golden_taxi/shared/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Company Profile Page
///
/// Displays company profile information with edit capabilities.
class CompanyProfilePage extends ConsumerStatefulWidget {
  const CompanyProfilePage({super.key});

  @override
  ConsumerState<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends ConsumerState<CompanyProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load profile on page init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(companyProfileControllerProvider.notifier).getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(companyProfileControllerProvider);
    final authState = ref.watch(companyAuthControllerProvider);

    ref.listen<CompanyProfileState>(companyProfileControllerProvider, (previous, next) {
      next.maybeWhen(
        error: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message), backgroundColor: AppColors.of(context).error),
          );
        },
        orElse: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push('/company/profile/edit');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          profileState.maybeWhen(
            loaded: _buildProfileContent,
            updated: _buildProfileContent,
            error: _buildErrorState,
            orElse: () => const SizedBox.shrink(),
          ),
          if (profileState.maybeWhen(loading: () => true, orElse: () => false))
            const LoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildProfileContent(dynamic user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                // Profile Image
                CircleAvatar(
                  radius: 60,
                  backgroundImage: user.image != null ? NetworkImage(user.image!) : null,
                  child: user.image == null ? const Icon(Icons.business, size: 60) : null,
                ),
                const SizedBox(height: 16),
                // Company Name
                Text(
                  user.name ?? 'Company Name',
                  style: AppTextStyles.of(context).headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Nickname
                if (user.nickname != null && user.nickname!.isNotEmpty)
                  Text(
                    user.nickname!,
                    style: AppTextStyles.of(
                      context,
                    ).bodyMedium.copyWith(color: AppColors.of(context).textSecondary),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Profile Details Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Company Information', style: AppTextStyles.of(context).titleLarge),
                  const SizedBox(height: 16),
                  _buildDetailRow(Icons.phone, 'Phone', user.phone ?? 'N/A'),
                  _buildDetailRow(Icons.email, 'Email', user.email ?? 'N/A'),
                  _buildDetailRow(Icons.location_on, 'Address', user.address ?? 'N/A'),
                  if (user.bio != null && user.bio!.isNotEmpty)
                    _buildDetailRow(Icons.info, 'Bio', user.bio!),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Account Details Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Account Details', style: AppTextStyles.of(context).titleLarge),
                  const SizedBox(height: 16),
                  _buildDetailRow(Icons.person, 'Gender', user.gender ?? 'N/A'),
                  _buildDetailRow(Icons.calendar_today, 'Birthdate', user.birthdate ?? 'N/A'),
                  _buildDetailRow(Icons.public, 'Country', user.country?.name ?? 'N/A'),
                  _buildDetailRow(
                    Icons.location_city,
                    'Governorate',
                    user.governorate?.name ?? 'N/A',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showLogoutDialog,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.of(context).error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.of(context).primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.of(
                    context,
                  ).bodySmall.copyWith(color: AppColors.of(context).textSecondary),
                ),
                Text(value, style: AppTextStyles.of(context).bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(dynamic error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.of(context).error),
          const SizedBox(height: 16),
          Text('Failed to load profile', style: AppTextStyles.of(context).titleLarge),
          const SizedBox(height: 8),
          Text(
            error.message,
            style: AppTextStyles.of(context).bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.read(companyProfileControllerProvider.notifier).getProfile();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              // TODO: Implement logout
              context.go('/auth/role-selection');
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.of(context).error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
