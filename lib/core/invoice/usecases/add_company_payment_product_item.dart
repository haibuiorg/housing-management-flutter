import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/subscription/entities/payment_product_item.dart';

import '../../base/usecase.dart';
import '../repos/invoice_repository.dart';

class AddCompanyPaymentProductItem
    extends UseCase<PaymentProductItem, AddCompanyPaymentProductItemParams> {
  AddCompanyPaymentProductItem({required this.invoiceRepository});

  final InvoiceRepository invoiceRepository;

  @override
  Future<Result<PaymentProductItem>> call(
      AddCompanyPaymentProductItemParams params) async {
    return invoiceRepository.addPaymentProductItem(
      companyId: params.companyId,
      name: params.name,
      description: params.description,
      taxPercentage: params.taxPercentage,
      price: params.price,
    );
  }
}

class AddCompanyPaymentProductItemParams extends Equatable {
  final String companyId;
  final String name;
  final String description;
  final double price;
  final double taxPercentage;

  const AddCompanyPaymentProductItemParams({
    required this.companyId,
    required this.name,
    required this.description,
    required this.price,
    required this.taxPercentage,
  });

  @override
  List<Object?> get props =>
      [companyId, name, description, price, taxPercentage];
}
