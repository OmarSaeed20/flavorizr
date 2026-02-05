import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_chat.freezed.dart';
part 'api_chat.g.dart';

/// API Chat Message model
/// Represents a chat message in the system
@freezed
abstract class ApiChatMessage with _$ApiChatMessage {
  const factory ApiChatMessage({
    /// Message ID
    required int id,

    /// Order ID
    required int orderId,

    /// Driver ID
    required int driverId,

    /// User ID (sender)
    required int userId,

    /// Message content
    required String message,

    /// Whether the message is from the user (true) or driver (false)
    required bool isFromUser,

    /// Message status (e.g., 'sent', 'delivered', 'read')
    String? status,

    /// Created at timestamp
    String? createdAt,

    /// Updated at timestamp
    String? updatedAt,

    /// Driver information (if available)
    ApiChatDriver? driver,

    /// User information (if available)
    ApiChatUser? user,
  }) = _ApiChatMessage;

  factory ApiChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ApiChatMessageFromJson(json);
}

/// API Chat Driver model
/// Represents driver information in a chat message
@freezed
abstract class ApiChatDriver with _$ApiChatDriver {
  const factory ApiChatDriver({
    /// Driver ID
    required int id,

    /// Driver name
    String? name,

    /// Driver phone
    String? phone,

    /// Driver image/avatar URL
    String? image,
  }) = _ApiChatDriver;

  factory ApiChatDriver.fromJson(Map<String, dynamic> json) =>
      _$ApiChatDriverFromJson(json);
}

/// API Chat User model
/// Represents user information in a chat message
@freezed
abstract class ApiChatUser with _$ApiChatUser {
  const factory ApiChatUser({
    /// User ID
    required int id,

    /// User name
    String? name,

    /// User phone
    String? phone,

    /// User image/avatar URL
    String? image,
  }) = _ApiChatUser;

  factory ApiChatUser.fromJson(Map<String, dynamic> json) =>
      _$ApiChatUserFromJson(json);
}
