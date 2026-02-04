/// Parameters for getting driver reviews
class GetDriverReviewsParams {
  final String driverId;
  final int page;
  final int limit;
  final int? minRating;
  final int? maxRating;
  final bool? withResponse;
  final bool? pendingResponse;

  GetDriverReviewsParams({
    required this.driverId,
    required this.page,
    required this.limit,
    this.minRating,
    this.maxRating,
    this.withResponse,
    this.pendingResponse,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{'driverId': driverId, 'page': page, 'limit': limit};

    if (minRating != null) {
      params['minRating'] = minRating;
    }

    if (maxRating != null) {
      params['maxRating'] = maxRating;
    }

    if (withResponse != null) {
      params['withResponse'] = withResponse;
    }

    if (pendingResponse != null) {
      params['pendingResponse'] = pendingResponse;
    }

    return params;
  }
}
