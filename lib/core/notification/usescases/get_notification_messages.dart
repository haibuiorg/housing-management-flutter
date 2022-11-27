import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/notification/entities/notification_message.dart';
import 'package:priorli/core/notification/repos/notification_message_repository.dart';

class GetNotificationMessages
    extends UseCase<List<NotificationMessage>, GetNotificationMessagesParams> {
  final NotificationMessageRepository notificationMessageRepository;

  GetNotificationMessages({required this.notificationMessageRepository});
  @override
  Future<Result<List<NotificationMessage>>> call(
      GetNotificationMessagesParams params) {
    return notificationMessageRepository.getNotificationMessages(
        lastMessageTime: params.lastMessageTime, total: params.total);
  }
}

class GetNotificationMessagesParams extends Equatable {
  final int lastMessageTime;
  final int total;

  const GetNotificationMessagesParams(
      {required this.lastMessageTime, required this.total});

  @override
  List<Object?> get props => [lastMessageTime, total];
}
