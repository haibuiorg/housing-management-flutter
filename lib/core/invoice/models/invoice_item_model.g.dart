// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceItemModel _$InvoiceItemModelFromJson(Map<String, dynamic> json) =>
    InvoiceItemModel(
      quantity: (json['quantity'] as num).toDouble(),
      payment_product_item: PaymentProductItemModel.fromJson(
          json['payment_product_item'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InvoiceItemModelToJson(InvoiceItemModel instance) =>
    <String, dynamic>{
      'payment_product_item': instance.payment_product_item,
      'quantity': instance.quantity,
    };
