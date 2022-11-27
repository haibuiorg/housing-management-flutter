import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/payment/entities/bank_account.dart';
import 'package:priorli/core/payment/usecases/add_bank_account.dart';
import 'package:priorli/core/payment/usecases/get_all_bank_accounts.dart';
import 'package:priorli/core/payment/usecases/remove_bank_account.dart';
import 'package:priorli/presentation/housing_company_payment/housing_company_payment_state.dart';

class HousingCompanyPaymentCubit extends Cubit<HousingCompanyPaymentState> {
  final GetAllBankAccounts _getAllBankAccounts;
  final AddBankAccount _addBankAccount;
  final RemoveBankAccount _removeBankAccount;
  HousingCompanyPaymentCubit(
      this._getAllBankAccounts, this._addBankAccount, this._removeBankAccount)
      : super(const HousingCompanyPaymentState());

  void init(String housingCompanyId) async {
    final getAllBankAccountResult = await _getAllBankAccounts(
        GetAllBankAccountParams(housingCompanyId: housingCompanyId));
    if (getAllBankAccountResult is ResultSuccess<List<BankAccount>>) {
      emit(state.copyWith(
          bankAccountList: getAllBankAccountResult.data,
          housingCompanyId: housingCompanyId));
    } else {
      emit(state.copyWith(housingCompanyId: housingCompanyId));
    }
  }

  Future<void> addNewBankAccount(
      {required String swift, required String bankAccountNumber}) async {
    final addBankAccountResult = await _addBankAccount(AddBankAccountParams(
        housingCompanyId: state.housingCompanyId ?? '',
        swift: swift,
        bankAccountNumber: bankAccountNumber));
    if (addBankAccountResult is ResultSuccess<BankAccount>) {
      final List<BankAccount> newBankAccountList =
          List.from(state.bankAccountList ?? []);
      newBankAccountList.add(addBankAccountResult.data);
      emit(state.copyWith(
          bankAccountList: newBankAccountList, newBankAccountAdded: true));
    }
  }

  Future<void> removeBankAccount({required String bankAccountId}) async {
    final addBankAccountResult =
        await _removeBankAccount(RemoveBankAccountParams(
      housingCompanyId: state.housingCompanyId ?? '',
      bankAccountId: bankAccountId,
    ));
    if (addBankAccountResult is ResultSuccess<List<BankAccount>>) {
      final List<BankAccount> newBankAccountList =
          List.from(addBankAccountResult.data);
      emit(state.copyWith(bankAccountList: newBankAccountList));
    }
  }

  void bankAccountDialogDismissed() {
    emit(state.copyWith(newBankAccountAdded: false));
  }
}
