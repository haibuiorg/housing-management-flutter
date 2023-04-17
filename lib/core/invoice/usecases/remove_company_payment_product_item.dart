import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/invoice/repos/invoice_repository.dart';

import '../../base/usecase.dart';

class RemoveCompanyPaymentProductItem
    extends UseCase<bool, RemoveCompanyPaymentProductItemParams> {
  final InvoiceRepository repository;

  RemoveCompanyPaymentProductItem({required this.repository});

  @override
  Future<Result<bool>> call(
      RemoveCompanyPaymentProductItemParams params) async {
    return repository.deletePaymentProductItem(
        id: params.id, companyId: params.companyId);
  }
}

class RemoveCompanyPaymentProductItemParams extends Equatable {
  final String id;
  final String companyId;

  const RemoveCompanyPaymentProductItemParams(
      {required this.id, required this.companyId});

  @override
  List<Object?> get props => [id, companyId];
}
