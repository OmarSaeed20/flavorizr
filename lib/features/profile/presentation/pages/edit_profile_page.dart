// lib/features/profile/presentation/pages/edit_profile_page.dart
import 'package:flavorizr/features/profile/presentation/controllers/edit_profile_controller.dart';
import 'package:flavorizr/features/profile/presentation/providers/profile_providers.dart';
import 'package:flavorizr/features/profile/presentation/widgets/profile_avatar_picker.dart';
import 'package:flavorizr/features/profile/presentation/widgets/profile_cover_picker.dart';
import 'package:flavorizr/shared/presentation/widgets/buttons/app_button.dart';
import 'package:flavorizr/shared/presentation/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Edit Profile Page for updating user profile information.
///
/// Features:
/// - Update display name, bio, location, website
/// - Change profile photo
/// - Change cover photo
/// - Form validation
/// - Unsaved changes warning
class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();
  final _websiteController = TextEditingController();

  final _displayNameFocusNode = FocusNode();
  final _bioFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final _websiteFocusNode = FocusNode();

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
      _displayNameController.text = state.displayName;
      _bioController.text = state.bio;
      _locationController.text = state.location;
      _websiteController.text = state.website;
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _displayNameFocusNode.dispose();
    _bioFocusNode.dispose();
    _locationFocusNode.dispose();
    _websiteFocusNode.dispose();
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
    if (_formKey.currentState?.validate() ?? false) {
      final profile = await ref.read(editProfileControllerProvider.notifier).saveProfile();

      if (profile != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      }
    }
  }

  void _handleReset() {
    ref.read(editProfileControllerProvider.notifier).resetForm();
    final state = ref.read(editProfileControllerProvider);
    _displayNameController.text = state.displayName;
    _bioController.text = state.bio;
    _locationController.text = state.location;
    _websiteController.text = state.website;
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
            // Cover Photo Section
            _buildCoverPhotoSection(context, state),
            const SizedBox(height: 24),

            // Profile Photo Section
            _buildProfilePhotoSection(context, state),
            const SizedBox(height: 32),

            // Display Name Field
            AppTextField(
              controller: _displayNameController,
              focusNode: _displayNameFocusNode,
              label: 'Display Name',
              hint: 'Enter your display name',
              errorText: state.displayNameError,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              maxLength: 50,
              onChanged: (value) {
                ref.read(editProfileControllerProvider.notifier).setDisplayName(value);
              },
              onSubmitted: (_) => _bioFocusNode.requestFocus(),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Display name is required';
                }
                if (value.trim().length < 2) {
                  return 'Display name must be at least 2 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Bio Field
            AppTextField(
              controller: _bioController,
              focusNode: _bioFocusNode,
              label: 'Bio',
              hint: 'Tell us about yourself',
              errorText: state.bioError,
              maxLines: 4,
              maxLength: 500,
              textInputAction: TextInputAction.newline,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                ref.read(editProfileControllerProvider.notifier).setBio(value);
              },
            ),
            const SizedBox(height: 16),

            // Location Field
            AppTextField(
              controller: _locationController,
              focusNode: _locationFocusNode,
              label: 'Location',
              hint: 'Where are you located?',
              prefixIcon: const Icon(Icons.location_on_outlined),
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              onChanged: (value) {
                ref.read(editProfileControllerProvider.notifier).setLocation(value);
              },
              onSubmitted: (_) => _websiteFocusNode.requestFocus(),
            ),
            const SizedBox(height: 16),

            // Website Field
            AppTextField(
              controller: _websiteController,
              focusNode: _websiteFocusNode,
              label: 'Website',
              hint: 'https://your-website.com',
              errorText: state.websiteError,
              prefixIcon: const Icon(Icons.link_outlined),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                ref.read(editProfileControllerProvider.notifier).setWebsite(value);
              },
              onSubmitted: (_) => _handleSave(),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final urlRegex = RegExp(r'^https?://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(/\S*)?$');
                  if (!urlRegex.hasMatch(value)) {
                    return 'Please enter a valid URL';
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

  Widget _buildCoverPhotoSection(BuildContext context, EditProfileState state) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cover Photo',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ProfileCoverPicker(
          coverPhotoUrl: state.profile?.coverPhotoUrl,
          isLoading: state.isPhotoUploading,
          onPickImage: (imagePath) async {
            await ref.read(editProfileControllerProvider.notifier).updateCoverPhoto(imagePath);
          },
          onRemoveImage: () async {
            await ref.read(editProfileControllerProvider.notifier).removeCoverPhoto();
          },
        ),
      ],
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
          child: ProfileAvatarPicker(
            photoUrl: state.profile?.photoUrl,
            displayName: state.displayName,
            isLoading: state.isPhotoUploading,
            onPickImage: (imagePath) async {
              await ref.read(editProfileControllerProvider.notifier).updatePhoto(imagePath);
            },
            onRemoveImage: () async {
              await ref.read(editProfileControllerProvider.notifier).removePhoto();
            },
          ),
        ),
      ],
    );
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
