import 'package:priorli/core/payment/models/bank_account_model.dart';

abstract class PaymentDataSource {
  Future<BankAccountModel> addBankAccount({
    required String bankAccountNumber,
    required String swift,
    required String housingCompanyId,
    String? bankAccountName,
  });
  Future<List<BankAccountModel>> getAllBankAccount({
    required String housingCompanyId,
  });
  Future<List<BankAccountModel>> removeBankAccount({
    required String bankAccountId,
    required String housingCompanyId,
  });
  Future<String> setupConnectPaymentAccount({
    required String housingCompanyId,
  });
}
