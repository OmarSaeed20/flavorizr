import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/home/domain/entities/advertisement.dart';
import 'package:fast_golden_taxi/features/user/home/domain/repositories/home_repository.dart';
import 'package:fast_golden_taxi/shared/domain/usecases/usecase.dart';

class GetAdvertisementsUseCase implements UseCase<List<Advertisement>, NoParams> {
  GetAdvertisementsUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<ApiResult<List<Advertisement>>> call(NoParams params) {
    return _repository.getAdvertisements();
  }
}
