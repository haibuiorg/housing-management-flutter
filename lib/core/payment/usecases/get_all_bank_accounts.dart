import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/payment/entities/bank_account.dart';
import 'package:priorli/core/payment/repos/payment_repository.dart';

class GetAllBankAccounts
    extends UseCase<List<BankAccount>, GetAllBankAccountParams> {
  final PaymentRepository paymentRepository;

  GetAllBankAccounts({required this.paymentRepository});

  @override
  Future<Result<List<BankAccount>>> call(GetAllBankAccountParams params) {
    return paymentRepository.getAllBankAccounts(
        housingCompanyId: params.housingCompanyId);
  }
}

class GetAllBankAccountParams extends Equatable {
  final String housingCompanyId;

  const GetAllBankAccountParams({
    required this.housingCompanyId,
  });

  @override
  List<Object?> get props => [
        housingCompanyId,
      ];
}
