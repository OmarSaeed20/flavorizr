import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/notification/domain/repositories/notification_repository.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';

class MarkAsReadUseCase implements UseCase<void, int> {
  MarkAsReadUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<ApiResult<void>> call(int notificationId) {
    return _repository.markAsRead(notificationId);
  }
}