import 'package:equatable/equatable.dart';
import 'package:priorli/core/payment/entities/bank_account.dart';

class HousingCompanyPaymentState extends Equatable {
  final List<BankAccount>? bankAccountList;
  final String? housingCompanyId;
  final bool? newBankAccountAdded;

  const HousingCompanyPaymentState(
      {this.bankAccountList, this.housingCompanyId, this.newBankAccountAdded});

  HousingCompanyPaymentState copyWith(
          {List<BankAccount>? bankAccountList,
          String? housingCompanyId,
          bool? newBankAccountAdded}) =>
      HousingCompanyPaymentState(
          newBankAccountAdded: newBankAccountAdded ?? this.newBankAccountAdded,
          housingCompanyId: housingCompanyId ?? this.housingCompanyId,
          bankAccountList: bankAccountList ?? this.bankAccountList);

  @override
  List<Object?> get props =>
      [bankAccountList, housingCompanyId, newBankAccountAdded];
}
