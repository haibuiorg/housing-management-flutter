// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$EventTypeEnumMap, json['type']),
      reminders:
          (json['reminders'] as List<dynamic>?)?.map((e) => e as int).toList(),
      repeat_until: json['repeat_until'] as int?,
      company_id: json['company_id'] as String?,
      apartment_id: json['apartment_id'] as String?,
      start_time: json['start_time'] as int,
      end_time: json['end_time'] as int,
      repeat: $enumDecodeNullable(_$RepeatEnumMap, json['repeat']),
      invitees:
          (json['invitees'] as List<dynamic>).map((e) => e as String).toList(),
      accepted: (json['accepted'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      declined: (json['declined'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      join_links: (json['join_links'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      created_on: json['created_on'] as int,
      created_by: json['created_by'] as String,
      created_by_name: json['created_by_name'] as String,
      updated_by: json['updated_by'] as String?,
      updated_by_name: json['updated_by_name'] as String?,
      updated_on: json['updated_on'] as int?,
      is_deleted: json['is_deleted'] as bool?,
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$EventTypeEnumMap[instance.type]!,
      'company_id': instance.company_id,
      'apartment_id': instance.apartment_id,
      'start_time': instance.start_time,
      'end_time': instance.end_time,
      'repeat': _$RepeatEnumMap[instance.repeat],
      'repeat_until': instance.repeat_until,
      'reminders': instance.reminders,
      'invitees': instance.invitees,
      'accepted': instance.accepted,
      'declined': instance.declined,
      'join_links': instance.join_links,
      'created_on': instance.created_on,
      'created_by': instance.created_by,
      'created_by_name': instance.created_by_name,
      'updated_by': instance.updated_by,
      'updated_by_name': instance.updated_by_name,
      'updated_on': instance.updated_on,
      'is_deleted': instance.is_deleted,
    };

const _$EventTypeEnumMap = {
  EventType.generic: 'generic',
  EventType.companyInternal: 'company_internal',
  EventType.company: 'company',
  EventType.apartment: 'apartment',
  EventType.personal: 'personal',
};

const _$RepeatEnumMap = {
  Repeat.daily: 'daily',
  Repeat.weekday: 'weekday',
  Repeat.weekly: 'weekly',
  Repeat.monthly: 'monthly',
  Repeat.yearly: 'yearly',
};
