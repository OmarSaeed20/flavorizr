import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/home/data/parameters/get_available_trips_parameters.dart';
import 'package:fast_golden_taxi/features/user/home/domain/entities/available_trip.dart';
import 'package:fast_golden_taxi/features/user/home/domain/repositories/home_repository.dart';
import 'package:fast_golden_taxi/shared/domain/usecases/usecase.dart';

class GetAvailableTripsUseCase
    implements UseCase<List<AvailableTrip>, GetAvailableTripsParameters> {
  GetAvailableTripsUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<ApiResult<List<AvailableTrip>>> call(GetAvailableTripsParameters params) {
    return _repository.getAvailableTrips(params);
  }
}
