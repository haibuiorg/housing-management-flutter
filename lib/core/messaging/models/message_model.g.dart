// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      created_on: json['created_on'] as int?,
      id: json['id'] as String?,
      message: json['message'] as String?,
      sender_id: json['sender_id'] as String?,
      sender_name: json['sender_name'] as String?,
      updated_on: json['updated_on'] as int?,
      seen_by:
          (json['seen_by'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'created_on': instance.created_on,
      'id': instance.id,
      'message': instance.message,
      'sender_id': instance.sender_id,
      'sender_name': instance.sender_name,
      'updated_on': instance.updated_on,
      'seen_by': instance.seen_by,
    };
