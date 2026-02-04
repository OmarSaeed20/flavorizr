import 'package:flavorizr/core/network/base/repo/base_repository.dart';
import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/notification/data/datasources/notification_remote_datasource.dart';
import 'package:flavorizr/features/notification/data/parameters/get_notifications_parameters.dart';
import 'package:flavorizr/features/notification/domain/entities/notification.dart';
import 'package:flavorizr/features/notification/domain/repositories/notification_repository.dart';

/// Implementation of [NotificationRepository].
class NotificationRepositoryImpl extends BaseRepository implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl({
    required NotificationRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;
  final NetworkInfo _networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  @override
  Future<ApiResult<List<Notification>>> getNotifications(GetNotificationsParameters params) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.getNotifications(params),
    );
    return result.map(
      success: (data) => ApiResult.success(data.data.map((e) => e.toEntity()).toList()),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }

  @override
  Future<ApiResult<int>> getNotificationCount() async {
    return executeRemoteRequest(request: _remoteDataSource.getNotificationCount);
  }

  @override
  Future<ApiResult<void>> markAsRead(int notificationId) async {
    return executeRemoteRequest(request: () => _remoteDataSource.markAsRead(notificationId));
  }

  @override
  Future<ApiResult<void>> markAllAsRead() async {
    return executeRemoteRequest(request: _remoteDataSource.markAllAsRead);
  }
}
