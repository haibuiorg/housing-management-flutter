import 'package:equatable/equatable.dart';
import 'package:priorli/core/notification/models/notification_channel_model.dart';

class NotificationChannel extends Equatable {
  final String channelKey;
  final String channelName;
  final String channelDescription;
  final String housingCompanyId;
  final bool isActive;

  const NotificationChannel(
      {required this.channelKey,
      required this.channelName,
      required this.channelDescription,
      required this.housingCompanyId,
      required this.isActive});

  factory NotificationChannel.modelToEntity(NotificationChannelModel model) =>
      NotificationChannel(
          channelDescription: model.channel_description ?? '',
          channelKey: model.channel_key ?? '',
          channelName: model.channel_name ?? '',
          housingCompanyId: model.housing_company_id ?? '',
          isActive: model.is_active ?? model.channel_key != null);

  @override
  List<Object?> get props =>
      [channelKey, channelName, channelDescription, housingCompanyId, isActive];
}
