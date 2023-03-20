import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/invoice/entities/invoice.dart';
import 'package:priorli/core/invoice/entities/invoice_item.dart';
import 'package:priorli/core/invoice/usecases/create_new_invoices.dart';
import 'package:priorli/core/payment/entities/bank_account.dart';
import 'package:priorli/core/payment/usecases/get_all_bank_accounts.dart';
import 'package:priorli/core/user/entities/user.dart';
import 'package:priorli/presentation/invoice/invoice_creation_state.dart';
import 'package:priorli/presentation/invoice/payment_term.dart';

class InvoiceCreationCubit extends Cubit<InvoiceCreationState> {
  final GetAllBankAccounts _getAllBankAccounts;
  final CreateNewInvoices _createNewInvoices;

  InvoiceCreationCubit(this._getAllBankAccounts, this._createNewInvoices)
      : super(const InvoiceCreationState());
  Future<void> init(String companyId) async {
    final now = DateTime.now();
    final endOfNow = DateTime(now.year, now.month, now.day);
    const paymentTerm = PaymentTerm.fourteenDay;
    final newPaymentDate = endOfNow.add(const Duration(days: 14));
    emit(
      state.copyWith(
        companyId: companyId,
        paymentTerm: paymentTerm,
        paymentDate: newPaymentDate,
      ),
    );
    final getBankAccountResult = await _getAllBankAccounts(
        GetAllBankAccountParams(housingCompanyId: companyId));
    if (getBankAccountResult is ResultSuccess<List<BankAccount>>) {
      emit(state.copyWith(
          bankAccountList: getBankAccountResult.data,
          bankAccountId: getBankAccountResult.data.first.id));
    }
  }

  Future<bool> createNewInvoice() async {
    final createNewInvoiceResult = await _createNewInvoices(
        CreateInvoicesParams(
            companyId: state.companyId ?? '',
            receiverIds: state.receivers?.map((e) => e.userId).toList() ?? [],
            invoiceName: state.invoiceName ?? 'Invoice ${DateTime.now()}',
            bankAccountId: state.bankAccountId ?? '',
            paymentDate: state.paymentDate?.millisecondsSinceEpoch ??
                DateTime.now()
                    .add(const Duration(days: 14))
                    .millisecondsSinceEpoch,
            items: state.invoiceItemList ?? [],
            sendEmail: state.sendEmail ?? true));
    return createNewInvoiceResult is ResultSuccess<List<Invoice>>;
  }

  void setSendEmail(bool? value) {
    emit(state.copyWith(sendEmail: value));
  }

  void setReceiver(List<User> userList) {
    emit(state.copyWith(receivers: userList));
  }

  void editItem(
      {required int index,
      required String name,
      required String description,
      required double price,
      required double quantity,
      required double taxPercentage,
      required double total}) {
    final List<InvoiceItem> list = List.from(state.invoiceItemList ?? []);
    list.removeAt(index);
    final item = InvoiceItem(
        name: name,
        description: description,
        unitCost: price,
        quantity: quantity,
        total: total,
        taxPercentage: taxPercentage);
    list.insert(index, item);
    emit(state.copyWith(invoiceItemList: list));
  }

  void removeItem(int index) {
    final List<InvoiceItem> list = List.from(state.invoiceItemList ?? []);

    list.removeAt(index);

    emit(state.copyWith(invoiceItemList: list));
  }

  void addInvoiceItem(
      {required String name,
      required String description,
      required double price,
      required double quantity,
      required double taxPercentage,
      required double total}) {
    final List<InvoiceItem> list = List.from(state.invoiceItemList ?? []);
    final item = InvoiceItem(
        name: name,
        description: description,
        unitCost: price,
        quantity: quantity,
        total: total,
        taxPercentage: taxPercentage);
    list.add(item);
    emit(state.copyWith(invoiceItemList: list));
  }

  void setPaymentDate(DateTime dateTime) {
    emit(state.copyWith(paymentDate: dateTime));
  }

  void onNameChanged(String value) {
    emit(state.copyWith(invoiceName: value));
  }

  void setPaymentTerm(String value) {
    if (value.isEmpty) {
      return;
    }
    final now = DateTime.now();
    final endOfNow = DateTime(now.year, now.month, now.day);
    final paymentTerm =
        PaymentTerm.values.where((element) => element.name == value).first;
    final newPaymentDate = (paymentTerm == PaymentTerm.sevenDay)
        ? endOfNow.add(const Duration(days: 7))
        : (paymentTerm == PaymentTerm.fourteenDay)
            ? endOfNow.add(const Duration(days: 14))
            : (paymentTerm == PaymentTerm.thirtyDay)
                ? endOfNow.add(const Duration(days: 30))
                : DateTime.fromMillisecondsSinceEpoch(
                    state.paymentDate?.millisecondsSinceEpoch ?? 0);
    emit(state.copyWith(paymentTerm: paymentTerm, paymentDate: newPaymentDate));
  }

  void selectBankAccount(String? id) {
    emit(state.copyWith(bankAccountId: id));
  }
}
