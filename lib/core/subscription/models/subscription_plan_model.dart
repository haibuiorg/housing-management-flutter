// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_plan_model.g.dart';

@JsonSerializable()
class SubscriptionPlanModel extends Equatable {
  final String id;
  final String name;
  final double price;
  final String currency;
  final String country_code;
  final bool is_active;
  final String stripe_product_id;
  final String stripe_price_id;
  final int created_on;
  final int max_account;
  final bool translation;
  final int max_messaging_channels;
  final int? max_announcement;
  final int max_invoice_number;
  final double additional_invoice_cost;
  final String interval;
  final int interval_count;
  final bool? has_apartment_document;
  final List<String>? notification_types;

  const SubscriptionPlanModel(
      {required this.id,
      required this.name,
      required this.price,
      required this.currency,
      required this.country_code,
      required this.is_active,
      required this.stripe_product_id,
      required this.stripe_price_id,
      required this.created_on,
      required this.max_account,
      required this.translation,
      required this.max_messaging_channels,
      required this.max_announcement,
      required this.max_invoice_number,
      required this.additional_invoice_cost,
      required this.interval,
      required this.notification_types,
      required this.has_apartment_document,
      required this.interval_count});
  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPlanModelFromJson(json);
  @override
  List<Object?> get props => [
        id,
        name,
        price,
        currency,
        is_active,
        country_code,
        stripe_product_id,
        stripe_price_id,
        created_on,
        max_account,
        translation,
        notification_types,
        max_messaging_channels,
        max_announcement,
        max_invoice_number,
        additional_invoice_cost,
        interval,
        interval_count,
        has_apartment_document
      ];
}
