// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
      street_address_1: json['street_address_1'] as String?,
      street_address_2: json['street_address_2'] as String?,
      postal_code: json['postal_code'] as String?,
      id: json['id'] as String,
      owner_type: json['owner_type'] as String,
      owner_id: json['owner_id'] as String,
      address_type: json['address_type'] as String?,
      city: json['city'] as String?,
      country_code: json['country_code'] as String?,
    );

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'street_address_1': instance.street_address_1,
      'street_address_2': instance.street_address_2,
      'postal_code': instance.postal_code,
      'id': instance.id,
      'country_code': instance.country_code,
      'city': instance.city,
      'owner_type': instance.owner_type,
      'owner_id': instance.owner_id,
      'address_type': instance.address_type,
    };
