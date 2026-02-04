import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/home/domain/repositories/home_repository.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';

class GetNotificationCountUseCase implements UseCase<int, NoParams> {
  GetNotificationCountUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<ApiResult<int>> call(NoParams params) {
    return _repository.getNotificationCount();
  }
}