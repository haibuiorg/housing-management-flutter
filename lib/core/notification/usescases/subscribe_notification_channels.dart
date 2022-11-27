import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/notification/repos/notification_message_repository.dart';

class SubscribeNotificationChannels
    extends UseCase<bool, SubscribeNotificationChannelParams> {
  final NotificationMessageRepository notificationMessageRepository;

  SubscribeNotificationChannels({required this.notificationMessageRepository});
  @override
  Future<Result<bool>> call(SubscribeNotificationChannelParams params) {
    return notificationMessageRepository.subscribeNotification(
        subscribedChannelKeys: params.subscribedChannelKeys,
        unsubscribedChannelKeys: params.unsubscribedChannelKeys,
        notificationToken: params.notificationToken);
  }
}

class SubscribeNotificationChannelParams extends Equatable {
  final List<String> subscribedChannelKeys;
  final List<String> unsubscribedChannelKeys;
  final String notificationToken;

  const SubscribeNotificationChannelParams(
      {required this.subscribedChannelKeys,
      required this.unsubscribedChannelKeys,
      required this.notificationToken});

  @override
  List<Object?> get props =>
      [subscribedChannelKeys, unsubscribedChannelKeys, notificationToken];
}
