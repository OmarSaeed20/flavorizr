// lib/features/chat/domain/usecases/get_messages.dart
import 'package:dartz/dartz.dart';

import 'package:flavorizr/core/error/failures.dart';
import 'package:flavorizr/features/chat/domain/entities/message.dart';
import 'package:flavorizr/features/chat/domain/repositories/chat_repository.dart';

/// Use case for getting messages in a conversation.
class GetMessages {
  GetMessages(this._repository);
  final ChatRepository _repository;

  /// Executes the use case.
  ///
  /// [conversationId] - ID of the conversation.
  /// [cursor] - Pagination cursor (usually a message ID).
  /// [limit] - Maximum number of messages to return.
  /// [direction] - 'before' or 'after' the cursor.
  Future<Either<Failure, PaginatedResult<Message>>> call({
    required String conversationId,
    String? cursor,
    int limit = 50,
    String direction = 'before',
  }) {
    return _repository.getMessages(
      conversationId: conversationId,
      cursor: cursor,
      limit: limit,
      direction: direction,
    );
  }
}
