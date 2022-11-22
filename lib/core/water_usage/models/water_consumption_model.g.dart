// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_consumption_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaterConsumptionModel _$WaterConsumptionModelFromJson(
        Map<String, dynamic> json) =>
    WaterConsumptionModel(
      id: json['id'] as String?,
      basicFee: (json['basic_fee'] as num?)?.toDouble(),
      period: json['period'] as int?,
      priceId: json['price_id'] as String?,
      pricePerCube: (json['price_per_cube'] as num?)?.toDouble(),
      totalReading: (json['total_reading'] as num?)?.toDouble(),
      year: json['year'] as int?,
      consumptionValues: (json['consumption_values'] as List<dynamic>?)
          ?.map(
              (e) => ConsumptionValueModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WaterConsumptionModelToJson(
        WaterConsumptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'basic_fee': instance.basicFee,
      'period': instance.period,
      'price_id': instance.priceId,
      'price_per_cube': instance.pricePerCube,
      'total_reading': instance.totalReading,
      'year': instance.year,
      'consumption_values': instance.consumptionValues,
    };
