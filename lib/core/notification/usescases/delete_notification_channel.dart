import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/notification/repos/notification_message_repository.dart';

import '../entities/notification_channel.dart';

class DeleteNotificationChannel extends UseCase<List<NotificationChannel>,
    DeleteNotificationChannelParams> {
  final NotificationMessageRepository notificationMessageRepository;

  DeleteNotificationChannel({required this.notificationMessageRepository});
  @override
  Future<Result<List<NotificationChannel>>> call(
      DeleteNotificationChannelParams params) {
    return notificationMessageRepository.deleteNotificationChannel(
        housingCompanyId: params.housingCompanyId,
        channelKey: params.channelKey);
  }
}

class DeleteNotificationChannelParams extends Equatable {
  final String housingCompanyId;
  final String channelKey;

  const DeleteNotificationChannelParams({
    required this.housingCompanyId,
    required this.channelKey,
  });

  @override
  List<Object?> get props => [housingCompanyId, channelKey];
}
