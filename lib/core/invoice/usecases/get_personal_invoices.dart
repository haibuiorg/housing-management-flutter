import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/invoice/entities/invoice.dart';
import 'package:priorli/core/invoice/repos/invoice_repository.dart';

import '../entities/invoice_status.dart';

class GetInvoicesParams extends Equatable {
  final InvoiceStatus? status;
  final int? limit;
  final int? lastCreatedOn;
  final String? companyId;
  final String? groupId;

  const GetInvoicesParams(
      {this.status,
      this.limit,
      this.lastCreatedOn,
      this.groupId,
      this.companyId});

  @override
  List<Object?> get props => [groupId, lastCreatedOn, status, limit, companyId];
}

class GetPersonalInvoices extends UseCase<List<Invoice>, GetInvoicesParams> {
  final InvoiceRepository invoiceRepository;

  GetPersonalInvoices({required this.invoiceRepository});
  @override
  Future<Result<List<Invoice>>> call(GetInvoicesParams params) {
    return invoiceRepository.getInvoices(
        status: params.status,
        limit: params.limit,
        lastCreatedOn: params.lastCreatedOn,
        personal: true,
        groupId: params.groupId,
        companyId: params.companyId);
  }
}
