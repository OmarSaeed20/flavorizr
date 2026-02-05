// lib/features/chat/presentation/widgets/chat_input.dart
import 'package:flutter/material.dart';

/// Text input widget for composing messages.
class ChatInput extends StatelessWidget {
  const ChatInput({
    super.key,
    required this.controller,
    this.focusNode,
    required this.onSend,
    this.onAttachment,
    this.onVoice,
    this.hintText = 'Type a message...',
  });
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback onSend;
  final VoidCallback? onAttachment;
  final VoidCallback? onVoice;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (onAttachment != null)
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: onAttachment,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        maxLines: 5,
                        minLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: hintText,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _handleSend(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.emoji_emotions_outlined),
                      onPressed: () {
                        // TO-DO: Show emoji picker
                      },
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, child) {
                final hasText = value.text.trim().isNotEmpty;

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: hasText
                      ? _SendButton(
                          key: const ValueKey('send'),
                          onPressed: _handleSend,
                          theme: theme,
                        )
                      : _VoiceButton(
                          key: const ValueKey('voice'),
                          onPressed: onVoice,
                          theme: theme,
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleSend() {
    if (controller.text.trim().isNotEmpty) {
      onSend();
    }
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({super.key, required this.onPressed, required this.theme});
  final VoidCallback onPressed;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.send),
        onPressed: onPressed,
        color: theme.colorScheme.onPrimary,
      ),
    );
  }
}

class _VoiceButton extends StatelessWidget {
  const _VoiceButton({super.key, required this.onPressed, required this.theme});
  final VoidCallback? onPressed;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.mic),
        onPressed:
            onPressed ??
            () {
              // TO-DO: Implement voice recording
            },
        color: theme.colorScheme.onPrimary,
      ),
    );
  }
}

/// Attachment options bottom sheet.
class AttachmentOptionsSheet extends StatelessWidget {
  const AttachmentOptionsSheet({
    super.key,
    required this.onCamera,
    required this.onGallery,
    required this.onFile,
    this.onLocation,
    this.onContact,
  });
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onFile;
  final VoidCallback? onLocation;
  final VoidCallback? onContact;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AttachmentOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  color: Colors.pink,
                  onTap: () {
                    Navigator.pop(context);
                    onCamera();
                  },
                ),
                _AttachmentOption(
                  icon: Icons.photo,
                  label: 'Gallery',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    onGallery();
                  },
                ),
                _AttachmentOption(
                  icon: Icons.insert_drive_file,
                  label: 'Document',
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.pop(context);
                    onFile();
                  },
                ),
              ],
            ),
            if (onLocation != null || onContact != null) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (onLocation != null)
                    _AttachmentOption(
                      icon: Icons.location_on,
                      label: 'Location',
                      color: Colors.green,
                      onTap: () {
                        Navigator.pop(context);
                        onLocation!();
                      },
                    ),
                  if (onContact != null)
                    _AttachmentOption(
                      icon: Icons.person,
                      label: 'Contact',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pop(context);
                        onContact!();
                      },
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AttachmentOption extends StatelessWidget {
  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
