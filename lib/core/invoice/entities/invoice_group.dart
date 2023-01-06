import 'package:equatable/equatable.dart';
import 'package:priorli/core/invoice/models/invoice_group_model.dart';

class InvoiceGroup extends Equatable {
  final String id;
  final String invoiceName;
  final int paymentDate;
  final bool isDeleted;
  final int createdOn;
  final String companyId;
  final int numberOfInvoices;

  const InvoiceGroup(
      {required this.id,
      required this.invoiceName,
      required this.paymentDate,
      required this.isDeleted,
      required this.createdOn,
      required this.companyId,
      required this.numberOfInvoices});

  factory InvoiceGroup.modelToEntity(InvoiceGroupModel model) => InvoiceGroup(
      id: model.id,
      invoiceName: model.invoice_name,
      paymentDate: model.payment_date,
      isDeleted: model.is_deleted,
      createdOn: model.created_on,
      companyId: model.company_id,
      numberOfInvoices: model.number_of_invoices);

  @override
  List<Object?> get props => [
        id,
        invoiceName,
        paymentDate,
        isDeleted,
        createdOn,
        companyId,
        numberOfInvoices
      ];
}
