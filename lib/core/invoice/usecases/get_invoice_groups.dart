import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/invoice/entities/invoice_group.dart';
import 'package:priorli/core/invoice/repos/invoice_repository.dart';

class GetInvoiceGroupParams extends Equatable {
  final bool? includeDeleted;
  final int? limit;
  final int? lastCreatedOn;
  final String? companyId;

  const GetInvoiceGroupParams(
      {this.includeDeleted, this.limit, this.lastCreatedOn, this.companyId});

  @override
  List<Object?> get props => [includeDeleted, limit, lastCreatedOn, companyId];
}

class GetInvoiceGroups
    extends UseCase<List<InvoiceGroup>, GetInvoiceGroupParams> {
  final InvoiceRepository invoiceRepository;

  GetInvoiceGroups({required this.invoiceRepository});
  @override
  Future<Result<List<InvoiceGroup>>> call(GetInvoiceGroupParams params) {
    return invoiceRepository.getInvoiceGroups(
        includeDeleted: params.includeDeleted,
        lastCreatedOn: params.lastCreatedOn,
        limit: params.limit,
        companyId: params.companyId);
  }
}
