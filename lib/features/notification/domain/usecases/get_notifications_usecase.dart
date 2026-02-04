import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/notification/domain/entities/notification.dart';
import 'package:flavorizr/features/notification/domain/repositories/notification_repository.dart';
import 'package:flavorizr/features/notification/data/parameters/get_notifications_parameters.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';

class GetNotificationsUseCase implements UseCase<List<Notification>, GetNotificationsParameters> {
  GetNotificationsUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<ApiResult<List<Notification>>> call(GetNotificationsParameters params) {
    return _repository.getNotifications(params);
  }
}