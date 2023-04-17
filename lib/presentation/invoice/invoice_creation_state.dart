import 'package:equatable/equatable.dart';
import 'package:priorli/core/invoice/entities/invoice_item.dart';
import 'package:priorli/core/payment/entities/bank_account.dart';
import 'package:priorli/core/subscription/entities/payment_product_item.dart';
import 'package:priorli/core/user/entities/user.dart';
import 'package:priorli/presentation/invoice/payment_term.dart';

class InvoiceCreationState extends Equatable {
  final List<PaymentProductItem>? availableItems;
  final List<InvoiceItem>? invoiceItemList;
  final String? companyId;
  final List<User>? receivers;
  final DateTime? paymentDate;
  final List<BankAccount>? bankAccountList;
  final String? bankAccountId;
  final String? invoiceName;
  final bool? sendEmail;
  final bool? issueExternalInvoice;
  final PaymentTerm? paymentTerm;

  const InvoiceCreationState(
      {this.availableItems,
      this.companyId,
      this.invoiceItemList,
      this.receivers,
      this.sendEmail,
      this.invoiceName,
      this.paymentTerm,
      this.paymentDate,
      this.bankAccountList,
      this.bankAccountId,
      this.issueExternalInvoice});

  InvoiceCreationState copyWith(
          {List<InvoiceItem>? invoiceItemList,
          List<PaymentProductItem>? availableItems,
          String? companyId,
          List<User>? receivers,
          DateTime? paymentDate,
          String? invoiceName,
          bool? sendEmail,
          PaymentTerm? paymentTerm,
          List<BankAccount>? bankAccountList,
          bool? issueExternalInvoice,
          String? bankAccountId}) =>
      InvoiceCreationState(
          availableItems: availableItems ?? this.availableItems,
          invoiceItemList: invoiceItemList ?? this.invoiceItemList,
          companyId: companyId ?? this.companyId,
          receivers: receivers ?? this.receivers,
          paymentDate: paymentDate ?? this.paymentDate,
          sendEmail: sendEmail ?? this.sendEmail,
          paymentTerm: paymentTerm ?? this.paymentTerm,
          invoiceName: invoiceName ?? this.invoiceName,
          issueExternalInvoice:
              issueExternalInvoice ?? this.issueExternalInvoice,
          bankAccountId: bankAccountId ?? this.bankAccountId,
          bankAccountList: bankAccountList ?? this.bankAccountList);

  @override
  List<Object?> get props => [
        availableItems,
        invoiceItemList,
        companyId,
        receivers,
        paymentDate,
        bankAccountId,
        bankAccountList,
        paymentTerm,
        invoiceName,
        sendEmail,
        issueExternalInvoice
      ];
}
