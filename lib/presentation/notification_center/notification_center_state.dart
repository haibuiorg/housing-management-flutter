import 'package:equatable/equatable.dart';
import 'package:priorli/core/notification/entities/notification_message.dart';

class NotificationCenterState extends Equatable {
  final List<NotificationMessage>? notificationMessageList;
  final int? total;

  const NotificationCenterState({this.notificationMessageList, this.total});

  NotificationCenterState copyWith(
          {List<NotificationMessage>? notificationMessageList, int? total}) =>
      NotificationCenterState(
          total: total ?? this.total,
          notificationMessageList:
              notificationMessageList ?? this.notificationMessageList);

  @override
  List<Object?> get props => [notificationMessageList, total];
}
