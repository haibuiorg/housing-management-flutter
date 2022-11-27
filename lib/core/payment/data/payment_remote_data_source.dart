import 'package:dio/dio.dart';
import 'package:priorli/core/payment/data/payment_data_source.dart';
import 'package:priorli/core/payment/models/bank_account_model.dart';

import '../../base/exceptions.dart';

class PaymentRemoteDataSource implements PaymentDataSource {
  final Dio client;
  final String _paymentPath = '/bank_accounts';
  PaymentRemoteDataSource({required this.client});

  @override
  Future<BankAccountModel> addBankAccount(
      {required String bankAccountNumber,
      required String swift,
      required String housingCompanyId}) async {
    final data = {
      'swift': swift,
      'bank_account_number': bankAccountNumber,
      'housing_company_id': housingCompanyId,
    };
    try {
      final result = await client.post(_paymentPath, data: data);
      return BankAccountModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<BankAccountModel>> getAllBankAccount(
      {required String housingCompanyId}) async {
    try {
      final data = {
        'housing_company_id': housingCompanyId,
      };
      final result = await client.get(_paymentPath, queryParameters: data);
      return (result.data as List<dynamic>)
          .map((json) => BankAccountModel.fromJson(json))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<BankAccountModel>> removeBankAccount({
    required String bankAccountId,
    required String housingCompanyId,
  }) async {
    final data = {
      'bank_account_id': bankAccountId,
      'housing_company_id': housingCompanyId
    };
    try {
      final result = await client.delete(_paymentPath, data: data);
      return (result.data as List<dynamic>)
          .map((json) => BankAccountModel.fromJson(json))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }
}
