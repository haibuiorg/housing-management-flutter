import 'package:priorli/core/invoice/models/invoice_group_model.dart';
import 'package:priorli/core/invoice/models/invoice_item_model.dart';
import 'package:priorli/core/invoice/models/invoice_model.dart';

import '../entities/invoice_status.dart';

abstract class InvoiceDataSource {
  Future<List<InvoiceModel>> createNewInvoices(
      {required String companyId,
      required List<String> receiverIds,
      required String invoiceName,
      required String bankAccountId,
      required int paymentDate,
      required List<InvoiceItemModel> items,
      required bool sendEmail});
  Future<InvoiceModel> deleteInvoice({required String invoiceId});
  Future<List<InvoiceModel>> getInvoices({
    InvoiceStatus? status,
    int? limit,
    int? lastCreatedOn,
    bool? personal,
    String? companyId,
    String? groupId,
  });
  Future<InvoiceModel> getInvoiceDetail({required String invoiceId});
  Future<List<InvoiceGroupModel>> getInvoiceGroups({
    String? companyId,
    bool? includeDeleted,
    int? limit,
    int? lastCreatedOn,
  });
  Future<InvoiceModel> sendInvoiceManually(
      {required String invoiceId, required List<String> emails});
}
