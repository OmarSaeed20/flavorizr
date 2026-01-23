// lib/features/feed/presentation/widgets/post_card.dart
import 'package:flavorizr/features/feed/domain/entities/post.dart';
import 'package:flutter/material.dart';

/// Card widget for displaying a post in the feed.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    this.onReaction,
    this.onComment,
    this.onShare,
    this.onTap,
    this.onAuthorTap,
    this.onDelete,
  });

  final Post post;
  final void Function(ReactionType type)? onReaction;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onTap;
  final VoidCallback? onAuthorTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, theme),
              if (post.hasContent) ...[const SizedBox(height: 12), _buildContent(theme)],
              if (post.hasImages) ...[const SizedBox(height: 12), _buildImages(context)],
              if (post.tags.isNotEmpty) ...[const SizedBox(height: 12), _buildTags(theme)],
              const SizedBox(height: 12),
              _buildStats(theme),
              const Divider(height: 24),
              _buildActions(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        GestureDetector(
          onTap: onAuthorTap,
          child: CircleAvatar(
            radius: 20,
            backgroundImage: post.authorPhotoUrl != null
                ? NetworkImage(post.authorPhotoUrl!)
                : null,
            child: post.authorPhotoUrl == null
                ? Text(
                    post.authorName.isNotEmpty ? post.authorName[0].toUpperCase() : '?',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: onAuthorTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      post.authorName,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (post.isEdited) ...[
                      const SizedBox(width: 4),
                      Text(
                        '(edited)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  post.timeAgo,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              onDelete?.call();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'share',
              child: Row(children: [Icon(Icons.share_outlined), SizedBox(width: 8), Text('Share')]),
            ),
            const PopupMenuItem(
              value: 'report',
              child: Row(children: [Icon(Icons.flag_outlined), SizedBox(width: 8), Text('Report')]),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Text(post.content!, style: theme.textTheme.bodyLarge);
  }

  Widget _buildImages(BuildContext context) {
    if (post.imageUrls.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            post.imageUrls.first,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => ColoredBox(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.image_not_supported),
            ),
          ),
        ),
      );
    }

    // Grid for multiple images
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: post.imageUrls.length > 4 ? 4 : post.imageUrls.length,
      itemBuilder: (context, index) {
        final isLastWithMore = index == 3 && post.imageUrls.length > 4;
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                post.imageUrls[index],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => ColoredBox(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            if (isLastWithMore)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '+${post.imageUrls.length - 4}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTags(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: post.tags.map((tag) {
        return Chip(
          label: Text('#$tag'),
          labelStyle: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
          padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          backgroundColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
          side: BorderSide.none,
        );
      }).toList(),
    );
  }

  Widget _buildStats(ThemeData theme) {
    return Row(
      children: [
        if (post.totalReactions > 0) ...[_buildReactionsSummary(theme), const SizedBox(width: 16)],
        if (post.commentsCount > 0)
          Text(
            '${post.commentsCount} comments',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        const Spacer(),
        if (post.sharesCount > 0)
          Text(
            '${post.sharesCount} shares',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
      ],
    );
  }

  Widget _buildReactionsSummary(ThemeData theme) {
    // Show top 3 reaction emojis
    final topReactions = post.reactionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final displayReactions = topReactions.take(3);

    return Row(
      children: [
        ...displayReactions.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Text(entry.key.emoji, style: const TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '${post.totalReactions}',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ActionButton(
          icon: post.hasUserReacted ? Icons.thumb_up : Icons.thumb_up_outlined,
          label: post.userReaction?.label ?? 'Like',
          isActive: post.hasUserReacted,
          activeColor: _getReactionColor(post.userReaction, theme),
          onTap: () => _showReactionPicker(context),
          onLongPress: () => _showReactionPicker(context),
        ),
        _ActionButton(icon: Icons.comment_outlined, label: 'Comment', onTap: onComment),
        _ActionButton(icon: Icons.share_outlined, label: 'Share', onTap: onShare),
      ],
    );
  }

  Color _getReactionColor(ReactionType? type, ThemeData theme) {
    if (type == null) return theme.colorScheme.primary;
    switch (type) {
      case ReactionType.like:
        return Colors.blue;
      case ReactionType.love:
        return Colors.red;
      case ReactionType.haha:
        return Colors.amber;
      case ReactionType.wow:
        return Colors.amber;
      case ReactionType.sad:
        return Colors.amber;
      case ReactionType.angry:
        return Colors.orange;
    }
  }

  void _showReactionPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ReactionType.values.map((type) {
              final isSelected = post.userReaction == type;
              return GestureDetector(
                onTap: () {
                  onReaction?.call(type);
                  Navigator.pop(context);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(type.emoji, style: TextStyle(fontSize: isSelected ? 36 : 28)),
                      const SizedBox(height: 4),
                      Text(type.label, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.activeColor,
    this.onTap,
    this.onLongPress,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final Color? activeColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive
        ? activeColor ?? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 4),
            Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
