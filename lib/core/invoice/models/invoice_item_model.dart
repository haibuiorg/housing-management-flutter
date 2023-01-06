// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invoice_item_model.g.dart';

@JsonSerializable()
class InvoiceItemModel extends Equatable {
  /*
   name: string,
    description: string,
    unit_cost: number,
    quantity: number,
    total: number,
    tax_percentage: number,
  */
  final String name;
  final String description;
  final double unit_cost;
  final double quantity;
  final double total;
  final double tax_percentage;

  const InvoiceItemModel(
      {required this.name,
      required this.description,
      required this.unit_cost,
      required this.quantity,
      required this.total,
      required this.tax_percentage});

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceItemModelToJson(this);

  @override
  List<Object?> get props =>
      [name, description, unit_cost, quantity, total, tax_percentage];
}
