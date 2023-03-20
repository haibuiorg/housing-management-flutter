// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_product_item_model.g.dart';

@JsonSerializable()
class PaymentProductItemModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final double amount;
  final String currency_code;
  final String country_code;
  final bool is_active;
  final String stripe_product_id;
  final String stripe_price_id;
  final int created_on;
  final int? updated_on;

  const PaymentProductItemModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.amount,
      required this.currency_code,
      required this.country_code,
      required this.is_active,
      required this.stripe_product_id,
      required this.stripe_price_id,
      required this.created_on,
      this.updated_on});

  factory PaymentProductItemModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentProductItemModelFromJson(json);

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        amount,
        currency_code,
        country_code,
        is_active,
        stripe_product_id,
        stripe_price_id,
        created_on,
        updated_on,
      ];
}
