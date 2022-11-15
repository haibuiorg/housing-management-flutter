// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_bill_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaterBillModel _$WaterBillModelFromJson(Map<String, dynamic> json) =>
    WaterBillModel(
      id: json['id'] as String,
      period: json['period'] as int,
      year: json['year'] as int,
      url: json['url'] as String,
      createdOn: json['created_on'] as int,
    );

Map<String, dynamic> _$WaterBillModelToJson(WaterBillModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'period': instance.period,
      'year': instance.year,
      'url': instance.url,
      'created_on': instance.createdOn,
    };
