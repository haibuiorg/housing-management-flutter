import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/invoice/entities/invoice.dart';
import 'package:priorli/core/invoice/repos/invoice_repository.dart';

class InvoiceRequestParams extends Equatable {
  final String invoiceId;

  const InvoiceRequestParams({required this.invoiceId});

  @override
  List<Object?> get props => [invoiceId];
}

class GetInvoiceDetail extends UseCase<Invoice, InvoiceRequestParams> {
  final InvoiceRepository invoiceRepository;

  GetInvoiceDetail({required this.invoiceRepository});

  @override
  Future<Result<Invoice>> call(InvoiceRequestParams params) {
    return invoiceRepository.getInvoiceDetail(invoiceId: params.invoiceId);
  }
}
