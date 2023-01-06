import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/invoice/repos/invoice_repository.dart';

import '../entities/invoice.dart';
import '../entities/invoice_item.dart';

class CreateInvoicesParams extends Equatable {
  final String companyId;
  final List<String> receiverIds;
  final String invoiceName;
  final String bankAccountId;
  final int paymentDate;
  final List<InvoiceItem> items;
  final bool sendEmail;

  const CreateInvoicesParams(
      {required this.companyId,
      required this.receiverIds,
      required this.invoiceName,
      required this.bankAccountId,
      required this.paymentDate,
      required this.items,
      required this.sendEmail});

  @override
  List<Object?> get props => [
        companyId,
        receiverIds,
        invoiceName,
        bankAccountId,
        paymentDate,
        items,
        sendEmail
      ];
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
        sendEmail: params.sendEmail);
  }
}
