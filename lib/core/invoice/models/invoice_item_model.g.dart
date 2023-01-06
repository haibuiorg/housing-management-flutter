// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceItemModel _$InvoiceItemModelFromJson(Map<String, dynamic> json) =>
    InvoiceItemModel(
      name: json['name'] as String,
      description: json['description'] as String,
      unit_cost: (json['unit_cost'] as num).toDouble(),
      quantity: (json['quantity'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      tax_percentage: (json['tax_percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$InvoiceItemModelToJson(InvoiceItemModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'unit_cost': instance.unit_cost,
      'quantity': instance.quantity,
      'total': instance.total,
      'tax_percentage': instance.tax_percentage,
    };
