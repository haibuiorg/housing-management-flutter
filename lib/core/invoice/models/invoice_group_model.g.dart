// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceGroupModel _$InvoiceGroupModelFromJson(Map<String, dynamic> json) =>
    InvoiceGroupModel(
      id: json['id'] as String,
      invoice_name: json['invoice_name'] as String,
      payment_date: json['payment_date'] as int,
      is_deleted: json['is_deleted'] as bool,
      created_on: json['created_on'] as int,
      company_id: json['company_id'] as String,
      number_of_invoices: json['number_of_invoices'] as int,
    );

Map<String, dynamic> _$InvoiceGroupModelToJson(InvoiceGroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoice_name': instance.invoice_name,
      'payment_date': instance.payment_date,
      'is_deleted': instance.is_deleted,
      'created_on': instance.created_on,
      'company_id': instance.company_id,
      'number_of_invoices': instance.number_of_invoices,
    };
