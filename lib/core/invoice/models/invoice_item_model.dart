// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:priorli/core/subscription/models/payment_product_item_model.dart';

part 'invoice_item_model.g.dart';

@JsonSerializable()
class InvoiceItemModel extends Equatable {
  final PaymentProductItemModel payment_product_item;
  final double quantity;

  const InvoiceItemModel({
    required this.quantity,
    required this.payment_product_item,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceItemModelToJson(this);

  @override
  List<Object?> get props => [quantity, payment_product_item];
}
