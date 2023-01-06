import 'package:equatable/equatable.dart';
import 'package:priorli/core/invoice/entities/invoice_item.dart';
import 'package:priorli/core/payment/entities/bank_account.dart';
import 'package:priorli/core/user/entities/user.dart';
import 'package:priorli/presentation/invoice/payment_term.dart';

class InvoiceCreationState extends Equatable {
  final List<InvoiceItem>? invoiceItemList;
  final String? companyId;
  final List<User>? receivers;
  final DateTime? paymentDate;
  final List<BankAccount>? bankAccountList;
  final String? bankAccountId;
  final String? invoiceName;
  final bool? sendEmail;
  final PaymentTerm? paymentTerm;

  const InvoiceCreationState(
      {this.invoiceItemList,
      this.companyId,
      this.receivers,
      this.sendEmail,
      this.invoiceName,
      this.paymentTerm,
      this.paymentDate,
      this.bankAccountList,
      this.bankAccountId});

  InvoiceCreationState copyWith(
          {List<InvoiceItem>? invoiceItemList,
          String? companyId,
          List<User>? receivers,
          DateTime? paymentDate,
          String? invoiceName,
          bool? sendEmail,
          PaymentTerm? paymentTerm,
          List<BankAccount>? bankAccountList,
          String? bankAccountId}) =>
      InvoiceCreationState(
          invoiceItemList: invoiceItemList ?? this.invoiceItemList,
          companyId: companyId ?? this.companyId,
          receivers: receivers ?? this.receivers,
          paymentDate: paymentDate ?? this.paymentDate,
          sendEmail: sendEmail ?? this.sendEmail,
          paymentTerm: paymentTerm ?? this.paymentTerm,
          invoiceName: invoiceName ?? this.invoiceName,
          bankAccountId: bankAccountId ?? this.bankAccountId,
          bankAccountList: bankAccountList ?? this.bankAccountList);

  @override
  List<Object?> get props => [
        invoiceItemList,
        companyId,
        receivers,
        paymentDate,
        bankAccountId,
        bankAccountList,
        paymentTerm,
        invoiceName,
        sendEmail
      ];
}
