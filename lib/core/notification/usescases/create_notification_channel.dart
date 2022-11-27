import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';

import '../entities/notification_channel.dart';
import '../repos/notification_message_repository.dart';

class CreateNotificationChannel
    extends UseCase<NotificationChannel, CreateNotificationChannelParams> {
  final NotificationMessageRepository notificationMessageRepository;

  CreateNotificationChannel({required this.notificationMessageRepository});
  @override
  Future<Result<NotificationChannel>> call(
      CreateNotificationChannelParams params) {
    return notificationMessageRepository.createNotificationChannel(
        housingCompanyId: params.housingCompanyId,
        channelName: params.channelName,
        channelDesccription: params.channelDesccription);
  }
}

class CreateNotificationChannelParams extends Equatable {
  final String housingCompanyId;
  final String channelName;
  final String channelDesccription;

  const CreateNotificationChannelParams(
      {required this.housingCompanyId,
      required this.channelName,
      required this.channelDesccription});

  @override
  List<Object?> get props =>
      [housingCompanyId, channelName, channelDesccription];
}
