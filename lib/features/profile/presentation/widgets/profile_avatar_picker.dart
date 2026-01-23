// lib/features/profile/presentation/widgets/profile_avatar_picker.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// A widget for displaying and picking profile avatar images.
///
/// Features:
/// - Display current avatar or initials fallback
/// - Pick image from gallery or camera
/// - Remove current image option
/// - Loading state indicator
class ProfileAvatarPicker extends StatelessWidget {
  const ProfileAvatarPicker({
    super.key,
    this.photoUrl,
    this.displayName = '',
    this.isLoading = false,
    this.size = 120,
    this.onPickImage,
    this.onRemoveImage,
  });

  /// URL of the current profile photo.
  final String? photoUrl;

  /// Display name for generating initials fallback.
  final String displayName;

  /// Whether image is being uploaded.
  final bool isLoading;

  /// Size of the avatar.
  final double size;

  /// Callback when a new image is picked.
  final Future<void> Function(String imagePath)? onPickImage;

  /// Callback when the image is removed.
  final Future<void> Function()? onRemoveImage;

  String get _initials {
    final parts = displayName.trim().split(' ');
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  Future<void> _showImagePicker(BuildContext context) async {
    final theme = Theme.of(context);

    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Change Profile Photo',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            if (photoUrl != null) ...[
              const Divider(),
              ListTile(
                leading: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                title: Text('Remove Photo', style: TextStyle(color: theme.colorScheme.error)),
                onTap: () {
                  Navigator.pop(context);
                  onRemoveImage?.call();
                },
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      await onPickImage?.call(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: isLoading ? null : () => _showImagePicker(context),
      child: Stack(
        children: [
          // Avatar
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3), width: 2),
            ),
            child: ClipOval(child: _buildAvatarContent(context)),
          ),

          // Edit Badge
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.surface, width: 2),
              ),
              child: Icon(Icons.camera_alt, size: 18, color: theme.colorScheme.onPrimary),
            ),
          ),

          // Loading Overlay
          if (isLoading)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.5),
                ),
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarContent(BuildContext context) {
    final theme = Theme.of(context);

    if (photoUrl != null && photoUrl!.isNotEmpty) {
      // Check if it's a local file path
      if (photoUrl!.startsWith('/') || photoUrl!.startsWith('file://')) {
        return Image.file(
          File(photoUrl!.replaceFirst('file://', '')),
          fit: BoxFit.cover,
          width: size,
          height: size,
          errorBuilder: (context, error, stackTrace) => _buildInitialsFallback(theme),
        );
      }

      // Network image
      return Image.network(
        photoUrl!,
        fit: BoxFit.cover,
        width: size,
        height: size,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildInitialsFallback(theme),
      );
    }

    return _buildInitialsFallback(theme);
  }

  Widget _buildInitialsFallback(ThemeData theme) {
    return Container(
      width: size,
      height: size,
      color: theme.colorScheme.primaryContainer,
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: theme.textTheme.headlineMedium?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
