// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      subscription_plan_id: json['subscription_plan_id'] as String,
      id: json['id'] as String,
      created_on: json['created_on'] as int,
      quantity: json['quantity'] as int,
      latest_invoice_paid: json['latest_invoice_paid'] as bool,
      latest_invoice_url: json['latest_invoice_url'] as String,
      detail: json['detail'] as Map<String, dynamic>?,
      payment_service_subscription_id:
          json['payment_service_subscription_id'] as String?,
      ended_on: json['ended_on'] as int?,
      is_active: json['is_active'] as bool,
      checkout_session_id: json['checkout_session_id'] as String?,
      created_by: json['created_by'] as String,
      company_id: json['company_id'] as String,
    );

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) =>
    <String, dynamic>{
      'subscription_plan_id': instance.subscription_plan_id,
      'id': instance.id,
      'created_on': instance.created_on,
      'ended_on': instance.ended_on,
      'checkout_session_id': instance.checkout_session_id,
      'created_by': instance.created_by,
      'is_active': instance.is_active,
      'company_id': instance.company_id,
      'quantity': instance.quantity,
      'latest_invoice_url': instance.latest_invoice_url,
      'latest_invoice_paid': instance.latest_invoice_paid,
      'payment_service_subscription_id':
          instance.payment_service_subscription_id,
      'detail': instance.detail,
    };
