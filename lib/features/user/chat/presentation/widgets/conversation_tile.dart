// lib/features/chat/presentation/widgets/conversation_tile.dart
import 'package:fast_golden_taxi/features/user/chat/domain/entities/conversation.dart';
import 'package:flutter/material.dart';

/// A tile widget displaying a conversation in a list.
class ConversationTile extends StatelessWidget {
  const ConversationTile({super.key, required this.conversation, this.onTap, this.onLongPress});
  final Conversation conversation;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasUnread = conversation.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _buildAvatar(context),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getDisplayName(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTimestamp(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: hasUnread
                              ? theme.colorScheme.primary
                              : theme.textTheme.bodySmall?.color,
                          fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(child: _buildLastMessagePreview(theme)),
                      if (hasUnread) ...[const SizedBox(width: 8), _buildUnreadBadge(theme)],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final theme = Theme.of(context);

    if (conversation.imageUrl != null) {
      return CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(conversation.imageUrl!),
        onBackgroundImageError: (_, __) {},
        child: conversation.imageUrl == null
            ? Text(_getInitials(), style: const TextStyle(fontSize: 18))
            : null,
      );
    }

    return CircleAvatar(
      radius: 28,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: conversation.type == ConversationType.group
          ? Icon(Icons.group, color: theme.colorScheme.onPrimaryContainer)
          : Text(
              _getInitials(),
              style: TextStyle(fontSize: 18, color: theme.colorScheme.onPrimaryContainer),
            ),
    );
  }

  String _getDisplayName() {
    if (conversation.name != null && conversation.name!.isNotEmpty) {
      return conversation.name!;
    }

    if (conversation.participants.isNotEmpty) {
      return conversation.participants.map((p) => p.displayName ?? p.id).join(', ');
    }

    return 'Unknown';
  }

  String _getInitials() {
    final name = _getDisplayName();
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Widget _buildLastMessagePreview(ThemeData theme) {
    final lastMessage = conversation.lastMessage;

    if (lastMessage == null) {
      return Text(
        'No messages yet',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.textTheme.bodySmall?.color,
          fontStyle: FontStyle.italic,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    var preview = lastMessage.content ?? '';
    if (lastMessage.type.name != 'text') {
      preview = _getMessageTypeLabel(lastMessage.type.name);
    }

    return Text(
      preview,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: conversation.unreadCount > 0
            ? theme.textTheme.bodyMedium?.color
            : theme.textTheme.bodySmall?.color,
        fontWeight: conversation.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _getMessageTypeLabel(String type) {
    switch (type) {
      case 'image':
        return '📷 Photo';
      case 'video':
        return '🎥 Video';
      case 'audio':
        return '🎵 Audio';
      case 'file':
        return '📎 File';
      case 'voice':
        return '🎤 Voice message';
      case 'location':
        return '📍 Location';
      default:
        return 'Message';
    }
  }

  Widget _buildUnreadBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        conversation.unreadCount > 99 ? '99+' : conversation.unreadCount.toString(),
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatTimestamp() {
    final timestamp = conversation.lastMessage?.createdAt ?? conversation.updatedAt;

    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      // Today - show time
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      // This week - show day name
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[timestamp.weekday - 1];
    } else {
      // Older - show date
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
