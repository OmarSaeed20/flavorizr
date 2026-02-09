// lib/features/chat/domain/usecases/get_conversations.dart
import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/entities/conversation.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/repositories/chat_repository.dart';

/// Use case for getting all conversations.
class GetConversations {
  GetConversations(this._repository);
  final ChatRepository _repository;

  /// Executes the use case.
  ///
  /// [cursor] - Pagination cursor from previous page.
  /// [limit] - Maximum number of conversations to return.
  /// [includeArchived] - Whether to include archived conversations.
  Future<ApiResult<PaginatedResult<Conversation>>> call({
    String? cursor,
    int limit = 20,
    bool includeArchived = false,
  }) {
    return _repository.getConversations(
      cursor: cursor,
      limit: limit,
      includeArchived: includeArchived,
    );
  }
}
