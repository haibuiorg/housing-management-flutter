// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translated_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranslatedMessageModel _$TranslatedMessageModelFromJson(
        Map<String, dynamic> json) =>
    TranslatedMessageModel(
      language_code: json['language_code'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$TranslatedMessageModelToJson(
        TranslatedMessageModel instance) =>
    <String, dynamic>{
      'language_code': instance.language_code,
      'value': instance.value,
    };
