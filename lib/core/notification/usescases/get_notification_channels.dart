import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/notification/repos/notification_message_repository.dart';

import '../entities/notification_channel.dart';

class GetNotificationChannel
    extends UseCase<List<NotificationChannel>, GetNotificationChannelParams> {
  final NotificationMessageRepository notificationMessageRepository;

  GetNotificationChannel({required this.notificationMessageRepository});
  @override
  Future<Result<List<NotificationChannel>>> call(
      GetNotificationChannelParams params) {
    return notificationMessageRepository.getNotificationChannels(
        housingCompanyId: params.housingCompanyId,
        currentNotificationToken: params.currentNotificationToken);
  }
}

class GetNotificationChannelParams extends Equatable {
  final String housingCompanyId;
  final String currentNotificationToken;

  const GetNotificationChannelParams(
      {required this.housingCompanyId, required this.currentNotificationToken});

  @override
  List<Object?> get props => [housingCompanyId, currentNotificationToken];
}
