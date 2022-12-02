import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/notification/entities/notification_message.dart';
import 'package:priorli/core/notification/usescases/get_notification_messages.dart';

import '../../core/base/result.dart';
import 'notification_center_state.dart';

class NotificationCenterCubit extends Cubit<NotificationCenterState> {
  final GetNotificationMessages _getNotificationMessages;
  NotificationCenterCubit(this._getNotificationMessages)
      : super(const NotificationCenterState()) {
    init();
  }

  Future<void> init() async {
    final messageResult = await _getNotificationMessages(
      GetNotificationMessagesParams(
          lastMessageTime: DateTime.now().millisecondsSinceEpoch,
          total: state.total ?? 10),
    );

    if (messageResult is ResultSuccess<List<NotificationMessage>>) {
      emit(state.copyWith(
          notificationMessageList: messageResult.data,
          total: messageResult.data.length));
    }
  }

  Future<void> loadMore() async {
    final messageResult = await _getNotificationMessages(
      GetNotificationMessagesParams(
          lastMessageTime: state.notificationMessageList?.last.createdOn ??
              DateTime.now().millisecondsSinceEpoch,
          total: state.total ?? 10),
    );

    if (messageResult is ResultSuccess<List<NotificationMessage>>) {
      final List<NotificationMessage> newList =
          List.from(state.notificationMessageList ?? []);
      newList.addAll(messageResult.data);
      emit(state.copyWith(
        notificationMessageList: newList,
      ));
    }
  }
}
