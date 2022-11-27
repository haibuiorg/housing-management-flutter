import 'package:priorli/core/payment/entities/bank_account.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/payment/repos/payment_repository.dart';

import '../../base/exceptions.dart';
import '../../base/failure.dart';
import '../data/payment_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentDataSource paymentRemoteDataSource;

  PaymentRepositoryImpl({required this.paymentRemoteDataSource});
  @override
  Future<Result<BankAccount>> addBankAccount(
      {required String bankAccountNumber,
      required String swift,
      required String housingCompanyId}) async {
    try {
      final paymentModel = await paymentRemoteDataSource.addBankAccount(
          swift: swift,
          bankAccountNumber: bankAccountNumber,
          housingCompanyId: housingCompanyId);
      return ResultSuccess(BankAccount.modelToEntity(paymentModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<BankAccount>>> getAllBankAccounts(
      {required String housingCompanyId}) async {
    try {
      final paymentModelList = await paymentRemoteDataSource.getAllBankAccount(
          housingCompanyId: housingCompanyId);
      return ResultSuccess(
          paymentModelList.map((e) => BankAccount.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<BankAccount>>> removeBankAccount({
    required String bankAccountId,
    required String housingCompanyId,
  }) async {
    try {
      final paymentModelList = await paymentRemoteDataSource.removeBankAccount(
          bankAccountId: bankAccountId, housingCompanyId: housingCompanyId);
      return ResultSuccess(
          paymentModelList.map((e) => BankAccount.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}
