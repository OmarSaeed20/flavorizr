// lib/features/chat/domain/usecases/message_actions.dart
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/chat/domain/entities/message.dart';
import 'package:flavorizr/features/user/chat/domain/repositories/chat_repository.dart';

/// Use case for editing a message.
class EditMessage {
  EditMessage(this._repository);
  final ChatRepository _repository;

  /// Executes the use case.
  Future<ApiResult<Message>> call({
    required String messageId,
    required String content,
  }) {
    return _repository.editMessage(messageId: messageId, content: content);
  }
}

/// Use case for deleting a message.
class DeleteMessage {
  DeleteMessage(this._repository);
  final ChatRepository _repository;

  /// Executes the use case.
  ///
  /// [forEveryone] - If true, deletes for all users.
  Future<ApiResult<void>> call({
    required String messageId,
    bool forEveryone = false,
  }) {
    return _repository.deleteMessage(
      messageId: messageId,
      forEveryone: forEveryone,
    );
  }
}

/// Use case for adding a reaction to a message.
class AddReaction {
  AddReaction(this._repository);
  final ChatRepository _repository;

  /// Executes the use case.
  Future<ApiResult<void>> call({
    required String messageId,
    required String reaction,
  }) {
    return _repository.addReaction(messageId: messageId, reaction: reaction);
  }
}

/// Use case for removing a reaction from a message.
class RemoveReaction {
  RemoveReaction(this._repository);
  final ChatRepository _repository;

  /// Executes the use case.
  Future<ApiResult<void>> call({
    required String messageId,
    required String reaction,
  }) {
    return _repository.removeReaction(messageId: messageId, reaction: reaction);
  }
}

/// Use case for marking messages as read.
class MarkMessagesAsRead {
  MarkMessagesAsRead(this._repository);
  final ChatRepository _repository;

  /// Executes the use case.
  Future<ApiResult<void>> call({
    required String conversationId,
    String? upToMessageId,
  }) {
    return _repository.markAsRead(
      conversationId: conversationId,
      upToMessageId: upToMessageId,
    );
  }
}

/// Use case for sending media messages.
class SendMediaMessage {
  SendMediaMessage(this._repository);
  final ChatRepository _repository;

  /// Executes the use case.
  Future<ApiResult<Message>> call({
    required String conversationId,
    required String filePath,
    required String type,
    String? caption,
    String? replyToId,
    String? localId,
    void Function(double progress)? onProgress,
  }) {
    return _repository.sendMediaMessage(
      conversationId: conversationId,
      filePath: filePath,
      type: type,
      caption: caption,
      replyToId: replyToId,
      localId: localId,
      onProgress: onProgress,
    );
  }
}
