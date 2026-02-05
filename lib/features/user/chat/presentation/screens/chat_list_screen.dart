// lib/features/chat/presentation/screens/chat_list_screen.dart
import 'package:flavorizr/features/user/chat/domain/entities/conversation.dart';
import 'package:flavorizr/features/user/chat/presentation/providers/chat_providers.dart';
import 'package:flavorizr/features/user/chat/presentation/screens/conversation_screen.dart';
import 'package:flavorizr/features/user/chat/presentation/widgets/conversation_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen displaying the list of conversations.
class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  static const String routeName = '/chat';

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Load conversations on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(conversationsProvider.notifier).loadConversations();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(conversationsProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    await ref
        .read(conversationsProvider.notifier)
        .loadConversations(refresh: true);
  }

  void _onConversationTap(Conversation conversation) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ConversationScreen(
          conversationId: conversation.id,
          title: conversation.name ?? 'Chat',
        ),
      ),
    );
  }

  void _onNewChat() {
    // TO-DO: Show new chat dialog/screen
    _showNewChatOptions();
  }

  void _showNewChatOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('New Direct Message'),
              onTap: () {
                Navigator.pop(context);
                _showUserPicker();
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('New Group'),
              onTap: () {
                Navigator.pop(context);
                _showCreateGroupDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUserPicker() {
    // TO-DO: Implement user picker for new direct message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User picker not implemented yet')),
    );
  }

  void _showCreateGroupDialog() {
    // TO-DO: Implement create group dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create group not implemented yet')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(conversationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TO-DO: Implement search
            },
          ),
        ],
      ),
      body: _buildBody(state),
      floatingActionButton: FloatingActionButton(
        onPressed: _onNewChat,
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildBody(ConversationsState state) {
    if (state.isLoading && state.conversations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              state.error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _onRefresh, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (state.conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No conversations yet',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a new chat to begin messaging',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.conversations.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.conversations.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final conversation = state.conversations[index];
          return ConversationTile(
            conversation: conversation,
            onTap: () => _onConversationTap(conversation),
          );
        },
      ),
    );
  }
}
