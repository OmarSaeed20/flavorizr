/// Parameters for getting driver reviews.
class GetDriverReviewsParameters {
  const GetDriverReviewsParameters({
    this.driverId,
    this.tripId,
    this.rating,
    this.page = 1,
    this.limit = 20,
    this.sortBy = 'created_at',
    this.sortOrder = 'desc',
  });

  final String? driverId;
  final String? tripId;
  final int? rating;
  final int page;
  final int limit;
  final String sortBy;
  final String sortOrder;

  Map<String, dynamic> toJson() {
    return {
      if (driverId != null) 'driver_id': driverId,
      if (tripId != null) 'trip_id': tripId,
      if (rating != null) 'rating': rating,
      'page': page,
      'limit': limit,
      'sort_by': sortBy,
      'sort_order': sortOrder,
    };
  }

  GetDriverReviewsParameters copyWith({
    String? driverId,
    String? tripId,
    int? rating,
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
  }) {
    return GetDriverReviewsParameters(
      driverId: driverId ?? this.driverId,
      tripId: tripId ?? this.tripId,
      rating: rating ?? this.rating,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
