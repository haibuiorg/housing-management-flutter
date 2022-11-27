import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/payment/entities/bank_account.dart';

abstract class PaymentRepository {
  Future<Result<BankAccount>> addBankAccount({
    required String bankAccountNumber,
    required String swift,
    required String housingCompanyId,
  });
  Future<Result<List<BankAccount>>> getAllBankAccounts({
    required String housingCompanyId,
  });
  Future<Result<List<BankAccount>>> removeBankAccount({
    required String bankAccountId,
    required String housingCompanyId,
  });
}
