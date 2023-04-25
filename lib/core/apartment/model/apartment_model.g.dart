// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apartment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApartmentModel _$ApartmentModelFromJson(Map<String, dynamic> json) =>
    ApartmentModel(
      housingCompanyId: json['housing_company_id'] as String,
      id: json['id'] as String,
      building: json['building'] as String,
      isDeleted: json['is_deleted'] as bool?,
      houseCode: json['house_code'] as String?,
      tenants:
          (json['tenants'] as List<dynamic>?)?.map((e) => e as String).toList(),
      owners:
          (json['owners'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ApartmentModelToJson(ApartmentModel instance) =>
    <String, dynamic>{
      'housing_company_id': instance.housingCompanyId,
      'id': instance.id,
      'building': instance.building,
      'house_code': instance.houseCode,
      'tenants': instance.tenants,
      'owners': instance.owners,
      'is_deleted': instance.isDeleted,
    };
