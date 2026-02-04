import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/notification/domain/repositories/notification_repository.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';

class GetNotificationCountUseCase implements UseCase<int, NoParams> {
  GetNotificationCountUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<ApiResult<int>> call(NoParams params) {
    return _repository.getNotificationCount();
  }
}