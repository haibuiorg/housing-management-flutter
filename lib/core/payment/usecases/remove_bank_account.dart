import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/payment/entities/bank_account.dart';
import 'package:priorli/core/payment/repos/payment_repository.dart';

class RemoveBankAccount
    extends UseCase<List<BankAccount>, RemoveBankAccountParams> {
  final PaymentRepository paymentRepository;

  RemoveBankAccount({required this.paymentRepository});

  @override
  Future<Result<List<BankAccount>>> call(RemoveBankAccountParams params) {
    return paymentRepository.removeBankAccount(
        bankAccountId: params.bankAccountId,
        housingCompanyId: params.housingCompanyId);
  }
}

class RemoveBankAccountParams extends Equatable {
  final String housingCompanyId;
  final String bankAccountId;

  const RemoveBankAccountParams({
    required this.housingCompanyId,
    required this.bankAccountId,
  });

  @override
  List<Object?> get props => [
        housingCompanyId,
        bankAccountId,
      ];
}
