// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LegalDocumentModel _$LegalDocumentModelFromJson(Map<String, dynamic> json) =>
    LegalDocumentModel(
      id: json['id'] as String,
      type: json['type'] as String,
      is_active: json['is_active'] as bool,
      created_on: json['created_on'] as int,
      country_code: json['country_code'] as String,
      country_id: json['country_id'] as String,
      storage_link: json['storage_link'] as String?,
      web_url: json['web_url'] as String,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$LegalDocumentModelToJson(LegalDocumentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'is_active': instance.is_active,
      'created_on': instance.created_on,
      'country_code': instance.country_code,
      'country_id': instance.country_id,
      'storage_link': instance.storage_link,
      'web_url': instance.web_url,
      'url': instance.url,
    };
