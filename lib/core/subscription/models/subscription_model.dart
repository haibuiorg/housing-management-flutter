// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_model.g.dart';

@JsonSerializable()
class SubscriptionModel extends Equatable {
  final String subscription_plan_id;
  final String id;
  final int created_on;
  final int? ended_on;
  final String? checkout_session_id;
  final String created_by;
  final bool is_active;
  final String company_id;
  final int quantity;
  final String latest_invoice_url;
  final bool latest_invoice_paid;
  final String? payment_service_subscription_id;
  final Map<String, dynamic>? detail;

  const SubscriptionModel(
      {required this.subscription_plan_id,
      required this.id,
      required this.created_on,
      required this.quantity,
      required this.latest_invoice_paid,
      required this.latest_invoice_url,
      this.detail,
      this.payment_service_subscription_id,
      this.ended_on,
      required this.is_active,
      this.checkout_session_id,
      required this.created_by,
      required this.company_id});
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);
  @override
  List<Object?> get props => [
        subscription_plan_id,
        id,
        created_by,
        created_on,
        quantity,
        latest_invoice_paid,
        latest_invoice_url,
        is_active,
        checkout_session_id,
        company_id,
        detail,
        payment_service_subscription_id,
        ended_on
      ];
}
