// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'housing_company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HousingCompanyModel _$HousingCompanyModelFromJson(Map<String, dynamic> json) =>
    HousingCompanyModel(
      json['id'] as String,
      json['street_address_1'] as String,
      json['street_address_2'] as String,
      json['postal_code'] as String,
      json['city'] as String,
      json['country_code'] as String,
      (json['lat'] as num).toDouble(),
      (json['lng'] as num).toDouble(),
      json['name'] as String,
    );

Map<String, dynamic> _$HousingCompanyModelToJson(
        HousingCompanyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'street_address_1': instance.streetAddress1,
      'street_address_2': instance.streetAddress2,
      'postal_code': instance.postalCode,
      'city': instance.city,
      'country_code': instance.countryCode,
      'lat': instance.lat,
      'lng': instance.lng,
      'name': instance.name,
    };
