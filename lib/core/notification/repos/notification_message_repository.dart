import 'package:priorli/core/base/result.dart';

import '../entities/notification_channel.dart';
import '../entities/notification_message.dart';

abstract class NotificationMessageRepository {
  Future<Result<NotificationChannel>> createNotificationChannel(
      {required String housingCompanyId,
      required String channelName,
      required String channelDesccription});
  Future<Result<List<NotificationChannel>>> deleteNotificationChannel({
    required String housingCompanyId,
    required String channelKey,
  });
  Future<Result<List<NotificationChannel>>> getNotificationChannels({
    required String housingCompanyId,
    required String currentNotificationToken,
  });
  Future<Result<List<NotificationMessage>>> getNotificationMessages(
      {required int lastMessageTime, required int total});
  Future<Result<bool>> setNotificationMessageSeen(
      {required int notificationMessageId});
  Future<Result<bool>> subscribeNotification(
      {required List<String> subscribedChannelKeys,
      required List<String> unsubscribedChannelKeys,
      required String notificationToken});
}
