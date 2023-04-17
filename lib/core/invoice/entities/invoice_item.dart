import 'package:equatable/equatable.dart';
import 'package:priorli/core/invoice/models/invoice_item_model.dart';
import 'package:priorli/core/subscription/entities/payment_product_item.dart';

class InvoiceItem extends Equatable {
  final PaymentProductItem paymentProductItem;
  final double quantity;

  const InvoiceItem({required this.quantity, required this.paymentProductItem});

  factory InvoiceItem.modelToEntity(InvoiceItemModel model) => InvoiceItem(
        quantity: model.quantity,
        paymentProductItem:
            PaymentProductItem.modelToEntity(model.payment_product_item),
      );

  @override
  List<Object?> get props => [
        paymentProductItem,
        quantity,
      ];
}
