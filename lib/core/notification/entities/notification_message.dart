import 'package:equatable/equatable.dart';
import 'package:priorli/core/notification/models/notification_message_model.dart';

import '../../utils/constants.dart';

class NotificationMessage extends Equatable {
  final String id;
  final String channelKey;
  final String title;
  final String body;
  final bool autoDismissible;
  final String color;
  final bool wakeUpScreen;
  final String appRouteLocation;
  final String createdBy;
  final String displayName;
  final int createdOn;
  final bool seen;

  const NotificationMessage(
      {required this.id,
      required this.channelKey,
      required this.title,
      required this.body,
      required this.autoDismissible,
      required this.color,
      required this.wakeUpScreen,
      required this.appRouteLocation,
      required this.createdBy,
      required this.displayName,
      required this.createdOn,
      required this.seen});

  factory NotificationMessage.modelToEntity(NotificationMessageModel model) =>
      NotificationMessage(
          appRouteLocation: model.app_route_location ?? '/',
          id: model.id ?? '',
          channelKey: model.channel_key ?? '',
          title: model.title ?? '',
          body: model.body ?? '',
          autoDismissible: model.auto_dismissible ?? true,
          color: model.color ?? appSeedColor,
          wakeUpScreen: model.wake_up_screen ?? true,
          createdBy: model.created_by ?? '',
          createdOn: model.created_on ?? 0,
          seen: model.seen ?? true,
          displayName: model.display_name ?? '');

  @override
  List<Object?> get props => [
        id,
        channelKey,
        title,
        body,
        autoDismissible,
        color,
        wakeUpScreen,
        appRouteLocation,
        createdBy,
        displayName,
        createdOn,
        seen
      ];
}
