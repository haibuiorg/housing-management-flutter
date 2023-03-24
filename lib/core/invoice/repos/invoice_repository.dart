import 'package:priorli/core/base/result.dart';

import '../entities/invoice.dart';
import '../entities/invoice_group.dart';
import '../entities/invoice_item.dart';
import '../entities/invoice_status.dart';

abstract class InvoiceRepository {
  Future<Result<List<Invoice>>> createNewInvoices(
      {required String companyId,
      required List<String> receiverIds,
      required String invoiceName,
      required String bankAccountId,
      required int paymentDate,
      required List<InvoiceItem> items,
      required bool sendEmail});
  Future<Result<Invoice>> deleteInvoice({required String invoiceId});
  Future<Result<List<Invoice>>> getInvoices({
    InvoiceStatus? status,
    int? limit,
    int? lastCreatedOn,
    String? groupId,
    bool? personal,
    String? companyId,
  });
  Future<Result<Invoice>> getInvoiceDetail({required String invoiceId});
  Future<Result<List<InvoiceGroup>>> getInvoiceGroups({
    String? companyId,
    bool? includeDeleted,
    int? limit,
    int? lastCreatedOn,
  });
  Future<Result<Invoice>> sendInvoiceManually(
      {required String invoiceId, required List<String> emails});
}
