import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/payment/entities/bank_account.dart';
import 'package:priorli/core/payment/repos/payment_repository.dart';

class AddBankAccount extends UseCase<BankAccount, AddBankAccountParams> {
  final PaymentRepository paymentRepository;

  AddBankAccount({required this.paymentRepository});

  @override
  Future<Result<BankAccount>> call(AddBankAccountParams params) {
    return paymentRepository.addBankAccount(
        bankAccountNumber: params.bankAccountNumber,
        swift: params.swift,
        housingCompanyId: params.housingCompanyId);
  }
}

class AddBankAccountParams extends Equatable {
  final String housingCompanyId;
  final String swift;
  final String bankAccountNumber;

  const AddBankAccountParams(
      {required this.housingCompanyId,
      required this.swift,
      required this.bankAccountNumber});

  @override
  List<Object?> get props => [housingCompanyId, swift, bankAccountNumber];
}
