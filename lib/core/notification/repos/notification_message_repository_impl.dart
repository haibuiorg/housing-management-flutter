import 'package:priorli/core/notification/data/notification_message_data_source.dart';
import 'package:priorli/core/notification/entities/notification_message.dart';

import 'package:priorli/core/notification/entities/notification_channel.dart';

import 'package:priorli/core/base/result.dart';

import '../../base/exceptions.dart';
import '../../base/failure.dart';
import 'notification_message_repository.dart';

class NotificationMessageRepositoryImpl
    implements NotificationMessageRepository {
  final NotificationMessageDataSource notificationMessageDataSource;

  NotificationMessageRepositoryImpl(
      {required this.notificationMessageDataSource});

  @override
  Future<Result<NotificationChannel>> createNotificationChannel(
      {required String housingCompanyId,
      required String channelName,
      required String channelDesccription}) async {
    try {
      final notificationChannelModel =
          await notificationMessageDataSource.createNotificationChannel(
              housingCompanyId: housingCompanyId,
              channelName: channelName,
              channelDesccription: channelDesccription);
      return ResultSuccess(
          NotificationChannel.modelToEntity(notificationChannelModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<NotificationChannel>>> deleteNotificationChannel(
      {required String housingCompanyId, required String channelKey}) async {
    try {
      final notificationChannelModelList =
          await notificationMessageDataSource.deleteNotificationChannel(
        housingCompanyId: housingCompanyId,
        channelKey: channelKey,
      );
      return ResultSuccess(notificationChannelModelList
          .map((e) => NotificationChannel.modelToEntity(e))
          .toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<NotificationChannel>>> getNotificationChannels(
      {required String housingCompanyId,
      required String currentNotificationToken}) async {
    try {
      final notificationChannelModelList =
          await notificationMessageDataSource.getNotificationChannels(
        housingCompanyId: housingCompanyId,
        currentNotificationToken: currentNotificationToken,
      );
      return ResultSuccess(notificationChannelModelList
          .map((e) => NotificationChannel.modelToEntity(e))
          .toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<NotificationMessage>>> getNotificationMessages(
      {required int lastMessageTime, required int total}) async {
    try {
      final notificationMessagelModelList =
          await notificationMessageDataSource.getNotificationMessages(
        lastMessageTime: lastMessageTime,
        total: total,
      );
      return ResultSuccess(notificationMessagelModelList
          .map((e) => NotificationMessage.modelToEntity(e))
          .toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<bool>> setNotificationMessageSeen(
      {required int notificationMessageId}) async {
    try {
      final result =
          await notificationMessageDataSource.setNotificationMessageSeen(
              notificationMessageId: notificationMessageId);
      return ResultSuccess(result);
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<bool>> subscribeNotification(
      {required List<String> subscribedChannelKeys,
      required List<String> unsubscribedChannelKeys,
      required String notificationToken}) async {
    try {
      final result = await notificationMessageDataSource.subscribeNotification(
          subscribedChannelKeys: subscribedChannelKeys,
          unsubscribedChannelKeys: unsubscribedChannelKeys,
          notificationToken: notificationToken);
      return ResultSuccess(result);
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}
