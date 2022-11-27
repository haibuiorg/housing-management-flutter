import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/notification/repos/notification_message_repository.dart';

class SetNotificationMessageSeen
    extends UseCase<bool, SetNotificationMessageSeenParams> {
  final NotificationMessageRepository notificationMessageRepository;

  SetNotificationMessageSeen({required this.notificationMessageRepository});
  @override
  Future<Result<bool>> call(SetNotificationMessageSeenParams params) {
    return notificationMessageRepository.setNotificationMessageSeen(
        notificationMessageId: params.notificationMessageId);
  }
}

class SetNotificationMessageSeenParams extends Equatable {
  final int notificationMessageId;

  const SetNotificationMessageSeenParams({
    required this.notificationMessageId,
  });

  @override
  List<Object?> get props => [notificationMessageId];
}
