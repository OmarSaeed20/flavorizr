import 'package:fast_golden_taxi/core/network/api/models/api_chat.dart';
import 'package:fast_golden_taxi/core/network/api/parameters/chat_parameters.dart';
import 'package:fast_golden_taxi/core/network/api_response.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';

/// Chat Repository Interface
/// Defines the contract for chat data operations
abstract class ChatRepository {
  /// Get chat messages by order
  /// Returns NetworkResult with List<ApiChatMessage> on success
  Future<ApiResult<ApiResponse<List<ApiChatMessage>>>> getChatByOrder(
    GetChatByOrderParameters parameters,
  );

  /// Save a message
  /// Returns NetworkResult with ApiChatMessage on success
  Future<ApiResult<ApiResponse<ApiChatMessage>>> saveMessage(SaveMessageParameters parameters);
}
