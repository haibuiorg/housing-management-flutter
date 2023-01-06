import 'package:dio/dio.dart';
import 'package:priorli/core/invoice/data/invoice_data_source.dart';
import 'package:priorli/core/invoice/models/invoice_group_model.dart';
import 'package:priorli/core/invoice/models/invoice_model.dart';
import 'package:priorli/core/invoice/models/invoice_item_model.dart';
import 'package:priorli/core/utils/string_extension.dart';

import '../../base/exceptions.dart';
import '../entities/invoice_status.dart';

class InvoiceRemoteDataSource implements InvoiceDataSource {
  final Dio client;

  InvoiceRemoteDataSource({required this.client});
  @override
  Future<List<InvoiceModel>> createNewInvoices(
      {required String companyId,
      required List<String> receiverIds,
      required String invoiceName,
      required String bankAccountId,
      required int paymentDate,
      required List<InvoiceItemModel> items,
      required bool sendEmail}) async {
    try {
      final data = {
        'company_id': companyId,
        'receiver_ids': receiverIds,
        'invoice_name': invoiceName,
        'bank_account_id': bankAccountId,
        'payment_date': paymentDate,
        'items': items.map((e) => e.toJson()).toList(),
        'send_email': sendEmail,
      };
      final result = await client.post('/invoices', data: data);
      return (result.data as List<dynamic>)
          .map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<InvoiceModel> deleteInvoice({required String invoiceId}) async {
    try {
      final result = await client.delete('/invoice/$invoiceId');
      return InvoiceModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<InvoiceModel> getInvoiceDetail({required String invoiceId}) async {
    try {
      final result = await client.get('/invoice/$invoiceId');
      return InvoiceModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<InvoiceModel>> getInvoices(
      {InvoiceStatus? status,
      int? limit,
      int? lastCreatedOn,
      bool? personal,
      String? groupId,
      String? companyId}) async {
    try {
      final data = {
        'company_id': companyId,
        'limit': limit,
        'last_created_on': lastCreatedOn,
        'personal': personal,
        'group_id': groupId,
        'status': status?.name.camelCaseToUnderScore(),
      };
      data.removeWhere((key, value) => value == null);
      final result = await client.get('/invoices', queryParameters: data);
      return (result.data as List<dynamic>)
          .map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<InvoiceGroupModel>> getInvoiceGroups(
      {String? companyId,
      bool? includeDeleted,
      int? limit,
      int? lastCreatedOn}) async {
    try {
      final data = {
        'company_id': companyId,
        'limit': limit,
        'last_created_on': lastCreatedOn,
        'include_deleted': includeDeleted,
      };
      data.removeWhere((key, value) => value == null);
      final result = await client.get('/invoice_groups', queryParameters: data);
      return (result.data as List<dynamic>)
          .map((e) => InvoiceGroupModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }
}
