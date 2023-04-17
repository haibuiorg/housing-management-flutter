import 'package:priorli/core/invoice/models/invoice_group_model.dart';
import 'package:priorli/core/invoice/models/invoice_model.dart';

import '../../subscription/models/payment_product_item_model.dart';
import '../entities/invoice_status.dart';
import '../usecases/create_new_invoices.dart';

abstract class InvoiceDataSource {
  Future<List<InvoiceModel>> createNewInvoices(
      {required String companyId,
      required List<String> receiverIds,
      required String invoiceName,
      required String bankAccountId,
      required int paymentDate,
      required List<InvoiceItemParams> items,
      required bool sendEmail,
      bool? issueExternalInvoice});
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
      {required String invoiceId,
      required List<String> emails,
      String? name,
      String? streetAddress1,
      String? streetAddress2,
      String? postalCode,
      String? city,
      String? countryCode});
  Future<PaymentProductItemModel> addPaymentProductItem({
    required String companyId,
    required String name,
    required String description,
    required double price,
    required double taxPercentage,
  });
  Future<List<PaymentProductItemModel>> getPaymentProductItems({
    required String companyId,
  });
  Future<bool> deletePaymentProductItem({
    required String id,
    required String companyId,
  });
}
