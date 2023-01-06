// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceModel _$InvoiceModelFromJson(Map<String, dynamic> json) => InvoiceModel(
      id: json['id'] as String,
      invoice_name: json['invoice_name'] as String?,
      subtotal: (json['subtotal'] as num).toDouble(),
      group_id: json['group_id'] as String,
      paid: (json['paid'] as num).toDouble(),
      reference_number: json['reference_number'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => InvoiceItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      receiver: json['receiver'] as String,
      storage_link: json['storage_link'] as String?,
      payment_date: json['payment_date'] as int,
      virtual_barcode: json['virtual_barcode'] as String?,
      invoice_url: json['invoice_url'] as String?,
      invoice_url_expiration: json['invoice_url_expiration'] as int?,
      is_deleted: json['is_deleted'] as bool,
      created_on: json['created_on'] as int,
      company_id: json['company_id'] as String,
      status: $enumDecode(_$InvoiceStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$InvoiceModelToJson(InvoiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'group_id': instance.group_id,
      'invoice_name': instance.invoice_name,
      'subtotal': instance.subtotal,
      'paid': instance.paid,
      'reference_number': instance.reference_number,
      'items': instance.items,
      'receiver': instance.receiver,
      'storage_link': instance.storage_link,
      'payment_date': instance.payment_date,
      'virtual_barcode': instance.virtual_barcode,
      'is_deleted': instance.is_deleted,
      'created_on': instance.created_on,
      'company_id': instance.company_id,
      'status': _$InvoiceStatusEnumMap[instance.status]!,
      'invoice_url': instance.invoice_url,
      'invoice_url_expiration': instance.invoice_url_expiration,
    };

const _$InvoiceStatusEnumMap = {
  InvoiceStatus.paid: 'paid',
  InvoiceStatus.pending: 'pending',
};
