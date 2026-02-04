import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/home/domain/entities/available_trip.dart';
import 'package:flavorizr/features/home/domain/repositories/home_repository.dart';
import 'package:flavorizr/features/home/data/parameters/get_available_trips_parameters.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';

class GetAvailableTripsUseCase implements UseCase<List<AvailableTrip>, GetAvailableTripsParameters> {
  GetAvailableTripsUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<ApiResult<List<AvailableTrip>>> call(GetAvailableTripsParameters params) {
    return _repository.getAvailableTrips(params);
  }
}