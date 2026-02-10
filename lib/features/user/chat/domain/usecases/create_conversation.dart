// lib/features/chat/domain/usecases/create_conversation.dart
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/entities/conversation.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/repositories/chat_repository.dart';

/// Use case for creating a direct conversation.
class CreateDirectConversation {
  CreateDirectConversation(this._repository);
  final ChatRepository _repository;

  /// Executes the use case.
  ///
  /// [otherUserId] - ID of the other user.
  /// Returns existing conversation if one already exists.
  Future<ApiResult<Conversation>> call({required String otherUserId}) {
    return _repository.createDirectConversation(otherUserId: otherUserId);
  }
}

/// Use case for creating a group conversation.
class CreateGroupConversation {
  CreateGroupConversation(this._repository);
  final ChatRepository _repository;

  /// Executes the use case.
  ///
  /// [name] - Name of the group.
  /// [participantIds] - List of participant user IDs.
  /// [description] - Optional group description.
  /// [imageUrl] - Optional group avatar URL.
  Future<ApiResult<Conversation>> call({
    required String name,
    required List<String> participantIds,
    String? description,
    String? imageUrl,
  }) {
    return _repository.createGroupConversation(
      name: name,
      participantIds: participantIds,
      description: description,
      imageUrl: imageUrl,
    );
  }
}
