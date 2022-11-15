// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_price_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaterPriceModel _$WaterPriceModelFromJson(Map<String, dynamic> json) =>
    WaterPriceModel(
      basicFee: (json['basic_fee'] as num).toDouble(),
      id: json['id'] as String,
      isActive: json['is_active'] as bool,
      pricePerCube: (json['price_per_cube'] as num).toDouble(),
      updatedOn: json['updated_on'] as int,
    );

Map<String, dynamic> _$WaterPriceModelToJson(WaterPriceModel instance) =>
    <String, dynamic>{
      'basic_fee': instance.basicFee,
      'id': instance.id,
      'is_active': instance.isActive,
      'price_per_cube': instance.pricePerCube,
      'updated_on': instance.updatedOn,
    };
