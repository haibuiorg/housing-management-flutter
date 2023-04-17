import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/invoice/repos/invoice_repository.dart';

import '../entities/invoice.dart';

class CreateInvoicesParams extends Equatable {
  final String companyId;
  final List<String> receiverIds;
  final String invoiceName;
  final String bankAccountId;
  final int paymentDate;
  final List<InvoiceItemParams> items;
  final bool sendEmail;
  final bool? issueExternalInvoice;

  const CreateInvoicesParams(
      {required this.companyId,
      required this.receiverIds,
      required this.invoiceName,
      required this.bankAccountId,
      required this.paymentDate,
      required this.items,
      this.issueExternalInvoice,
      required this.sendEmail});

  @override
  List<Object?> get props => [
        companyId,
        receiverIds,
        invoiceName,
        bankAccountId,
        paymentDate,
        items,
        sendEmail,
        issueExternalInvoice
      ];
}

class InvoiceItemParams extends Equatable {
  final String paymentProductId;
  final double quantity;

  const InvoiceItemParams(
      {required this.paymentProductId, required this.quantity});

  @override
  List<Object?> get props => [paymentProductId, quantity];
}

class CreateNewInvoices extends UseCase<List<Invoice>, CreateInvoicesParams> {
  final InvoiceRepository invoiceRepository;

  CreateNewInvoices({required this.invoiceRepository});

  @override
  Future<Result<List<Invoice>>> call(CreateInvoicesParams params) {
    return invoiceRepository.createNewInvoices(
        companyId: params.companyId,
        receiverIds: params.receiverIds,
        invoiceName: params.invoiceName,
        bankAccountId: params.bankAccountId,
        paymentDate: params.paymentDate,
        items: params.items,
        issueExternalInvoice: params.issueExternalInvoice,
        sendEmail: params.sendEmail);
  }
}
