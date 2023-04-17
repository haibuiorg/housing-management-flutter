import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/subscription/entities/payment_product_item.dart';

import '../../base/usecase.dart';
import '../repos/invoice_repository.dart';

class GetCompanyPaymentProductItems extends UseCase<List<PaymentProductItem>,
    GetCompanyPaymentProductItemsParams> {
  final InvoiceRepository repository;

  GetCompanyPaymentProductItems({required this.repository});

  @override
  Future<Result<List<PaymentProductItem>>> call(
      GetCompanyPaymentProductItemsParams params) async {
    return repository.getPaymentProductItems(companyId: params.companyId);
  }
}

class GetCompanyPaymentProductItemsParams extends Equatable {
  final String companyId;

  const GetCompanyPaymentProductItemsParams({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}
