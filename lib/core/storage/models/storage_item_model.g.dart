// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StorageItemModel _$StorageItemModelFromJson(Map<String, dynamic> json) =>
    StorageItemModel(
      id: json['id'] as String?,
      storage_link: json['storage_link'] as String,
      presigned_url: json['presigned_url'] as String?,
      expired_on: json['expired_on'] as int?,
      created_on: json['created_on'] as int?,
      is_deleted: json['is_deleted'] as bool?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      uploaded_by: json['uploaded_by'] as String?,
    );

Map<String, dynamic> _$StorageItemModelToJson(StorageItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storage_link': instance.storage_link,
      'presigned_url': instance.presigned_url,
      'expired_on': instance.expired_on,
      'created_on': instance.created_on,
      'is_deleted': instance.is_deleted,
      'uploaded_by': instance.uploaded_by,
      'type': instance.type,
      'name': instance.name,
    };
