import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/invoice.dart';
import '../repos/invoice_repository.dart';
import 'get_personal_invoices.dart';

class GetCompanyInvoices extends UseCase<List<Invoice>, GetInvoicesParams> {
  final InvoiceRepository invoiceRepository;

  GetCompanyInvoices({required this.invoiceRepository});
  @override
  Future<Result<List<Invoice>>> call(GetInvoicesParams params) {
    return invoiceRepository.getInvoices(
        status: params.status,
        limit: params.limit,
        lastCreatedOn: params.lastCreatedOn,
        personal: false,
        groupId: params.groupId,
        companyId: params.companyId);
  }
}
