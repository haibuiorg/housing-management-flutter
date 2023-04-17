import 'package:equatable/equatable.dart';
import 'package:priorli/core/payment/entities/bank_account.dart';

class HousingCompanyPaymentState extends Equatable {
  final List<BankAccount>? bankAccountList;
  final String? housingCompanyId;
  final bool? newBankAccountAdded;
  final String? connectPaymentAccountUrl;

  const HousingCompanyPaymentState(
      {this.bankAccountList,
      this.housingCompanyId,
      this.newBankAccountAdded,
      this.connectPaymentAccountUrl});

  HousingCompanyPaymentState copyWith(
          {List<BankAccount>? bankAccountList,
          String? housingCompanyId,
          String? connectPaymentAccountUrl,
          bool? newBankAccountAdded}) =>
      HousingCompanyPaymentState(
          connectPaymentAccountUrl:
              connectPaymentAccountUrl ?? this.connectPaymentAccountUrl,
          newBankAccountAdded: newBankAccountAdded ?? this.newBankAccountAdded,
          housingCompanyId: housingCompanyId ?? this.housingCompanyId,
          bankAccountList: bankAccountList ?? this.bankAccountList);

  @override
  List<Object?> get props => [
        bankAccountList,
        housingCompanyId,
        newBankAccountAdded,
        connectPaymentAccountUrl
      ];
}
