import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/notification/domain/repositories/notification_repository.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';

class MarkAllAsReadUseCase implements UseCase<void, NoParams> {
  MarkAllAsReadUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<ApiResult<void>> call(NoParams params) {
    return _repository.markAllAsRead();
  }
}