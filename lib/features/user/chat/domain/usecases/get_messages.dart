// lib/features/chat/domain/usecases/get_messages.dart
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/entities/message.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/repositories/chat_repository.dart';

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
  Future<ApiResult<PaginatedResult<Message>>> call({
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
