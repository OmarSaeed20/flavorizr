// lib/features/company/company_profile/presentation/pages/company_edit_profile_page.dart
import 'dart:io';

import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/theme/app_colors.dart';
import 'package:fast_golden_taxi/core/theme/app_text_styles.dart';
import 'package:fast_golden_taxi/features/company/company_profile/data/parameters/update_company_profile_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_profile/presentation/controllers/company_profile_controller.dart';
import 'package:fast_golden_taxi/features/company/company_profile/presentation/providers/company_profile_providers.dart';
import 'package:fast_golden_taxi/shared/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// Company Edit Profile Page
///
/// Page for editing company profile information.
class CompanyEditProfilePage extends ConsumerStatefulWidget {
  const CompanyEditProfilePage({super.key});

  @override
  ConsumerState<CompanyEditProfilePage> createState() => _CompanyEditProfilePageState();
}

class _CompanyEditProfilePageState extends ConsumerState<CompanyEditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _bioController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedImagePath;

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final parameters = UpdateCompanyProfileParameters(
      name: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
      nickname: _nicknameController.text.trim().isEmpty ? null : _nicknameController.text.trim(),
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
      bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
    );

    await ref.read(companyProfileControllerProvider.notifier).updateProfileInfo(parameters);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(companyProfileControllerProvider);
    final user = ref.watch(companyUserProvider);

    // Initialize controllers with user data
    if (user != null && _nameController.text.isEmpty) {
      _nameController.text = user.name ?? '';
      _nicknameController.text = user.nickname ?? '';
      _emailController.text = user.email ?? '';
      _addressController.text = user.address ?? '';
      _bioController.text = user.bio ?? '';
    }

    ref.listen<CompanyProfileState>(companyProfileControllerProvider, (previous, next) {
      next.maybeWhen(
        updated: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile updated successfully'),
              backgroundColor: AppColors.of(context).success,
            ),
          );
          context.pop();
        },
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
        title: const Text('Edit Profile'),
        actions: [TextButton(onPressed: _handleSave, child: const Text('Save'))],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image Section
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: _selectedImagePath != null
                                    ? null
                                    : (user?.image != null ? NetworkImage(user!.image!) : null),
                                child: _selectedImagePath != null
                                    ? null
                                    : (user?.image == null
                                          ? const Icon(Icons.business, size: 60)
                                          : null),
                              ),
                              if (_selectedImagePath != null)
                                ClipOval(
                                  child: Image.file(
                                    File(_selectedImagePath!),
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.of(context).primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to change photo',
                          style: AppTextStyles.of(
                            context,
                          ).bodySmall.copyWith(color: AppColors.of(context).textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Company Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Company Name',
                      hintText: 'Enter company name',
                      prefixIcon: Icon(Icons.business_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter company name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Nickname
                  TextFormField(
                    controller: _nicknameController,
                    decoration: const InputDecoration(
                      labelText: 'Nickname (Optional)',
                      hintText: 'Enter nickname',
                      prefixIcon: Icon(Icons.badge_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email (Optional)',
                      hintText: 'Enter email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value != null && value.trim().isNotEmpty) {
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Invalid email format';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Address
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address (Optional)',
                      hintText: 'Enter address',
                      prefixIcon: Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  // Bio
                  TextFormField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                      labelText: 'Bio (Optional)',
                      hintText: 'Tell us about your company',
                      prefixIcon: Icon(Icons.info_outline),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleSave,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (profileState.maybeWhen(updating: () => true, orElse: () => false))
            const LoadingOverlay(),
        ],
      ),
    );
  }
}
