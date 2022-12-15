// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryModel _$CountryModelFromJson(Map<String, dynamic> json) => CountryModel(
      country_code: json['country_code'] as String,
      support_languages: (json['support_languages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      id: json['id'] as String,
      support_phone_number: json['support_phone_number'] as String,
      currency_code: json['currency_code'] as String,
    );

Map<String, dynamic> _$CountryModelToJson(CountryModel instance) =>
    <String, dynamic>{
      'country_code': instance.country_code,
      'id': instance.id,
      'currency_code': instance.currency_code,
      'support_languages': instance.support_languages,
      'support_phone_number': instance.support_phone_number,
    };
