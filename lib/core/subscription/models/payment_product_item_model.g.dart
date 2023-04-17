// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_product_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentProductItemModel _$PaymentProductItemModelFromJson(
        Map<String, dynamic> json) =>
    PaymentProductItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency_code: json['currency_code'] as String,
      country_code: json['country_code'] as String,
      is_active: json['is_active'] as bool,
      stripe_product_id: json['stripe_product_id'] as String,
      stripe_price_id: json['stripe_price_id'] as String,
      created_on: json['created_on'] as int,
      tax_percentage: (json['tax_percentage'] as num).toDouble(),
      updated_on: json['updated_on'] as int?,
    );

Map<String, dynamic> _$PaymentProductItemModelToJson(
        PaymentProductItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'amount': instance.amount,
      'currency_code': instance.currency_code,
      'country_code': instance.country_code,
      'is_active': instance.is_active,
      'stripe_product_id': instance.stripe_product_id,
      'stripe_price_id': instance.stripe_price_id,
      'created_on': instance.created_on,
      'updated_on': instance.updated_on,
      'tax_percentage': instance.tax_percentage,
    };
