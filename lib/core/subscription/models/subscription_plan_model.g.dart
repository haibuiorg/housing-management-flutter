// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionPlanModel _$SubscriptionPlanModelFromJson(
        Map<String, dynamic> json) =>
    SubscriptionPlanModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      country_code: json['country_code'] as String,
      is_active: json['is_active'] as bool,
      stripe_product_id: json['stripe_product_id'] as String,
      stripe_price_id: json['stripe_price_id'] as String,
      created_on: json['created_on'] as int,
      translation: json['translation'] as bool,
      max_messaging_channels: json['max_messaging_channels'] as int,
      max_announcement: json['max_announcement'] as int?,
      max_invoice_number: json['max_invoice_number'] as int,
      additional_invoice_cost:
          (json['additional_invoice_cost'] as num).toDouble(),
      interval: json['interval'] as String,
      notification_types: (json['notification_types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      has_apartment_document: json['has_apartment_document'] as bool?,
      interval_count: json['interval_count'] as int,
    );

Map<String, dynamic> _$SubscriptionPlanModelToJson(
        SubscriptionPlanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'currency': instance.currency,
      'country_code': instance.country_code,
      'is_active': instance.is_active,
      'stripe_product_id': instance.stripe_product_id,
      'stripe_price_id': instance.stripe_price_id,
      'created_on': instance.created_on,
      'translation': instance.translation,
      'max_messaging_channels': instance.max_messaging_channels,
      'max_announcement': instance.max_announcement,
      'max_invoice_number': instance.max_invoice_number,
      'additional_invoice_cost': instance.additional_invoice_cost,
      'interval': instance.interval,
      'interval_count': instance.interval_count,
      'has_apartment_document': instance.has_apartment_document,
      'notification_types': instance.notification_types,
    };
