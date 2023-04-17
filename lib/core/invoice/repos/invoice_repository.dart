import 'package:priorli/core/base/result.dart';

import '../../subscription/entities/payment_product_item.dart';
import '../entities/invoice.dart';
import '../entities/invoice_group.dart';
import '../entities/invoice_status.dart';
import '../usecases/create_new_invoices.dart';

abstract class InvoiceRepository {
  Future<Result<List<Invoice>>> createNewInvoices(
      {required String companyId,
      required List<String> receiverIds,
      required String invoiceName,
      required String bankAccountId,
      required int paymentDate,
      required List<InvoiceItemParams> items,
      bool? issueExternalInvoice,
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
      {required String invoiceId,
      required List<String> emails,
      String? name,
      String? streetAddress1,
      String? streetAddress2,
      String? postalCode,
      String? city,
      String? countryCode});
  Future<Result<PaymentProductItem>> addPaymentProductItem({
    required String companyId,
    required String name,
    required String description,
    required double price,
    required double taxPercentage,
  });
  Future<Result<List<PaymentProductItem>>> getPaymentProductItems({
    required String companyId,
  });
  Future<Result<bool>> deletePaymentProductItem({
    required String id,
    required String companyId,
  });
}
