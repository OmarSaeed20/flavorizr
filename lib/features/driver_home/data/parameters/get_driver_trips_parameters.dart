/// Parameters for getting driver trips
class GetDriverTripsParameters {
  final int page;
  final int limit;
  final String? status;

  GetDriverTripsParameters({
    this.page = 1,
    this.limit = 10,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      if (status != null) 'status': status,
    };
  }
}