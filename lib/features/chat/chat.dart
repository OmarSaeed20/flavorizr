// lib/features/chat/chat.dart
/// Chat feature module.
///
/// Provides real-time messaging functionality including:
/// - Direct and group conversations
/// - Text, image, video, audio, and file messages
/// - Message reactions and replies
/// - Typing indicators and presence
/// - WebSocket-based real-time updates
library;

// Domain layer
export 'domain/entities/entities.dart';
export 'domain/repositories/chat_repository.dart';
export 'domain/usecases/create_conversation.dart';
export 'domain/usecases/get_conversations.dart';
export 'domain/usecases/get_messages.dart';
export 'domain/usecases/message_actions.dart';
export 'domain/usecases/send_message.dart';

// Data layer
export 'data/datasources/chat_local_datasource.dart';
export 'data/datasources/chat_remote_datasource.dart';
export 'data/repositories/chat_repository_impl.dart';

// Presentation layer
export 'presentation/providers/chat_providers.dart';
export 'presentation/screens/screens.dart';
export 'presentation/widgets/widgets.dart';
