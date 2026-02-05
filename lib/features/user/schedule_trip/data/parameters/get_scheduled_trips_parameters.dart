class GetScheduledTripsParameters {
  final int page;
  final int limit;
  final String? status;

  const GetScheduledTripsParameters({
    this.page = 1,
    this.limit = 20,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {'page': page, 'limit': limit, if (status != null) 'status': status};
  }
}
