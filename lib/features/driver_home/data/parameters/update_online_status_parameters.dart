/// Parameters for updating driver online status
class UpdateOnlineStatusParameters {
  final bool isOnline;

  UpdateOnlineStatusParameters({
    required this.isOnline,
  });

  Map<String, dynamic> toJson() {
    return {
      'isOnline': isOnline,
    };
  }
}