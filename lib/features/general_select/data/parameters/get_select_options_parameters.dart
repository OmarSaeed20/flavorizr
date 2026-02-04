class GetSelectOptionsParameters {
  final String type;
  final String? search;
  final int? limit;

  const GetSelectOptionsParameters({
    required this.type,
    this.search,
    this.limit,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (search != null) 'search': search,
      if (limit != null) 'limit': limit,
    };
  }
}