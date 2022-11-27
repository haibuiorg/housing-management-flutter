import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './service_locator.dart' as di;
import 'app.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showLocalFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Handling a background message ${message.messageId}');
}

Future<void> setupFlutterNotifications() async {
  AwesomeNotifications().initialize(
      // TODO redo this
      // set the icon to null if you want to use the default app icon
      // 'resource://drawable/notification_icon',
      null,
      [
        NotificationChannel(
            channelKey: 'default',
            channelName: 'default',
            channelDescription: 'Default',
            importance: NotificationImportance.High)
      ]);
}

void showLocalFlutterNotification(RemoteMessage message) {
  debugPrint(message.data.toString());
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await di.init();
  await setupFlutterNotifications();

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    sound: true,
  );
  if (!kIsWeb && !Platform.isIOS) {
    FirebaseMessaging.onMessage.listen(showLocalFlutterNotification);
  }
  runApp(const App());
}
