import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/notification/domain/repositories/notification_repository.dart';
import 'package:fast_golden_taxi/shared/domain/usecases/usecase.dart';

class MarkAllAsReadUseCase implements UseCase<void, NoParams> {
  MarkAllAsReadUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<ApiResult<void>> call(NoParams params) {
    return _repository.markAllAsRead();
  }
}
