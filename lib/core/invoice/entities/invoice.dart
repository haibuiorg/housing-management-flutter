import 'package:equatable/equatable.dart';
import 'package:priorli/core/invoice/models/invoice_model.dart';

import 'invoice_item.dart';
import 'invoice_status.dart';

class Invoice extends Equatable {
  final String id;
  final String? invoiceName;
  final double subtotal;
  final double paid;
  final String? referenceNumber;
  final List<InvoiceItem> items;
  final String receiver;
  final String? storageLink;
  final int paymentDate;
  final String? virtualBarcode;
  final bool isDeleted;
  final int createdOn;
  final String companyId;
  final InvoiceStatus status;
  final String? invoiceUrl;
  final int? invoiceUrlExpiration;

  const Invoice(
      {required this.id,
      this.invoiceName,
      required this.subtotal,
      required this.paid,
      this.referenceNumber,
      required this.items,
      required this.receiver,
      this.storageLink,
      required this.paymentDate,
      this.virtualBarcode,
      required this.isDeleted,
      required this.createdOn,
      required this.companyId,
      required this.status,
      this.invoiceUrl,
      this.invoiceUrlExpiration});
  factory Invoice.modelToEntity(InvoiceModel model) => Invoice(
      invoiceName: model.invoice_name,
      referenceNumber: model.reference_number,
      storageLink: model.storage_link,
      virtualBarcode: model.virtual_barcode,
      id: model.id,
      subtotal: model.subtotal,
      paid: model.paid,
      invoiceUrl: model.invoice_url,
      invoiceUrlExpiration: model.invoice_url_expiration,
      items: model.items.map((e) => InvoiceItem.modelToEntity(e)).toList(),
      receiver: model.receiver,
      paymentDate: model.payment_date,
      isDeleted: model.is_deleted,
      createdOn: model.created_on,
      companyId: model.company_id,
      status: model.status);

  @override
  List<Object?> get props => [
        id,
        invoiceName,
        subtotal,
        paid,
        referenceNumber,
        items,
        receiver,
        storageLink,
        paymentDate,
        virtualBarcode,
        isDeleted,
        createdOn,
        companyId,
        status
      ];
}
