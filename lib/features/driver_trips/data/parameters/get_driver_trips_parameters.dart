/// Parameters for getting driver trips
class GetDriverTripsParameters {
  final int page;
  final int limit;
  final String? status;
  final String? startDate;
  final String? endDate;

  GetDriverTripsParameters({
    this.page = 1,
    this.limit = 10,
    this.status,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      if (status != null) 'status': status,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
    };
  }
}