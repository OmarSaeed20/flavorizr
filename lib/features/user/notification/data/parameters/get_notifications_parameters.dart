class GetNotificationsParameters {
  final int page;
  final int limit;
  final bool? onlyUnread;

  const GetNotificationsParameters({
    required this.page,
    required this.limit,
    this.onlyUnread,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      if (onlyUnread != null) 'only_unread': onlyUnread,
    };
  }
}
