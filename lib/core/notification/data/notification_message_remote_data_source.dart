import 'package:dio/dio.dart';

import '../../base/exceptions.dart';
import '../models/notification_channel_model.dart';
import '../models/notification_message_model.dart';
import 'notification_message_data_source.dart';

class NotificationMessageRemoteDataSource
    implements NotificationMessageDataSource {
  final Dio client;
  final String _pathMessage = '/notification_messsage';
  final String _pathChannel = '/notification_channels';

  NotificationMessageRemoteDataSource({required this.client});

  @override
  Future<NotificationChannelModel> createNotificationChannel(
      {required String housingCompanyId,
      required String channelName,
      required String channelDesccription}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "channel_name": channelName,
        "channel_description": channelDesccription,
      };
      final result = await client.post(_pathChannel, data: data);
      return NotificationChannelModel.fromJson(
          result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<NotificationChannelModel>> deleteNotificationChannel(
      {required String housingCompanyId, required String channelKey}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "channel_key": channelKey,
      };
      final result = await client.delete(_pathChannel, queryParameters: data);
      return (result.data as List<dynamic>)
          .map((json) => NotificationChannelModel.fromJson(json))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<NotificationChannelModel>> getNotificationChannels(
      {required String housingCompanyId,
      required String currentNotificationToken}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "current_notification_token": currentNotificationToken,
      };
      final result = await client.get(_pathChannel, queryParameters: data);
      return (result.data as List<dynamic>)
          .map((json) => NotificationChannelModel.fromJson(json))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<NotificationMessageModel>> getNotificationMessages(
      {required int lastMessageTime, required int total}) async {
    try {
      final Map<String, dynamic> data = {
        "last_message_time": lastMessageTime,
        "total": total,
      };
      final result = await client.get(_pathMessage, queryParameters: data);
      return (result.data as List<dynamic>)
          .map((json) => NotificationMessageModel.fromJson(json))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<bool> setNotificationMessageSeen(
      {required int notificationMessageId}) async {
    try {
      final Map<String, dynamic> data = {
        "notification_messgae_id": notificationMessageId,
      };
      final result = await client.patch(_pathMessage, data: data);
      return (result.data as Map<String, bool>)[result] ?? false;
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<bool> subscribeNotification(
      {required List<String> subscribedChannelKeys,
      required List<String> unsubscribedChannelKeys,
      required String notificationToken}) async {
    try {
      final Map<String, dynamic> data = {
        "subscribed_channel_keys": subscribedChannelKeys,
        "unsubscribed_channel_keys": unsubscribedChannelKeys,
        "notification_token": notificationToken
      };
      final result = await client.post('$_pathMessage/subscribe', data: data);
      return (result.data as Map<String, bool>)[result] ?? false;
    } catch (error) {
      throw ServerException(error: error);
    }
  }
}
