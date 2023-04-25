// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) =>
    ConversationModel(
      id: json['id'] as String?,
      channel_id: json['channel_id'] as String?,
      user_ids: (json['user_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      name: json['name'] as String?,
      status: json['status'] as String?,
      is_archived: json['is_archived'] as bool?,
      apartment_id: json['apartment_id'] as String?,
      last_message_not_seen_by:
          (json['last_message_not_seen_by'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$ConversationModelToJson(ConversationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'channel_id': instance.channel_id,
      'user_ids': instance.user_ids,
      'name': instance.name,
      'status': instance.status,
      'type': instance.type,
      'is_archived': instance.is_archived,
      'apartment_id': instance.apartment_id,
      'last_message_not_seen_by': instance.last_message_not_seen_by,
    };
