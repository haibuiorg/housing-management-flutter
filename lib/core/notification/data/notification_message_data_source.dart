import 'package:priorli/core/notification/models/notification_channel_model.dart';
import 'package:priorli/core/notification/models/notification_message_model.dart';

abstract class NotificationMessageDataSource {
  Future<NotificationChannelModel> createNotificationChannel(
      {required String housingCompanyId,
      required String channelName,
      required String channelDesccription});
  Future<List<NotificationChannelModel>> deleteNotificationChannel({
    required String housingCompanyId,
    required String channelKey,
  });
  Future<List<NotificationChannelModel>> getNotificationChannels({
    required String housingCompanyId,
    required String currentNotificationToken,
  });
  Future<List<NotificationMessageModel>> getNotificationMessages(
      {required int lastMessageTime, required int total});
  Future<bool> setNotificationMessageSeen({required int notificationMessageId});
  Future<bool> subscribeNotification(
      {required List<String> subscribedChannelKeys,
      required List<String> unsubscribedChannelKeys,
      required String notificationToken});
}
