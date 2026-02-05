// lib/features/chat/presentation/screens/conversation_screen.dart
import 'package:flavorizr/features/user/chat/domain/entities/message.dart';
import 'package:flavorizr/features/user/chat/presentation/providers/chat_providers.dart';
import 'package:flavorizr/features/user/chat/presentation/widgets/chat_input.dart';
import 'package:flavorizr/features/user/chat/presentation/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen displaying messages in a conversation.
class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({
    super.key,
    required this.conversationId,
    required this.title,
  });
  final String conversationId;
  final String title;

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  Message? _replyingTo;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Load messages on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(messagesNotifierProvider(widget.conversationId)).loadMessages();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Load more when scrolled near the top (older messages)
    if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent + 200) {
      ref.read(messagesNotifierProvider(widget.conversationId)).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    await ref
        .read(messagesNotifierProvider(widget.conversationId))
        .loadMessages(refresh: true);
  }

  void _onSendMessage() {
    final content = _textController.text.trim();
    if (content.isEmpty) return;

    ref
        .read(messagesNotifierProvider(widget.conversationId))
        .sendTextMessage(content, replyToId: _replyingTo?.id);

    _textController.clear();
    _cancelReply();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _onReply(Message message) {
    setState(() {
      _replyingTo = message;
    });
    _focusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyingTo = null;
    });
  }

  void _onMessageLongPress(Message message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _MessageOptionsSheet(
        message: message,
        onReply: () {
          Navigator.pop(context);
          _onReply(message);
        },
        onCopy: () {
          Navigator.pop(context);
          // TO-DO: Copy message
        },
        onEdit:
            message.senderId ==
                'current_user_id' // TO-DO: Get actual user ID
            ? () {
                Navigator.pop(context);
                _showEditDialog(message);
              }
            : null,
        onDelete: message.senderId == 'current_user_id'
            ? () {
                Navigator.pop(context);
                _showDeleteConfirmation(message);
              }
            : null,
        onReact: () {
          Navigator.pop(context);
          _showReactionPicker(message);
        },
      ),
    );
  }

  void _showEditDialog(Message message) {
    final controller = TextEditingController(text: message.content);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Message'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: null,
          decoration: const InputDecoration(hintText: 'Enter new message'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newContent = controller.text.trim();
              if (newContent.isNotEmpty && newContent != message.content) {
                ref
                    .read(messagesNotifierProvider(widget.conversationId))
                    .editMessage(message.id, newContent);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Message message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(messagesNotifierProvider(widget.conversationId))
                  .deleteMessage(message.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showReactionPicker(Message message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: ['👍', '❤️', '😂', '😮', '😢', '😡', '👏', '🎉'].map((
              emoji,
            ) {
              return InkWell(
                onTap: () {
                  ref
                      .read(messagesNotifierProvider(widget.conversationId))
                      .addReaction(message.id, emoji);
                  Navigator.pop(context);
                },
                child: Text(emoji, style: const TextStyle(fontSize: 32)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(messagesNotifierProvider(widget.conversationId));
    final state = notifier.state;
    final typingUsers = ref.watch(typingUsersProvider(widget.conversationId));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title),
            if (typingUsers.isNotEmpty)
              Text(
                '${typingUsers.length} typing...',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TO-DO: Show conversation options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList(state)),
          if (_replyingTo != null)
            _ReplyPreview(message: _replyingTo!, onCancel: _cancelReply),
          ChatInput(
            controller: _textController,
            focusNode: _focusNode,
            onSend: _onSendMessage,
            onAttachment: () {
              // TO-DO: Show attachment options
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(MessagesState state) {
    if (state.isLoading && state.messages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(state.error!),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _onRefresh, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (state.messages.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No messages yet'),
            SizedBox(height: 8),
            Text('Send a message to start the conversation'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        reverse: true, // Messages are displayed bottom to top
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        itemCount: state.messages.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (state.isLoadingMore && index == state.messages.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final message = state.messages[index];
          final isMe =
              message.senderId ==
              'current_user_id'; // TO-DO: Get actual user ID

          // Check if we should show date separator
          final showDateSeparator = _shouldShowDateSeparator(
            state.messages,
            index,
          );

          return Column(
            children: [
              if (showDateSeparator) _DateSeparator(date: message.createdAt),
              MessageBubble(
                message: message,
                isMe: isMe,
                onLongPress: () => _onMessageLongPress(message),
                onReactionTap: (emoji) {
                  ref
                      .read(messagesNotifierProvider(widget.conversationId))
                      .addReaction(message.id, emoji);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  bool _shouldShowDateSeparator(List<Message> messages, int index) {
    if (index == messages.length - 1) return true; // Show for oldest message

    final current = messages[index];
    final previous =
        messages[index + 1]; // Previous in list (but actually newer)

    return !_isSameDay(current.createdAt, previous.createdAt);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

/// Bottom sheet with message options.
class _MessageOptionsSheet extends StatelessWidget {
  const _MessageOptionsSheet({
    required this.message,
    required this.onReply,
    required this.onCopy,
    this.onEdit,
    this.onDelete,
    required this.onReact,
  });
  final Message message;
  final VoidCallback onReply;
  final VoidCallback onCopy;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback onReact;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.reply),
            title: const Text('Reply'),
            onTap: onReply,
          ),
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('Copy'),
            onTap: onCopy,
          ),
          ListTile(
            leading: const Icon(Icons.emoji_emotions_outlined),
            title: const Text('React'),
            onTap: onReact,
          ),
          if (onEdit != null)
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: onEdit,
            ),
          if (onDelete != null)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: onDelete,
            ),
        ],
      ),
    );
  }
}

/// Reply preview widget shown above input.
class _ReplyPreview extends StatelessWidget {
  const _ReplyPreview({required this.message, required this.onCancel});
  final Message message;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(
          left: BorderSide(color: theme.colorScheme.primary, width: 4),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Replying to ${message.senderName ?? 'Unknown'}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message.content ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: onCancel,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

/// Date separator widget between messages.
class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _formatDate(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  String _formatDate() {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      const days = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      return days[date.weekday - 1];
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
