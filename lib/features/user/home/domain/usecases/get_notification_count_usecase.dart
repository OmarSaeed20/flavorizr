import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/home/domain/repositories/home_repository.dart';
import 'package:fast_golden_taxi/shared/domain/usecases/usecase.dart';

class GetNotificationCountUseCase implements UseCase<int, NoParams> {
  GetNotificationCountUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<ApiResult<int>> call(NoParams params) {
    return _repository.getNotificationCount();
  }
}
