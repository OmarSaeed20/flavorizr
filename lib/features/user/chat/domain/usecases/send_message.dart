// lib/features/chat/domain/usecases/send_message.dart
import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/entities/message.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/repositories/chat_repository.dart';

/// Use case for sending a text message.
class SendMessage {
  SendMessage(this._repository);
  final ChatRepository _repository;

  /// Executes the use case.
  ///
  /// [conversationId] - ID of the conversation.
  /// [content] - The message content.
  /// [replyToId] - Optional ID of message being replied to.
  /// [mentions] - Optional list of user IDs mentioned.
  /// [localId] - Optional local ID for optimistic updates.
  Future<ApiResult<Message>> call({
    required String conversationId,
    required String content,
    String? replyToId,
    List<String>? mentions,
    String? localId,
  }) {
    return _repository.sendMessage(
      conversationId: conversationId,
      content: content,
      replyToId: replyToId,
      mentions: mentions,
      localId: localId,
    );
  }
}
