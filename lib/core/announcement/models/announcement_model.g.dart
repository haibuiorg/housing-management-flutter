// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnouncementModel _$AnnouncementModelFromJson(Map<String, dynamic> json) =>
    AnnouncementModel(
      json['id'] as String?,
      json['title'] as String?,
      json['subtitle'] as String?,
      json['body'] as String?,
      json['created_on'] as int?,
      json['created_by'] as String?,
      json['updated_by'] as String?,
      json['updated_on'] as int?,
      json['display_name'] as String?,
      json['is_deleted'] as bool?,
    );

Map<String, dynamic> _$AnnouncementModelToJson(AnnouncementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'body': instance.body,
      'created_on': instance.created_on,
      'created_by': instance.created_by,
      'updated_by': instance.updated_by,
      'updated_on': instance.updated_on,
      'display_name': instance.display_name,
      'is_deleted': instance.is_deleted,
    };
