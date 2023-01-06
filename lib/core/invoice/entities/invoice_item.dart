import 'package:equatable/equatable.dart';
import 'package:priorli/core/invoice/models/invoice_item_model.dart';

class InvoiceItem extends Equatable {
  final String name;
  final String description;
  final double unitCost;
  final double quantity;
  final double total;
  final double taxPercentage;

  const InvoiceItem(
      {required this.name,
      required this.description,
      required this.unitCost,
      required this.quantity,
      required this.total,
      required this.taxPercentage});

  factory InvoiceItem.modelToEntity(InvoiceItemModel model) => InvoiceItem(
      name: model.name,
      description: model.description,
      unitCost: model.unit_cost,
      quantity: model.quantity,
      total: model.total,
      taxPercentage: model.tax_percentage);

  @override
  List<Object?> get props =>
      [name, description, unitCost, quantity, total, taxPercentage];
}
