// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationMessageModel _$NotificationMessageModelFromJson(
        Map<String, dynamic> json) =>
    NotificationMessageModel(
      json['id'] as String?,
      json['channel_key'] as String?,
      json['title'] as String?,
      json['body'] as String?,
      json['auto_dismissible'] as bool?,
      json['color'] as String?,
      json['wake_up_screen'] as bool?,
      json['app_route_location'] as String?,
      json['created_by'] as String?,
      json['display_name'] as String?,
      json['created_on'] as int?,
      json['seen'] as bool?,
    );

Map<String, dynamic> _$NotificationMessageModelToJson(
        NotificationMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'channel_key': instance.channel_key,
      'title': instance.title,
      'body': instance.body,
      'auto_dismissible': instance.auto_dismissible,
      'color': instance.color,
      'wake_up_screen': instance.wake_up_screen,
      'app_route_location': instance.app_route_location,
      'created_by': instance.created_by,
      'display_name': instance.display_name,
      'created_on': instance.created_on,
      'seen': instance.seen,
    };
