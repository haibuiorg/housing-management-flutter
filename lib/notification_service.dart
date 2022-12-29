import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:priorli/presentation/events/event_screen.dart';

import 'core/event/entities/event.dart';

void showLocalFlutterNotification(RemoteMessage message) {
  debugPrint(message.data.toString());
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

Future<void> handleEventNotification(Event event) async {
  cancelEventNotification(event);
  event.reminders?.forEach(
    (element) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: event.id.hashCode + element,
            channelKey: 'event',
            title: 'Event: ${event.name}',
            body: 'Description: ${event.description}',
            wakeUpScreen: true,
            payload: {'app_route_location': '/$eventScreenPath/${event.id}'},
            autoDismissible: true,
          ),
          schedule: NotificationCalendar.fromDate(
              date: DateTime.fromMillisecondsSinceEpoch(
                  event.startTime - element)));
    },
  );
}

Future<void> cancelEventNotification(Event event) async {
  event.reminders?.forEach(
    (element) {
      AwesomeNotifications().cancelSchedule(event.id.hashCode + element);
    },
  );
}
