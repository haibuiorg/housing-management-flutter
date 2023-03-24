import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';

import '../../base/usecase.dart';
import '../entities/invoice.dart';
import '../repos/invoice_repository.dart';

class SendInvoiceManually extends UseCase<Invoice, SendInvoiceManuallyParams> {
  final InvoiceRepository invoiceRepository;

  SendInvoiceManually(this.invoiceRepository);

  @override
  Future<Result<Invoice>> call(SendInvoiceManuallyParams params) async {
    return await invoiceRepository.sendInvoiceManually(
      invoiceId: params.invoiceId,
      emails: params.emails,
    );
  }
}

class SendInvoiceManuallyParams extends Equatable {
  final String invoiceId;
  final List<String> emails;

  const SendInvoiceManuallyParams({
    required this.invoiceId,
    required this.emails,
  });

  @override
  List<Object?> get props => [invoiceId, emails];
}
