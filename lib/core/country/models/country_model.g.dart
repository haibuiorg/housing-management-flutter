// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryModel _$CountryModelFromJson(Map<String, dynamic> json) => CountryModel(
      country_code: json['country_code'] as String,
      id: json['id'] as String,
      currency_code: json['currency_code'] as String,
    );

Map<String, dynamic> _$CountryModelToJson(CountryModel instance) =>
    <String, dynamic>{
      'country_code': instance.country_code,
      'id': instance.id,
      'currency_code': instance.currency_code,
    };
