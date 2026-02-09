import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/home/domain/entities/home_data.dart';
import 'package:fast_golden_taxi/features/user/home/domain/repositories/home_repository.dart';
import 'package:fast_golden_taxi/shared/domain/usecases/usecase.dart';

class GetHomeDataUseCase implements UseCase<HomeData, NoParams> {
  GetHomeDataUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<ApiResult<HomeData>> call(NoParams params) {
    return _repository.getHomeData();
  }
}
