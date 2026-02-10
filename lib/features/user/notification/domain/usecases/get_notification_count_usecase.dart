import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/notification/domain/repositories/notification_repository.dart';
import 'package:fast_golden_taxi/shared/domain/usecases/usecase.dart';

class GetNotificationCountUseCase implements UseCase<int, NoParams> {
  GetNotificationCountUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<ApiResult<int>> call(NoParams params) {
    return _repository.getNotificationCount();
  }
}
