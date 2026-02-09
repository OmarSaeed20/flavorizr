// lib/features/profile/presentation/pages/edit_profile_page.dart
import 'dart:convert';

import 'package:fast_golden_taxi/features/user/profile/presentation/controllers/edit_profile_controller.dart';
import 'package:fast_golden_taxi/features/user/profile/presentation/providers/profile_providers.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/buttons/app_button.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Edit Profile Page for updating user profile information.
///
/// Features:
/// - Update name, nickname, email, gender, birth date
/// - Change profile photo
/// - Form validation
/// - Unsaved changes warning
class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthDateController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _nicknameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _birthDateFocusNode = FocusNode();

  String _selectedGender = 'male';

  @override
  void initState() {
    super.initState();
    // Load profile data when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    await ref.read(editProfileControllerProvider.notifier).loadProfile();
    final state = ref.read(editProfileControllerProvider);
    if (state.profile != null) {
      _nameController.text = state.name;
      _nicknameController.text = state.nickname;
      _emailController.text = state.email;
      _birthDateController.text = state.birthDate;
      _selectedGender = state.gender;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _nameFocusNode.dispose();
    _nicknameFocusNode.dispose();
    _emailFocusNode.dispose();
    _birthDateFocusNode.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    final state = ref.read(editProfileControllerProvider);
    if (!state.hasChanges) return true;

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes?'),
        content: const Text('You have unsaved changes. Are you sure you want to discard them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return shouldDiscard ?? false;
  }

  Future<void> _handleSave() async {
    await ref.read(editProfileControllerProvider.notifier).saveProfile();

    final state = ref.read(editProfileControllerProvider);
    if (state.isSuccess && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      ref.read(editProfileControllerProvider.notifier).resetSuccess();
      context.pop();
    }
  }

  void _handleReset() {
    ref.read(editProfileControllerProvider.notifier).resetForm();
    final state = ref.read(editProfileControllerProvider);
    _nameController.text = state.name;
    _nicknameController.text = state.nickname;
    _emailController.text = state.email;
    _birthDateController.text = state.birthDate;
    _selectedGender = state.gender;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editProfileControllerProvider);
    final theme = Theme.of(context);

    // Listen for errors
    ref.listen<EditProfileState>(editProfileControllerProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return PopScope(
      canPop: !state.hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          actions: [
            if (state.hasChanges)
              TextButton(
                onPressed: state.isSaving ? null : _handleReset,
                child: const Text('Reset'),
              ),
            const SizedBox(width: 8),
          ],
        ),
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildBody(context, state),
        bottomNavigationBar: state.isLoading ? null : _buildBottomBar(context, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, EditProfileState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Photo Section
            _buildProfilePhotoSection(context, state),
            const SizedBox(height: 32),

            // Name Field
            AppTextField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              label: 'Name',
              hint: 'Enter your full name',
              errorText: state.nameError,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              maxLength: 100,
              onChanged: (value) {
                ref.read(editProfileControllerProvider.notifier).updateName(value);
              },
              onSubmitted: (_) => _nicknameFocusNode.requestFocus(),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Nickname Field
            AppTextField(
              controller: _nicknameController,
              focusNode: _nicknameFocusNode,
              label: 'Nickname',
              hint: 'Enter your nickname',
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              maxLength: 50,
              onChanged: (value) {
                ref.read(editProfileControllerProvider.notifier).updateNickname(value);
              },
              onSubmitted: (_) => _emailFocusNode.requestFocus(),
            ),
            const SizedBox(height: 16),

            // Email Field
            AppTextField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              label: 'Email',
              hint: 'Enter your email address',
              errorText: state.emailError,
              prefixIcon: const Icon(Icons.email_outlined),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                ref.read(editProfileControllerProvider.notifier).updateEmail(value);
              },
              onSubmitted: (_) => _birthDateFocusNode.requestFocus(),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Gender Field
            _buildGenderField(context, state),
            const SizedBox(height: 16),

            // Birth Date Field
            AppTextField(
              controller: _birthDateController,
              focusNode: _birthDateFocusNode,
              label: 'Birth Date',
              hint: 'YYYY-MM-DD',
              errorText: state.birthDateError,
              prefixIcon: const Icon(Icons.calendar_today_outlined),
              keyboardType: TextInputType.datetime,
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                ref.read(editProfileControllerProvider.notifier).updateBirthDate(value);
              },
              onSubmitted: (_) => _handleSave(),
              onTap: () => _selectBirthDate(context),
              readOnly: true,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                  if (!dateRegex.hasMatch(value)) {
                    return 'Birth date must be in YYYY-MM-DD format';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePhotoSection(BuildContext context, EditProfileState state) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Photo',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Center(
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.surfaceContainerHighest,
                border: Border.all(color: theme.colorScheme.outline, width: 2),
              ),
              child: state.image.isNotEmpty
                  ? ClipOval(
                      child: Image.memory(
                        const Base64Decoder().convert(state.image),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 60,
                            color: theme.colorScheme.onSurfaceVariant,
                          );
                        },
                      ),
                    )
                  : Icon(Icons.person, size: 60, color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('Change Photo'),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField(BuildContext context, EditProfileState state) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gender', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'male', label: Text('Male'), icon: Icon(Icons.male)),
            ButtonSegment(value: 'female', label: Text('Female'), icon: Icon(Icons.female)),
          ],
          selected: {_selectedGender},
          onSelectionChanged: (Set<String> newSelection) {
            setState(() {
              _selectedGender = newSelection.first;
              ref.read(editProfileControllerProvider.notifier).updateGender(_selectedGender);
            });
          },
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    // TODO: Implement image picker
    // For now, this is a placeholder
    // You would use image_picker package to select an image
    // Then convert it to base64 and update the controller
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image picker not implemented yet'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && mounted) {
      final formattedDate =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      _birthDateController.text = formattedDate;
      ref.read(editProfileControllerProvider.notifier).updateBirthDate(formattedDate);
    }
  }

  Widget _buildBottomBar(BuildContext context, EditProfileState state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AppButton.primary(
          onPressed: state.hasChanges && !state.isSaving ? _handleSave : null,
          text: 'Save Changes',
          isLoading: state.isSaving,
          isDisabled: !state.hasChanges,
          width: double.infinity,
        ),
      ),
    );
  }
}
