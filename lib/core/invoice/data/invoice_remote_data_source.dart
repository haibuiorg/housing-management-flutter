import 'package:dio/dio.dart';
import 'package:priorli/core/invoice/data/invoice_data_source.dart';
import 'package:priorli/core/invoice/models/invoice_group_model.dart';
import 'package:priorli/core/invoice/models/invoice_model.dart';
import 'package:priorli/core/subscription/models/payment_product_item_model.dart';
import 'package:priorli/core/utils/string_extension.dart';

import '../../base/exceptions.dart';
import '../entities/invoice_status.dart';
import '../usecases/create_new_invoices.dart';

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
      required List<InvoiceItemParams> items,
      required bool sendEmail,
      bool? issueExternalInvoice}) async {
    try {
      final data = {
        'company_id': companyId,
        'receiver_ids': receiverIds,
        'invoice_name': invoiceName,
        'bank_account_id': bankAccountId,
        'payment_date': paymentDate,
        'items': items
            .map((e) => {
                  'quantity': e.quantity,
                  'payment_product_id': e.paymentProductId,
                })
            .toList(),
        'send_email': sendEmail,
        'issue_external_invoice': issueExternalInvoice ?? false,
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

  @override
  Future<InvoiceModel> sendInvoiceManually(
      {required String invoiceId,
      required List<String> emails,
      String? name,
      String? streetAddress1,
      String? streetAddress2,
      String? postalCode,
      String? city,
      String? countryCode}) async {
    try {
      final data = {
        'emails': emails,
        'new_receiver_name': name,
        'street_address_1': streetAddress1,
        'street_address_2': streetAddress2,
        'postal_code': postalCode,
        'city': city,
        'country_code': countryCode
      };
      data.removeWhere((key, value) => value == null);
      final result = await client.post('/invoice/$invoiceId', data: data);
      return InvoiceModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<PaymentProductItemModel> addPaymentProductItem(
      {required String companyId,
      required String name,
      required String description,
      required double price,
      required double taxPercentage}) async {
    final data = {
      'name': name,
      'description': description,
      'amount': price,
      'tax_percentage': taxPercentage,
      'company_id': companyId,
    };

    try {
      final result = await client
          .post('/housing_company/invoice/payment_product_item', data: data);
      return PaymentProductItemModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<bool> deletePaymentProductItem(
      {required String id, required String companyId}) async {
    try {
      await client.delete('/housing_company/invoice/payment_product_items',
          queryParameters: {'id': id, 'company_id': companyId});
      return true;
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<PaymentProductItemModel>> getPaymentProductItems(
      {required String companyId}) async {
    try {
      final result = await client.get(
          '/housing_company/invoice/payment_product_items',
          queryParameters: {'company_id': companyId});
      return (result.data as List<dynamic>)
          .map((e) =>
              PaymentProductItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }
}
