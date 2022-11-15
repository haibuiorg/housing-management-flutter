// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumption_value_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsumptionValueModel _$ConsumptionValueModelFromJson(
        Map<String, dynamic> json) =>
    ConsumptionValueModel(
      apartmentId: json['apartment_id'] as String,
      buiding: json['buiding'] as String,
      consumption: (json['consumption'] as num).toDouble(),
      updatedOn: json['updated_on'] as int,
    );

Map<String, dynamic> _$ConsumptionValueModelToJson(
        ConsumptionValueModel instance) =>
    <String, dynamic>{
      'apartment_id': instance.apartmentId,
      'buiding': instance.buiding,
      'consumption': instance.consumption,
      'updated_on': instance.updatedOn,
    };
