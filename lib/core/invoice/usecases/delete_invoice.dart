import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/invoice.dart';
import '../repos/invoice_repository.dart';
import 'get_invoice_detail.dart';

class DeleteInvoice extends UseCase<Invoice, InvoiceRequestParams> {
  final InvoiceRepository invoiceRepository;

  DeleteInvoice({required this.invoiceRepository});

  @override
  Future<Result<Invoice>> call(InvoiceRequestParams params) {
    return invoiceRepository.getInvoiceDetail(invoiceId: params.invoiceId);
  }
}
