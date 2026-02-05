/* import 'package:flavorizr/core/network/api/models/api_chat.dart';
import 'package:flavorizr/core/network/api/parameters/chat_parameters.dart';
import 'package:flavorizr/core/network/api/repositories/chat_repository.dart';
import 'package:flavorizr/core/network/api_response.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';

/// Chat Service
/// Business logic layer for chat operations
class ChatService {
  final ChatRepository _repository;

  ChatService({required ChatRepository repository}) : _repository = repository;

  /// Get chat messages by order
  /// Returns NetworkResult with List<ApiChatMessage> on success
  Future<ApiResult<ApiResponse<List<ApiChatMessage>>>> getChatByOrder({
    required int orderId,
    int page = 1,
    int pageSize = 20,
  }) async {
    final parameters = GetChatByOrderParameters.builder()
        .withOrderId(orderId)
        .withPage(page)
        .withPageSize(pageSize)
        .build();

    return _repository.getChatByOrder(parameters);
  }

  /// Save a message
  /// Returns NetworkResult with ApiChatMessage on success
  Future<ApiResult<ApiResponse<ApiChatMessage>>> saveMessage({
    required int orderId,
    required int driverId,
    required String message,
  }) async {
    final parameters = SaveMessageParameters.builder()
        .withOrderId(orderId)
        .withDriverId(driverId)
        .withMessage(message)
        .build();

    return _repository.saveMessage(parameters);
  }
}
 */
