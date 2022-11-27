
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_channel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationChannelModel _$NotificationChannelModelFromJson(
        Map<String, dynamic> json) =>
    NotificationChannelModel(
      json['channel_key'] as String?,
      json['channel_name'] as String?,
      json['channel_description'] as String?,
      json['housing_company_id'] as String?,
      json['is_active'] as bool?,
    );

Map<String, dynamic> _$NotificationChannelModelToJson(
        NotificationChannelModel instance) =>
    <String, dynamic>{
      'channel_key': instance.channel_key,
      'channel_name': instance.channel_name,
      'channel_description': instance.channel_description,
      'housing_company_id': instance.housing_company_id,
      'is_active': instance.is_active,
    };
